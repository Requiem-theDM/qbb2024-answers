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
                imageArray[:, :, i] -= np.amin(imageArray[:, :, i])
                imageArray[:, :, i] /= np.amax(imageArray[:, :, i])
            except: continue
        allImages.append(imageArray)

allImages = np.array(allImages)


