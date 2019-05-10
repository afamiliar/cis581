'''
  File name: estimateAllTranslation.py
  Author:       Ariana Familiar
  Date created: Nov 2017
'''

'''
  File clarification:
    Estimate the translation for all features for each bounding box as well as its four corners
    - Input startXs: all x coordinates for features wrt the first frame
    - Input startYs: all y coordinates for features wrt the first frame
    - Input img1: the first image frame
    - Input img2: the second image frame
    - Output newXs: all x coordinates for features wrt the second frame
    - Output newYs: all y coordinates for features wrt the second frame
'''

import numpy as np
# from estimateFeatureTranslation import estimateFeatureTranslation
from estimateFeatureTranslation_new import estimateFeatureTranslation_new
from helper import compGrad
# from helper import rgb2gray

def estimateAllTranslation(startXs, startYs, img1, img2):
  #TODO: Your code here
  
    # precompute gradients for second frame (img2)
    Ix, Iy = compGrad(img2);
        # might have to use conv2 instead of np.gradient?

    newXs = []
    newYs = []
    # for each face
    for f in range(0, startXs.shape[1]):
        # estimate the translation for each feature separately
        Xs = startXs[:,f]
        Ys = startYs[:,f]
        nXs = []
        nYs = []
        for i in range(0, startXs.shape[0]):
            coords = estimateFeatureTranslation_new(Xs[i], Ys[i], Ix, Iy, img1, img2);
            nXs = np.hstack((nXs,(coords[0])))
            nYs = np.hstack((nYs,(coords[1])))
        newXs = np.hstack((newXs,nXs))
        newYs = np.hstack((newYs,nYs))
    newXs = np.array([newXs])
    newYs = np.array([newYs])
    newXs = newXs.T
    newYs = newYs.T

    return newXs, newYs
