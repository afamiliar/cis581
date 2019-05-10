import numpy as np
import cv2

# ******************************************************************
# loadVid
#
#   loads video of given input name, outputs frames

def loadVid(inputName):

	vid = cv2.VideoCapture(inputName)

	ind = 0;
	while(vid.isOpened()):
	    ret, frame = vid.read()
	    
	    frames[ind] = frame
	    
	    ind = ind + 1;

	vid.release()
	cv2.destroyAllWindows()

	return frames

# *********************************************************************
# rgb2gray
#
#	converts RGB image to grayscale

def rgb2gray(rgb):
    return np.dot(rgb[...,:3], [0.299, 0.587, 0.114])

# *********************************************************************
# compGrad
#
#	computes and outputs gradient of image in x and y directions
#	based on   genEngMap.py  by Haoyuan(Steve) Zhang

def compGrad(img):
    if np.ndim(img) == 3:
        img = rgb2gray(img)

    img = img.astype(np.float64())
    img = cv2.GaussianBlur(img,(3,3),0)
    
#    Ix = cv2.Sobel(img,cv2.CV_64F,1,0,ksize=3)
#    Iy = cv2.Sobel(img,cv2.CV_64F,0,1,ksize=3)
    Ix, Iy = np.gradient(img);
    
    return Ix, Iy
