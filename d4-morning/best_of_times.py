#!/usr/bin/env python3

#Establishes environment
import sys

sentence = sys.argv[1]
#These strip line returns, replace capitals with lowercase, and splits the sentence into a list
sentence = sentence.rstrip("\n")
sentence = sentence.lower()
sentence = sentence.split(" ")

for i in range(len(sentence)):
    #Strips out punctuation
    sentence[i] = sentence[i].replace(",","").replace(".","").replace(";","").replace(":","").replace("?","").replace("!","")

first = {}
for i in range(len(sentence)):
    word = sentence[i]
    first.setdefault(word,i)

print("\n")
print("This counts the first time we see a given word.")
print(first)


sentence = sys.argv[1]
#These strip line returns, replace capitals with lowercase, and splits the sentence into a list
sentence = sentence.rstrip("\n")
sentence = sentence.lower()

count = {}
for i in range(len(sentence)):
    letter = sentence[i]
    if letter ==  "," or letter == "." or letter == "?" or letter == "!" or letter == ";" or letter == ":":
        continue
    else:
        count.setdefault(letter,0)
        count[letter] += 1

print("\n")
print("This counts the occurrences of each letter, without counting punctuation.")
print(count)

metadata = [
 ["S001", "P001", "Heart"],
 ["S002", "P001", "Kidney"],
 ["S003", "P001", "Liver"],
 ["S004", "P002", "Heart"],
 ["S005", "P002", "Kidney"],
 ["S006", "P002", "Liver"],
 ["S007", "P003", "Heart"],
 ["S008", "P003", "Kidney"],
 ["S009", "P003", "Kidney"],
 ["S010", "P003", "Liver"]
 ]

metadict = {}
for i in range(len(metadata)):
    sample, patient, tissue = metadata[i]
    key = (patient, tissue)
    metadict.setdefault(key, [])
    metadict[key].append(sample)


print("\n")
for key, value in metadict.items():
    print(key[0], key[1], value)