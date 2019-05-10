#!/usr/bin/python

'''
    File name: demo_faceTracking.py
    Author:       Ariana Familiar
    Date created: Nov 2017
    '''

'''
    File clarification:
        Shows how to use implemented functions to detect features and track face(s) in a video
'''

from loadVid import loadVid
from saveVid import saveVid
from faceTracking import faceTracking

# user definitions
inputName  = 'C:\Users\ericq\Downloads\CIS581Project4PartADatasets\Medium\TyrionLannister.mp4'
outputName = 'Lannister_result.avi'

# import video
rawVideo = loadVid(inputName);

# detect/track features
trackedVideo = faceTracking(rawVideo);

# save result to AVI file
saveVid(trackedVideo, outputName);



