'''
  File name: faceTracking.py
  Author:       Ariana Familiar
  Date created: Nov 2017
'''

'''
  File clarification:
    Generate a video with tracking features and bounding box for face regions
    - Input rawVideo: the video contains one or more faces
    - Output trackedVideo: the generated video with tracked features and bounding box for face regions
'''

from detectFace import detectFace
from getFeatures import getFeatures
from estimateAllTranslation import estimateAllTranslation
from applyGeometricTransformation import applyGeometricTransformation
from helper import rgb2gray
import numpy as np
import cv2

def faceTracking(rawVideo):
  #TODO: Your code here
  
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

        # track features from first frame to second using KLT procedure

        newX, newY = estimateAllTranslation(x, y, img1, img2)

        # apply resulting transformation
        newXs, newYs, bbox = applyGeometricTransformation(x, y, newX, newY, bbox)
        # apply tracked features and bounding box to frames, update output array
        for f in range(0,newXs.shape[1]):
            im = cv2.rectangle(img2,(int(bbox[f][0][0]),int(bbox[f][0][1])),(int(bbox[f][2][0]),int(bbox[f][2][1])),(0,0,0),3)
            for j in range(0,len(newXs)):
                im = cv2.circle(im, (int(newYs[j][f]), int(newXs[j][f])), 1, (0,0,255), 2)

        trackedVideo.append(im)

        ind = ind + 1       
        
        x = newXs
        y = newYs

    trackedVideo = np.array(trackedVideo)

    return trackedVideo
