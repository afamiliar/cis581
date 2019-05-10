
from loadVid import loadVid
from saveVid import saveVid
from faceTracking import faceTracking

inputName  = '../../CIS581Project4PartADatasets/Easy/TheMartian.mp4'
# inputName  = '../../CIS581Project4PartADatasets/Medium/TyrionLannister.mp4'
rawVideo = loadVid(inputName);

from detectFace import detectFace
from getFeatures import getFeatures
from estimateAllTranslation import estimateAllTranslation
from applyGeometricTransformation import applyGeometricTransformation
from helper import rgb2gray
import numpy as np
import cv2


ind = 0
trackedVideo = []
nFrames = len(rawVideo)

# detect faces
bbox = detectFace(rawVideo[0])

# detect features
gray_im = rgb2gray(rawVideo[0])
x, y = getFeatures(gray_im, bbox)

for f in range(0,x.shape[1]):
    x[:,f] = x[:,f]+bbox[f][0][1] # row coords
    y[:,f] = y[:,f]+bbox[f][0][0] # col coords


# detect faces
bbox = detectFace(rawVideo[0])

# detect features
gray_im = rgb2gray(rawVideo[0])
x, y = getFeatures(gray_im, bbox)

for f in range(0,x.shape[1]):
    x[:,f] = x[:,f]+bbox[f][0][1] # row coords
    y[:,f] = y[:,f]+bbox[f][0][0] # col coords

# get frames
img1 = rawVideo[ind]


cv2.rectangle(img1,(int(bbox[f][0][0]),int(bbox[f][0][1])),(int(bbox[f][2][0]),int(bbox[f][2][1])),(255,255,255),3)
for j in range(0,len(x)):
    cv2.circle(img1, (int(y[j][f]), int(x[j][f])), 1, (0,0,255), 2)
cv2.imshow('Frame 1',img1)

cv2.imwrite('Frame1.jpg',img1)


# ******************************************************************************************

ind = 0
trackedVideo = []
nFrames = len(rawVideo)

# detect faces
bbox = detectFace(rawVideo[0])

# detect features
gray_im = rgb2gray(rawVideo[0])
x, y = getFeatures(gray_im, bbox)

for f in range(0,x.shape[1]):
    x[:,f] = x[:,f]+bbox[f][0][1] # row coords
    y[:,f] = y[:,f]+bbox[f][0][0] # col coords

for i in range(0,nFrames-1): 
    if x.shape[0] < 15:
        # detect faces
        bbox = detectFace(rawVideo[0])
        # detect features
        gray_im = rgb2gray(rawVideo[0])
        x, y = getFeatures(gray_im, bbox)
        for f in range(0,x.shape[1]):
            x[:,f] = x[:,f]+bbox[f][0][1] # row coords
            y[:,f] = y[:,f]+bbox[f][0][0] # col coords
    # get frames
    img1 = rawVideo[ind]
    img2 = rawVideo[ind+1]
    # trac features from first frame to second using KLT procedure
    newX, newY = estimateAllTranslation(x, y, img1, img2)
    # apply resulting transformation
    newXs, newYs, bbox = applyGeometricTransformation(x, y, newX, newY, bbox)
    # apply tracked features and bounding box to frames, update output array
    for f in range(0,newXs.shape[1]):
        # im = cv2.rectangle(img2,(int(bbox[f][0][0]),int(bbox[f][0][1])),(int(bbox[f][2][0]),int(bbox[f][2][1])),(0,0,0),3)
        im = img2
        for j in range(0,len(newXs)):
            im = cv2.circle(im, (int(newYs[j][f]), int(newXs[j][f])), 1, (0,0,255), 2)
    trackedVideo.append(im)
    ind = ind + 1       
    x = newXs
    y = newYs
    print i




bbox = detectFace(rawVideo[0])
# detect features
gray_im = rgb2gray(rawVideo[0])
x, y = getFeatures(gray_im, bbox)
for f in range(0,x.shape[1]):
    x[:,f] = x[:,f]+bbox[f][0][1] # row coords
    y[:,f] = y[:,f]+bbox[f][0][0] # col coords

img1 = rawVideo[0]
cv2.rectangle(img1,(int(bbox[f][0][0]),int(bbox[f][0][1])),(int(bbox[f][2][0]),int(bbox[f][2][1])),(255,255,255),3)

# *** Martian ***
for j in range(0,len(x)):
	cv2.circle(img1, (int(y[j][f]), int(x[j][f])), 1, (255,0,0), 2)
	if j == 2 or j == 3 or j == 4 or j == 6 or j == 7 or j == 11 or j == 13 or j == 14 or j == 15 or j == 16 or j == 17 or j == 20 or j == 21 or j == 35 or j == 37 or j == 38 or j == 44 or j == 46:
		cv2.circle(img1, (int(y[j][f]), int(x[j][f])), 1, (0,0,255), 2)


# *** TyrionLannister ***
for j in range(0,len(x)):
	cv2.circle(img1, (int(y[j][f]), int(x[j][f])), 1, (255,0,0), 2)
	if j == 0 or j == 5 or j == 7 or j == 11 or j == 12 or j == 15 or j == 17 or j == 23 or j == 26 or j == 30 or j == 32 or j == 33 or j == 35 or j == 41 or j == 47 or j == 48 or j == 49 :
		cv2.circle(img1, (int(y[j][f]), int(x[j][f])), 1, (0,0,255), 2)

cv2.imwrite('Frame1_out.jpg',img1)
