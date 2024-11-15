#!/usr/bin/env python

import os
import numpy as np
import scipy
import matplotlib.pyplot as plt
import imageio
import plotly.express as px
import plotly


# Load all of the images into a single numpy array
allImages = []
filenames = []
fields = []
dyes = []

testImage = imageio.v3.imread("APEX1_field0_DAPI.tif").astype(np.uint16)
for filename in os.listdir("."):
    if filename.endswith(".tif"):
        filenames.append(filename.split("_")[0])
        fields.append(filename.split("_")[1])
        try: filename.split("_"[3])
        except: dyes.append(filename.split("_")[2].rstrip(".tif"))
        else: continue

filenames = list(dict.fromkeys(filenames))
fields = list(dict.fromkeys(fields))
dyes = list(dict.fromkeys(dyes))

for name in filenames:
    for field in fields:
        imageArray = np.zeros((testImage.shape[0],testImage.shape[1],3), np.uint16)
        for i, dye in enumerate(dyes):
            try:
                imageArray[:, :, i] = imageio.v3.imread(f"{name}_{field}_{dye}.tif")
                newimg = (imageArray[:, :, i] - np.amin(imageArray[:, :, i])) / (np.amax(imageArray[:, :, i]) - np.amin(imageArray[:, :, i]))
                newimg = np.round(newimg * 240).astype(np.uint8)
                imageArray[:, :, i] = newimg 
            except: continue
        allImages.append(imageArray)

allImages = np.array(allImages)

# Apply a Mask based on the DAPI channel
mask = []
for i in range(len(allImages[:])):
    mask.append(allImages[i,:,:,0] > np.average(allImages[i,:,:,0]))
mask = np.array(mask)

# Find labels by DAPI Mask

def find_labels(mask):
    # Set initial label
    l = 0
    # Create array to hold labels
    labels = np.zeros(mask.shape, np.int32)
    # Create list to keep track of label associations
    equivalence = [0]
    # Check upper-left corner
    if mask[0, 0]:
        l += 1
        equivalence.append(l)
        labels[0, 0] = l
    # For each non-zero column in row 0, check back pixel label
    for y in range(1, mask.shape[1]):
        if mask[0, y]:
            if mask[0, y - 1]:
                # If back pixel has a label, use same label
                labels[0, y] = equivalence[labels[0, y - 1]]
            else:
                # Add new label
                l += 1
                equivalence.append(l)
                labels[0, y] = l
    # For each non-zero row
    for x in range(1, mask.shape[0]):
        # Check left-most column, up  and up-right pixels
        if mask[x, 0]:
            if mask[x - 1, 0]:
                # If up pixel has label, use that label
                labels[x, 0] = equivalence[labels[x - 1, 0]]
            elif mask[x - 1, 1]:
                # If up-right pixel has label, use that label
                labels[x, 0] = equivalence[labels[x - 1, 1]]
            else:
                # Add new label
                l += 1
                equivalence.append(l)
                labels[x, 0] = l
        # For each non-zero column except last in nonzero rows, check up, up-right, up-right, up-left, left pixels
        for y in range(1, mask.shape[1] - 1):
            if mask[x, y]:
                if mask[x - 1, y]:
                    # If up pixel has label, use that label
                    labels[x, y] = equivalence[labels[x - 1, y]]
                elif mask[x - 1, y + 1]:
                    # If not up but up-right pixel has label, need to update equivalence table
                    if mask[x - 1, y - 1]:
                        # If up-left pixel has label, relabel up-right equivalence, up-left equivalence, and self with smallest label
                        labels[x, y] = min(equivalence[labels[x - 1, y - 1]], equivalence[labels[x - 1, y + 1]])
                        equivalence[labels[x - 1, y - 1]] = labels[x, y]
                        equivalence[labels[x - 1, y + 1]] = labels[x, y]
                    elif mask[x, y - 1]:
                        # If left pixel has label, relabel up-right equivalence, left equivalence, and self with smallest label
                        labels[x, y] = min(equivalence[labels[x, y - 1]], equivalence[labels[x - 1, y + 1]])
                        equivalence[labels[x, y - 1]] = labels[x, y]
                        equivalence[labels[x - 1, y + 1]] = labels[x, y]
                    else:
                        # If neither up-left or left pixels are labeled, use up-right equivalence label
                        labels[x, y] = equivalence[labels[x - 1, y + 1]]
                elif mask[x - 1, y - 1]:
                    # If not up, or up-right pixels have labels but up-left does, use that equivalence label
                    labels[x, y] = equivalence[labels[x - 1, y - 1]]
                elif mask[x, y - 1]:
                    # If not up, up-right, or up-left pixels have labels but left does, use that equivalence label
                    labels[x, y] = equivalence[labels[x, y - 1]]
                else:
                    # Otherwise, add new label
                    l += 1
                    equivalence.append(l)
                    labels[x, y] = l
        # Check last pixel in row
        if mask[x, -1]:
            if mask[x - 1, -1]:
                # if up pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x - 1, -1]]
            elif mask[x - 1, -2]:
                # if not up but up-left pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x - 1, -2]]
            elif mask[x, -2]:
                # if not up or up-left but left pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x, -2]]
            else:
                # Otherwise, add new label
                l += 1
                equivalence.append(l)
                labels[x, -1] = l
    equivalence = np.array(equivalence)
    # Go backwards through all labels
    for i in range(1, len(equivalence))[::-1]:
        # Convert labels to the lowest value in the set associated with a single object
        labels[np.where(labels == i)] = equivalence[i]
    # Get set of unique labels
    ulabels = np.unique(labels)
    for i, j in enumerate(ulabels):
        # Relabel so labels span 1 to # of labels
        labels[np.where(labels == j)] = i
    return labels

label_array = []
for i in range(len(mask[:])):
    label = find_labels(mask[i])
    label_array.append(label)
label_array = np.array(label_array)

# Filter Labels by Size
def filter_by_size(labels, minsize=100, maxsize=10000000):
    # Find label sizes
    sizes = np.bincount(labels.ravel())
    # Iterate through labels, skipping background
    for i in range(1, sizes.shape[0]):
        # If the number of pixels falls outsize the cutoff range, relabel as background
        if sizes[i] < minsize or sizes[i] > maxsize:
            # Find all pixels for label
            where = np.where(labels == i)
            labels[where] = 0
    # Get set of unique labels
    ulabels = np.unique(labels)
    for i, j in enumerate(ulabels):
        # Relabel so labels span 1 to # of labels
        labels[np.where(labels == j)] = i
    return labels

# Filter out everything below 100 pixels and above 10000000 pixels
for i in range(len(label_array[:])):
    label_array[i] = filter_by_size(label_array[i])

# Filter out everything below more than a standard deviation from the mean
for i in range(len(label_array[:])):
    sizes = np.bincount(label_array[i].ravel())[1:]
    print(sizes)
    mean = np.average(sizes)
    print(mean)
    sd = np.std(sizes)
    print(sd)
    label_array[i] = filter_by_size(label_array[i],mean-sd,mean+sd)