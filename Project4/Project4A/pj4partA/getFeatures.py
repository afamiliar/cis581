'''
  File name: getFeatures.py
  Author: Prateek Singhal
  Date created: 11-21-2017
'''

'''
  File clarification:
    Detect features within each detected bounding box
    - Input img: the first frame (in the grayscale) of video
    - Input bbox: the four corners of bounding boxes
    - Output x: the x coordinates of features
    - Output y: the y coordinates of features
'''
import numpy as np
import sys
from corner_detector import corner_detector
import cv2
import matplotlib.pyplot as plt
import anms

def getFeatures(img, bbox):
  #TODO: Your code here
  faces_count = bbox.shape[0]
  bbox = bbox.astype(int)
  maxPoints = 50
  x = np.zeros((maxPoints,faces_count))
  y = np.zeros((maxPoints,faces_count))
  for i in range(0,faces_count):
    width = bbox[i,3,0] - bbox[i,0,0]
    height = bbox[i,1,1] - bbox[i,0,1]
    face_holder = np.zeros((height.astype(int),width.astype(int)))
    face_holder = img[bbox[i,0,1]:bbox[i,1,1], bbox[i,0,0]:bbox[i,3,0]]
    cface = corner_detector(face_holder)
    x1, y1, rmax1 = anms.anms(cface, maxPoints)
    #plt.imshow(face_holder, cmap='gray')
    #plt.scatter(x1, y1)
    #plt.show()
    x1 = x1.reshape((x1.size, 1))
    y1 = y1.reshape((y1.size, 1))
    x[:,i] = y1[:,0]
    y[:,i] = x1[:,0]
  return x,y
  #return x, y

#sys.path.append('/usr/local/lib/python2.7/site-packages')
#img = cv2.imread('/home/prateek/Documents/cis581/project4/PartA/Easy/video1/image1.jpg')
#gray_img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
#bbox = np.load('bbox.npy')
#getFeatures(gray_img, bbox)