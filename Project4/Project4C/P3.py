# -*- coding: utf-8 -*-
"""
Created on Sat Dec 16 14:25:45 2017

@author: ericq
"""

import PyNet as net
import p3_utils as u
# import p3_dataloader as d
import numpy as np
import cv2
import morph_tri as m
# import seamlessCloningPoisson as cp

from helper import *

#####################################################

#cap = cv2.VideoCapture(0)
#
#while(True):
#    # Capture frame-by-frame
#    ret, frame = cap.read()
#
#    # Our operations on the frame come here
#    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
#
#    # Display the resulting frame
#    cv2.imshow('frame',gray)
#    if cv2.waitKey(1) & 0xFF == ord('q'):
#        break
#
## When everything done, release the capture
#cap.release()
#cv2.destroyAllWindows()

##################################################

#cap = cv2.VideoCapture('Easy\MrRobot.avi')
#
#while(cap.isOpened()):
#    ret, frame = cap.read()
#
#    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
#
#    cv2.imshow('frame',gray)
#    if cv2.waitKey(1) & 0xFF == ord('q'):
#        break
#
#cap.release()
#cv2.destroyAllWindows()

####################################################

vid1 = cv2.VideoCapture('CIS581Project4PartCDatasets/Easy/MrRobot.mp4')
vid2 = cv2.VideoCapture('CIS581Project4PartCDatasets/Easy/FrankUnderwood.mp4')

while(vid1.isOpened() and vid2.isOpened()):
    # ==== get frames ==== 
    ret, frame1 = vid1.read()
    ret, frame2 = vid2.read()
    frame2 = cv2.resize(frame2,(0,0),fx=0.5,fy=0.5)

    # ==== detect corresponding points ==== 
    # use 4B CNN to find facial landmarks
    points1 = findFeats(frame1)
    points2 = findFeats(frame2)

    # add bounding box points
    bbox1 = detectFace(frame1)
    bbox2 = detectFace(frame2)

    for i in range(len(bbox1[0])):
        points1.append([int(bbox1[0][i][0]),int(bbox1[0][i][1])])
        points2.append([int(bbox2[0][i][0]),int(bbox2[0][i][1])])

    # ==== perform warping ==== 
    hull11 = []
    hull12 = []
    hull21 = []
    hull22 = []
            
    hullIndex1 = cv2.convexHull(np.array(points1), returnPoints = False)
    hullIndex2 = cv2.convexHull(np.array(points2), returnPoints = False)
    
    for i in xrange(0, len(hullIndex1)):
        hull11.append(points1[int(hullIndex1[i])])
        hull12.append(points2[int(hullIndex1[i])])
        
    for i in xrange(0, len(hullIndex2)):
        hull21.append(points1[int(hullIndex2[i])])
        hull22.append(points2[int(hullIndex2[i])])
    
    hull8U = []
    for i in xrange(0, len(hull22)):
        hull8U.append((hull22[i][0], hull22[i][1]))
    mask2 = np.zeros(frame2.shape, dtype = frame2.dtype)  
    cv2.fillConvexPoly(mask2, np.int32(hull8U), (255, 255, 255))
    mask2 = cv2.cvtColor(mask2, cv2.COLOR_BGR2GRAY)
    
    hull8U = []
    for i in xrange(0, len(hull11)):
        hull8U.append((hull11[i][0], hull11[i][1]))
    mask1 = np.zeros(frame1.shape, dtype = frame1.dtype)  
    cv2.fillConvexPoly(mask1, np.int32(hull8U), (255, 255, 255))
    mask1 = cv2.cvtColor(mask1, cv2.COLOR_BGR2GRAY)
    
    size1 = frame1.shape
    size2 = frame2.shape
    points1 = np.vstack([points1,[[0,0],[size1[1],0],[0,size1[0]],[size1[1],size1[0]]]])
    points2 = np.vstack([points2,[[0,0],[size2[1],0],[0,size2[0]],[size2[1],size2[0]]]])
    
    frame1to2 = m.morph_tri(frame1, frame2, points1, points2, np.array([1]), np.array([0]))
    frame2to1 = m.morph_tri(frame2, frame1, points2, points1, np.array([1]), np.array([0]))
    
#    mask2 = mask2 != 0
#    mask1 = mask1 != 0
#    
#    frame2w = cp.seamlessCloningPoisson(frame1to2,frame2,mask2,0,0)
#    frame1w = cp.seamlessCloningPoisson(frame2to1,frame1,mask1,0,0)
    mask2 = [[mask2],[mask2],[mask2]]
    mask2 = np.array(mask2)
    mask2 = mask2[:,0,:,:]
    mask2 = np.swapaxes(mask2,0,2)
    mask2 = np.swapaxes(mask2,0,1)
    mask2 = (mask2[:,:,:]!=0)
    mask2 = [[mask2],[mask2],[mask2]]
    
    mask1 = [[mask1],[mask1],[mask1]]
    mask1 = np.array(mask1)
    mask1 = mask1[:,0,:,:]
    mask1 = np.swapaxes(mask1,0,2)
    mask1 = np.swapaxes(mask1,0,1)
    mask1 = (mask1[:,:,:]!=0)
    mask1 = [[mask1],[mask1],[mask1]]
    mask2to1 = mask1*frame2to1[0,:,:,:]
    mask2to1 = mask2to1[0,:,:,:]
    mask1to2 = mask2*frame1to2[0,:,:,:]
    mask1to2 = mask1to2[0,:,:,:]
    
    frame1to2 = frame2+mask1to2
    frame2to1 = frame1+mask2to1
    frame1to2 = frame1to2[0,:,:,:]
    frame2to1 = frame2to1[0,:,:,:]
    break