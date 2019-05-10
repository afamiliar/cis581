'''
  File name: estimateFeatureTranslation.py
  Author:       Ariana Familiar
  Date created: Nov 2017
'''

'''
  File clarification:
    Estimate the translation for single features 
    - Input startX: the x coordinate for single feature wrt the first frame
    - Input startY: the y coordinate for single feature wrt the first frame
    - Input Ix: the gradient along the x direction
    - Input Iy: the gradient along the y direction
    - Input img1: the first image frame
    - Input img2: the second image frame
    - Output newX: the x coordinate for the feature wrt the second frame
    - Output newY: the y coordinate for the feature wrt the second frame
'''

import numpy as np
import cv2
from helper import rgb2gray
import scipy
import sys
# from helper import getPatch

def estimateFeatureTranslation_new(startX, startY, Ix, Iy, img1, img2):
  #TODO: Your code here

    if np.ndim(img1) == 3:
        img1 = rgb2gray(img1)
    if np.ndim(img2) == 3:
        img2 = rgb2gray(img2)

    win_width   = 10
    win_height  = 10
    nr = win_height/2
    nc = win_width/2

    im1_patch = getPatch(img1, startY, startX, win_width, win_height);

    newX = []
    newY = []
    sXtemp = startX
    sYtemp = startY
    x, y = np.meshgrid(range(0,np.shape(im1_patch)[0]),range(0,np.shape(im1_patch)[1]))
    patch_center = np.hstack((np.shape(im1_patch)[0]/2,np.shape(im1_patch)[1]/2))
    x = x-patch_center[0]
    y = y-patch_center[1]
    x = x+startX
    y = y+startY

    im2_patch = getPatch(img2, startY, startX, win_width, win_height);
    Ix_patch = getPatch(Ix, startY, startX, win_width, win_height);
    Iy_patch = getPatch(Iy, startY, startX, win_width, win_height);

    # W1 = scipy.interpolate.interp2d(img1, x, y, kind='linear') 
    # W2 = scipy.interpolate.interp2d(im2_patch, x, y, kind='linear') 
    # dx1 = scipy.interpolate.interp2d(Ix_patch, x, y, kind='linear') 
    # dy1 = scipy.interpolate.interp2d(Iy_patch, x, y, kind='linear') 
    W1 = im1_patch
    W2 = im2_patch
    dx1 = Ix_patch
    dy1 = Iy_patch

    It = W2-W1
    I1x = dx1**2
    I1y = dy1**2
    I1xy = dx1*dy1
    SigX1 = np.sum(I1x)
    SigY1 = np.sum(I1y)
    SigXY1 = np.sum(I1xy)
    SigXIT = np.sum(dx1*It)
    SigYIT = np.sum(dy1*It)

    M = np.vstack(((SigX1, SigXY1),(SigXY1, SigY1)))
    if np.linalg.cond(M) < 1/sys.float_info.epsilon: # if M is not singular
        
        a = np.array([[SigX1,SigXY1],[SigXY1,SigY1]])
        b = -np.array([[SigXIT],[SigYIT]])
        UVMat = np.linalg.solve(a,b)
        u = UVMat.item(0)
        v = UVMat.item(1)

        old_xrange = x
        old_yrange = y
        new_xrange = x
        new_yrange = y
        oldscore = np.sum((W2-W1)**2)
        stopscore = 9999
        count = 1
        xtemp = 0
        ytemp = 0

        startX = []
        startY = []
        while stopscore > .1 and count < 40  :
            #recompute window, matrix, u,v
            startX = new_xrange[0,x.shape[0]/2]
            startY = new_yrange[x.shape[1]/2,0]
            Wprime = getPatch(img2, startY, startX, win_width, win_height);
            if (Wprime.shape!=W1.shape):
                break
            It = Wprime-W1
            SigXIT = np.sum(dx1*It)
            SigYIT = np.sum(dy1*It)
            M = np.vstack(((SigX1, SigXY1),(SigXY1, SigY1)))
            a = np.array([[SigX1,SigXY1],[SigXY1,SigY1]])
            b = -np.array([[SigXIT],[SigYIT]])
            UVMat = np.linalg.solve(a,b)
            u = UVMat.item(0)
            v = UVMat.item(1)
            new_xrange_t = old_xrange + u
            new_yrange_t = old_yrange + v
            newscore = np.sum((W2-Wprime)**2)
            #in case loop goes past optimal (which is not w/in range of
            #stopping condition)
            if (oldscore < newscore):
                break
            stopscore = np.absolute(oldscore-newscore)
            oldscore = newscore
            old_xrange = new_xrange
            old_yrange = new_yrange
            new_xrange = new_xrange_t
            new_yrange = new_yrange_t
            #keep track of path
            xtemp = xtemp + u
            ytemp = ytemp + v
            count = count+1

        if np.any(np.absolute(xtemp)<win_width) and np.any(np.absolute(ytemp)<win_width) :
            newX = sXtemp + xtemp
            newY = sYtemp + ytemp
        else:
            newX = sXtemp
            newY = sYtemp
    else:
        newX = sXtemp
        newY = sYtemp

    return newX, newY

# *********************************************************************
# getPatch
#
#   returns subsection of input image based on provided coordinates

def getPatch(img, x, y, width, height):
    nr = height/2
    nc = width/2
    sy = int(y-nr)
    ey = int(y+nr)
    sx = int(x-nr)
    ex = int(x+nr)
    patch = img[sy:ey, sx:ex]

    return patch