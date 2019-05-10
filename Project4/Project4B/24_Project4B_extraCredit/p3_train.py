'''
  File name: p3_train.py
  Author:    Ariana Familiar
  Date: 	   Dec 2017
'''

import PyNet as net
from p3_utils import *
from p3_dataloader import *
import math
import time

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
  Input possible pre-trained model
'''
# my_model.load_model('preMolde.pickle')


'''
  Main training process
  - train N epochs, each epoch contains M steps, each step feed a batch-sized data for training,
    that is, total number of data = M * batch_size, each epoch need to traverse all data.
'''

# obtain data 
nSamples = 'all' #100
data_set, label_set = dataloader('training',nSamples)

'''
  pre-process data
  1. normalization
  2. convert ground truth data 
  3. resize data into the same size
'''

# normalize
data_set = normRGB(data_set)

# ground truth label
h = data_set[0].shape[0]
w = data_set[0].shape[1]
label_set = net.get_gt_map(label_set,h,w)

# shift data_set dim's for proper input (N,C,w,h)
data_set = np.moveaxis(data_set, -1, 0)
data_set = np.swapaxes(data_set, 0, 1)

# make input image and converted gt label same size (40 x 40)
label_set = net.upsample2d(label_set,(40,40))
data_set  = net.upsample2d(data_set,(40,40))

'''
  train model
'''

max_epoch_num = 4 # 4 or 5
start_time    = time.time()
for i in range(max_epoch_num):
  print "epoch: "+str(i+1)+"/"+str(max_epoch_num)
  '''
    random shuffle data 
  '''
  data_set_cur, label_set_cur = randomShuffle(data_set, label_set) # design function by yourself
  step = 45000  # step is a int number
  loss = np.zeros(step)
  ssd  = np.zeros(step)
  for j in range (step):
    # obtain a mini batch for this step training
    batch_size = 1
    data_bt, label_bt = obtainMiniBatch(data_set_cur,label_set_cur,batch_size)  # design function by yourself

    # feedward data and label to the model
    loss[j], pred = my_model.forward(data_bt, label_bt)

    # backward loss
    my_model.backward(loss[j])

    # update parameters in model
    my_model.update_param()

    # caluclate ssd
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
    ssd[j] = np.average([ssd1,ssd2,ssd3,ssd4,ssd5])

    if j % 5000 == 0:
      print "step: "+str(j+1)+"/"+str(step)
      elapsed_time = time.time() - start_time
      print "elapsed time: "+str(elapsed_time/60/60)+' hours'

  '''
    save trained model, the model should be saved as a pickle file
  '''
  my_model.save_model('epoch' + str(i) + '.pickle')
  np.savetxt('epoch' + str(i) + '_loss.txt',loss)
  np.savetxt('epoch' + str(i) + '_ssd.txt',ssd)


