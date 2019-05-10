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
# from helper import getPatch

def estimateFeatureTranslation(startX, startY, Ix, Iy, img1, img2):
  #TODO: Your code here
  
    # if np.ndim(img1) == 3:
    #     img1 = rgb2gray(img1)
    # if np.ndim(img2) == 3:
    #     img2 = rgb2gray(img2)

    win_width   = 10
    win_height  = 10
          
    nr = win_height/2
    nc = win_width/2
    
    newX = []
    newY = []
    
    # keep within image boundaries
    if startY-nr>0 and startX-nc>0 and startY+nr<img1.shape[0] and startX+nc<img1.shape[1]:
  
        # extract an image patch (10 x 10 window) from first image (centered on startX, startY)
        im1_patch = getPatch(img1, startX, startY, win_width, win_height);
  
        # use starting location of search in second image and patches to track a feature point from image 1 to 2
        p         = [0, 0, 0, 0, 2, 3]
        delta_p   = 7
        threshold = 0.01
    
        x, y = np.meshgrid(range(0,np.shape(im1_patch)[0]),range(0,np.shape(im1_patch)[1]))
        patch_center = np.hstack((np.shape(im1_patch)[0]/2,np.shape(im1_patch)[1]/2))
        x = x-patch_center[0]
        y = y-patch_center[1]
        
        It = rgb2gray(img2-img1)
        
        It_patch = getPatch(It, startX, startY, win_width, win_height)
        Ix_patch = getPatch(Ix, startX, startY, win_width, win_height)
        Iy_patch = getPatch(Iy, startX, startY, win_width, win_height)
        
        Ixx_patch = Ix_patch*Ix_patch
        Iyy_patch = Iy_patch*Iy_patch
        Ixy_patch = Ix_patch*Iy_patch
        Ixt_patch = Ix_patch*It_patch
        Iyt_patch = Iy_patch*It_patch
        
        a = np.array([[np.sum(Ixx_patch),np.sum(Ixy_patch)],[np.sum(Ixy_patch),np.sum(Iyy_patch)]])
        b = -np.array([[np.sum(Ixt_patch)],[np.sum(Iyt_patch)]])
        x = np.linalg.solve(a,b)
        u = x.item(0)
        v = x.item(1)
        
        newX = startX + u
        newY = startY + v

#        while np.linalg.norm(delta_p) > threshold: # L2 norm of vector delta_p
#            # affine matrix
#            W_p = np.vstack(( [1+p[0], p[2], p[4]], [p[1], 1+p[3], p[5]] ))
#            # warp img
#            img2_patch = getPatch(img2, startX, startY, win_width, win_height);            
#            img2_warped = cv2.warpAffine(img2_patch,W_p,(img2_patch.shape[1],img2_patch.shape[0]))
#            # subtract warp from original (temporal gradient)
#            img_err = im1_patch - img2_warped
#            # img_err = getPatch(im_temp, startX, startY, win_width, win_height);
#            # img_err = im1_patch - img_warped
#            # break if outside image boundaries
#            if p[4]>img2.shape[0]-1 or p[5]>img2.shape[1]-1 or p[4]<0 or p[5]<0 :
#                break
#            # warp gradient
#            Ix_patch = getPatch(Ix, startX, startY, win_width, win_height);
#            Iy_patch = getPatch(Iy, startX, startY, win_width, win_height);
#            Ix_warped = cv2.warpAffine(Ix_patch,W_p,(win_width, win_height))
#            Iy_warped = cv2.warpAffine(Iy_patch,W_p,(win_width, win_height))
#            # evaluate Jacobian of the warp
#            x_coord = x.flatten()
#            x_coord = np.array([x_coord])
#            x_coord = x_coord.T
#            y_coord = y.flatten()
#            y_coord = np.array([y_coord])
#            y_coord = y_coord.T
#            Jacobian_x = np.hstack(([x_coord, np.zeros((np.shape(x_coord))), y_coord, np.zeros((np.shape(x_coord))), np.ones((np.shape(x_coord))), np.zeros((np.shape(x_coord)))]))
#            Jacobian_y = np.hstack(([np.zeros((np.shape(x_coord))), x_coord, np.zeros((np.shape(x_coord))), y_coord, np.zeros((np.shape(x_coord))), np.ones((np.shape(x_coord)))]))
#            # compute steepest descent
#            I_steepest = np.zeros((im1_patch.size, 6))
#            Ix_warped = Ix_warped.flatten()
#            Iy_warped = Iy_warped.flatten()
#            for j in range(0, x.size):
#                Jacobian = np.vstack((Jacobian_x[j,:], Jacobian_y[j,:]))
#                grad = np.hstack((Ix_warped[j], Iy_warped[j]))
#                I_steepest[j,range(0,6)] = grad.dot(Jacobian)
#            # compute Hessian
#            H = np.zeros((6,6))
#            for j in range(0, x.size):
#                H = H + I_steepest[j][:].flatten().dot(I_steepest[j][:])
#            # multipy steepest descend with error
#            final = np.zeros((6,1))
#            img_err = img_err.flatten()
#            for j in range(0, x.size):
#                I_steep = I_steepest[j][:]
#                I_steep = np.array([I_steep])
#                I_steep = I_steep.T
#                final = final + I_steep.dot(img_err[j])
#            # compute delta_p
#            delta_p = np.linalg.lstsq(H, final)[0]
#            # update p
#            p = p + delta_p.flatten()
#
#        newX = p[5]
#        newY = p[4]

    # else:
    #     newX = [];
    #     newY = [];
    
    return newX, newY



# *********************************************************************
# warp

def warp(img,x,y,W_p):
    # calculate transformed coord's
    # lX = W_p[0,0].dot(x) + W_p[0,1].dot(y) + W_p[0,2]
    # lY = W_p[1,0].dot(x) + W_p[1,1].dot(y) + W_p[1,2]
    lX = np.dot(W_p[0,0],x) + np.dot(W_p[0,1],y) + W_p[0,2]
    lY = np.dot(W_p[1,0],x) + np.dot(W_p[1,1],y) + W_p[1,2]
    
    # get neighbors
    b0X = np.floor(lX)
    b0Y = np.floor(lY)
    b1X = b0X + 1
    b1Y = b0Y + 1
    
    # linear interpolation constants (%)
    cX = lX - b0X
    cY = lY - b0Y
    per0 = (1 - cX) * (1 - cY)
    per1 = (1 - cX) * cY
    per2 = cX * (1 - cY)
    per3 = cX * cY
    
    # keep within boundaries
    b0Xind = b0X<0 or b0X>img.shape[0]-1
    b0Yind = b0Y<0 or b0Y>img.shape[1]-1
    b0X[b0Xind] = 0;
    b0Y[b0Yind] = 0;
    
    b1Xind = b1X<0 or b1X>img.shape[0]-1
    b1Yind = b1Y<0 or b1Y>img.shape[1]-1
    b1X[b1Xind] = 0;
    b1Y[b1Yind] = 0;
    
    # compute warp
    # img_warped = np.zeros(([len(x), img.shape[2]]))
    im = img[:,:].copy()
        
    xyz0 = im(1+b0X+b0Y*img.shape[0])
    xyz1 = im(1+b0X+b1Y*img.shape[0])
    xyz2 = im(1+b1X+b0Y*img.shape[0])
    xyz2 = im(1+b1X+b1Y*img.shape[0])
    
    img_warp = xyz0*per0 + xyz1*per1 + xyz2*per2 + xyz3*per3
    
    img_warped[:,:] = img_warp.reshape([x.shape[0], x.shape[1]], order='F').copy()

    return img_warped

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
