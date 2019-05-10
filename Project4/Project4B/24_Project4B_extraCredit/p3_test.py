'''
  File name: p3_test.py
  Author:  Ariana Familiar
  Date: 	 Dec 2017
'''

import PyNet as net
from p3_utils import *
from p3_dataloader import *
import math

'''
  network architecture construction
  - Stack layers in order based on the architecture of your network
'''

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

'''
  Define loss function
'''
loss_layer = net.Binary_cross_entropy_loss(True,"loss")

'''
  Define optimizer 
'''
lr        = .0001 #1*math.exp(-4)
decay     = .0005 #5*math.exp(-4)
momentum  = .99
optimizer = net.SGD_Optimizer(lr, decay, momentum)

'''
  Build model
'''
my_model = net.Model(layer_list, loss_layer, optimizer)

'''
  Define the number of input channel and initialize the model
'''
my_model.set_input_channel(3) # input is num channels (e.g. 3 for RGB image)


'''
  load pretrained model and testing data
'''
my_model.load_model('trained_model.pickle')

nSamples = 10
data_set, label_set = dataloader('testing',nSamples)

losses = np.zeros(nSamples)
ssd    = np.zeros(nSamples)
for i in range(nSamples):

  # batch_size = 1
  # data_bt, label_bt = obtainMiniBatch(data_set[1],label_set[1],batch_size)
  data_bt  = data_set[i]
  label_bt = label_set[i]
  data_bt  = data_bt[np.newaxis,:]
  label_bt = label_bt[np.newaxis,:]

  '''
    pre-process data
    1. normalization
    2. convert ground truth data 
    3. resize data into the same size
  '''

  # normalize
  data_bt = normRGB(data_bt)

  # ground truth label
  h = data_set[0].shape[0]
  w = data_set[0].shape[1]
  label_bt = net.get_gt_map(label_bt,h,w)

  # shift data_set dim's for proper input (N,C,w,h)
  data_bt = np.moveaxis(data_bt, -1, 0)
  data_bt = np.swapaxes(data_bt, 0, 1)

  # make input image and converted gt label same size (40 x 40)
  label_bt = net.upsample2d(label_bt,(40,40))
  data_bt  = net.upsample2d(data_bt,(40,40))


  '''
    test model
  '''

  losses[i], pred = my_model.forward(data_bt, label_bt)

  indices1 = np.where(label_bt[0][0] == label_bt[0][0].max())
  indices2 = np.where(pred[0,0,:,:] == pred[0,0,:,:].max())
  ssd1 = math.sqrt((indices1[0][0] - indices2[0][0])**2 + (indices1[1][0] - indices2[1][0])**2)

  indices1 = np.where(label_bt[0][1] == label_bt[0][1].max())
  indices2 = np.where(pred[0,1,:,:] == pred[0,1,:,:].max())
  ssd2 = math.sqrt((indices1[0][0] - indices2[0][0])**2 + (indices1[1][0] - indices2[1][0])**2)

  indices1 = np.where(label_bt[0][2] == label_bt[0][2].max())
  indices2 = np.where(pred[0,2,:,:] == pred[0,2,:,:].max())
  ssd3 = math.sqrt((indices1[0][0] - indices2[0][0])**2 + (indices1[1][0] - indices2[1][0])**2)

  indices1 = np.where(label_bt[0][3] == label_bt[0][3].max())
  indices2 = np.where(pred[0,3,:,:] == pred[0,3,:,:].max())
  ssd4 = math.sqrt((indices1[0][0] - indices2[0][0])**2 + (indices1[1][0] - indices2[1][0])**2)

  indices1 = np.where(label_bt[0][4] == label_bt[0][4].max())
  indices2 = np.where(pred[0,4,:,:] == pred[0,4,:,:].max())
  ssd5 = math.sqrt((indices1[0][0] - indices2[0][0])**2 + (indices1[1][0] - indices2[1][0])**2)

  ssd[i] = np.average([ssd1,ssd2,ssd3,ssd4,ssd5])

