'''
  File name: p3_train.py
  Author:  Eric Quesada
  Date: 	 Dec 2017
'''

import PyNet as net
import numpy as np
import p2_utils as u
import time
import matplotlib.pyplot as plt

'''
  network architecture construction
  - Stack layers in order based on the architecture of your network
'''

layer_list = [  
                net.Flatten(),
                net.Linear(16,4,"Lin1",True),
                net.Sigmoid("Sig1"),
                net.Linear(4,1,"Lin2",True),
                net.Sigmoid("Sig2")
             ]

'''
  Define loss function
'''
loss_layer = net.L2_loss(True,"Loss")

'''
  Define optimizer 
'''
optimizer = net.SGD_Optimizer(.1,.0005,.99)

'''
  Build model
'''
my_model = net.Model(layer_list, loss_layer, optimizer)

'''
  Define the number of input channel and initialize the model
'''
my_model.set_input_channel(3) # input is num channels (e.g. 3 for RGB image)

'''
  Main training process
  - train N epochs, each epoch contains M steps, each step feed a batch-sized data for training,
    that is, total number of data = M * batch_size, each epoch need to traverse all data.
'''

# obtain data 
im_name = 'p21_random_imgs.npy'
lb_name = 'p21_random_labs.npy'
data_set = np.load(im_name)
label_set = np.load(lb_name)

max_epoch_num = 1000
start_time = time.time()
step = 1  # step is a int number
batch_size = 64
losses = []
accuracies = []

for i in range (max_epoch_num):
  '''
    random shuffle data 
  '''

  print "EPOCH: "+str(i)+"/"+str(max_epoch_num)
  elapsed_time = time.time() - start_time
  print "elapsed time: "+str(elapsed_time)
  
  losscum = 0
  acccum = 0
    
  for j in range (step):    
    data_bt, label_bt = u.randomShuffle(data_set, label_set)

    # feedward data and label to the model
    loss, pred = my_model.forward(data_bt, label_bt)

    # backward loss
    my_model.backward(loss)

    # update parameters in model
    my_model.update_param()
    
    losscum = loss + loss    
    acccum = acccum + (1 - np.mean(np.reshape(label_bt.astype(int), (64, 1)) != (pred > .5).astype(int)))
    
#    if j % 5000 == 0:
#      print "step: "+str(j+1)+"/"+str(step)
#      elapsed_time = time.time() - start_time
#      print "elapsed time: "+str(elapsed_time)
  lossavg = losscum/step
  accavg = acccum/step
  losses.append(lossavg)
  accuracies.append(accavg)
  
  if accavg == 1:
      break

fig1 = plt.figure()
ax1 = fig1.add_subplot(2, 1, 1)
ax1.set_title('2.1.1 Loss/Accuracy vs. Training Iteration')
ax1.set_xlabel('Iteration')
ax1.set_ylabel('Loss')
ax1.plot(np.arange(0, len(losses), 1), losses)

ax1 = fig1.add_subplot(2, 1, 2)
ax1.set_xlabel('Iteration')
ax1.set_ylabel('Accuracy')
ax1.plot(np.arange(0, len(accuracies), 1), accuracies)

plt.show()
fig1.savefig('foo.png')