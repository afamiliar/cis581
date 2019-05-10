'''
  File name: detectFace.py
  Author: Prateek Singhal
  Date created: 11-20-2017
'''

'''
  File clarification:
    Detect or hand-label bounding box for all face regions
    - Input img: the first frame of video
    - Output bbox: the four corners of bounding boxes for all detected faces
'''
import numpy as np
import cv2
import matplotlib.pyplot as plt
import sys

def detectFace(img):
  #TODO: Your code here
  gray_img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
  face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_alt.xml')
  faces = face_cascade.detectMultiScale(gray_img, 1.1, 5)
  bbox = np.zeros((faces.shape[0], 4,2))
  i = 0
  for (x,y,w,h) in faces:
 	#print x,y,w,h
  	cv2.rectangle(gray_img,(x,y),(x+w,y+h),(255,0,0),2)
  	bbox[i,:,:] = np.array([[x,y], [x,y+h], [x+w,y+h], [x+w,y]])
  	i = i+1
  #plt.imshow(gray_img, 'gray')
  #plt.show()
  #np.save('bbox', bbox)
  return bbox


#sys.path.append('/usr/local/lib/python2.7/site-packages')
#img = cv2.imread('/home/prateek/Documents/cis581/project4/PartA/Easy/video1/image1.jpg')
#detectFace(img)