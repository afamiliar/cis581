import PyNet as net
from p3_utils import *
import numpy as np
import cv2

def findFeats(data_bt):
	h = data_bt.shape[0]
	w = data_bt.shape[1]
	layer_list = [	
	                net.Conv2d(64,5,2,1,True,"conv1"),     # convolution 1
	                net.BatchNorm2D(.9,"norm1"),
	                net.Relu("relu1"),
	                net.Conv2d(64,5,2,1,True,"conv2"),     # convolution 2
	                net.BatchNorm2D(.9,"norm2"),
	                net.Relu("relu2"),
	                net.MaxPool2d(2,0,2,"pool1"), 		      # pooling 1
	                net.Conv2d(128,5,2,1,True,"conv3"),    # convolution 3
	                net.BatchNorm2D(.9,"norm3"),
	                net.Relu("relu3"),
	                net.Conv2d(128,5,2,1,True,"conv4"),    # convolution 4
	                net.BatchNorm2D(.9,"norm4"),
	                net.Relu("relu4"),
	                net.MaxPool2d(2,0,2,"pool2"), 		      # pooling 2
	                net.Conv2d(384,3,1,1,True,"conv5"),    # convolution 5
	                net.BatchNorm2D(.9,"norm5"),
	                net.Relu("relu5"),
	                net.Conv2d(384,3,1,1,True,"conv6"),    # convolution 6
	                net.BatchNorm2D(.9,"norm6"),
	                net.Relu("relu6"),
	                net.Conv2d(5,3,1,1,True,"conv7"),      # convolution 7
	                net.BatchNorm2D(.9,"norm7"),
	                net.Sigmoid("sigmoid"),
	                net.Upsample(scale=4,name="upsample")   # upsample
	             ]

	loss_layer = net.Binary_cross_entropy_loss(True,"loss")
	lr        = .0001
	decay     = .0005
	momentum  = .99
	optimizer = net.SGD_Optimizer(lr, decay, momentum)
	my_model  = net.Model(layer_list, loss_layer, optimizer)
	my_model.set_input_channel(3) # input is num channels (e.g. 3 for RGB image)

	my_model.load_model('trained_model.pickle')

	data_bt  = data_bt[np.newaxis,:]

	# normalize
	data_bt = normRGB(data_bt)

	# shift data_set dim's for proper input (N,C,w,h)
	data_bt = np.moveaxis(data_bt, -1, 0)
	data_bt = np.swapaxes(data_bt, 0, 1)

	# make input image and converted gt label same size (40 x 40)
	data_bt  = net.upsample2d(data_bt,(40,40))

	pred = my_model.forward(data_bt)

	pred = net.upsample2d(pred,(h,w))

	lEye   = np.where(pred[0,0,:,:] == pred[0,0,:,:].max())
	rEye   = np.where(pred[0,1,:,:] == pred[0,1,:,:].max())
	nose   = np.where(pred[0,2,:,:] == pred[0,2,:,:].max())
	lMouth = np.where(pred[0,3,:,:] == pred[0,3,:,:].max())
	rMouth = np.where(pred[0,4,:,:] == pred[0,4,:,:].max())

	features = [[lEye[1][0],lEye[0][0]],
						 [rEye[1][0],rEye[0][0]],
						 [nose[1][0],nose[0][0]],
						 [lMouth[1][0],lMouth[0][0]],
						 [rMouth[1][0],rMouth[0][0]]]

	return features

def detectFace(img):
  gray_img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
  face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_alt.xml')
  faces = face_cascade.detectMultiScale(gray_img, 1.1, 5)
  bbox = np.zeros((faces.shape[0], 4,2))
  i = 0
  for (x,y,w,h) in faces:
  	cv2.rectangle(gray_img,(x,y),(x+w,y+h),(255,0,0),2)
  	bbox[i,:,:] = np.array([[x,y], [x,y+h], [x+w,y+h], [x+w,y]])
  	i = i+1

  return bbox
