'''
  File name: corner_detector.py
  Author: Phil Perilstein
  Date created: 11/7/2017
'''

import skimage.feature
def corner_detector(img):
  #cimg = skimage.feature.corner_harris(img)
  cimg = skimage.feature.corner_harris(img, method='k', k=0.05, eps=1e-06, sigma=1)
  return cimg