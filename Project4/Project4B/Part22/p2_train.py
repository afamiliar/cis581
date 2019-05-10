'''
  File name: p2_train.py
  Author: Prateek Singhal
  Date: 12-11-2017
'''

import PyNet as net
from p2_utils import *
import numpy as np
import time
import matplotlib.pyplot as plt

'''
  network architecture construction
  - Stack layers in order based on the architecture of your network
'''

layer_list = [
                net.Conv2d(16, 7, 0, 1),
                net.Relu(),
                net.Conv2d(8, 7, 0, 1),
                net.Relu(),
                net.Flatten(),
                net.Linear(128, 1),
                net.Sigmoid()
             ]

'''
  Define loss function
'''
loss_layer = net.Binary_cross_entropy_loss()

'''
  Define optimizer 
'''
optimizer = net.SGD_Optimizer(0.01, 0.0005, 0.99)


'''
  Build model
'''
my_model = net.Model(layer_list, loss_layer, optimizer)

'''
  Define the number of input channel and initialize the model
'''
my_model.set_input_channel(1) # since we are dealing with grayscale data containing only 1 channel



'''
  Main training process
  - train N epochs, each epoch contains M steps, each step feed a batch-sized data for training,
    that is, total number of data = M * batch_size, each epoch need to traverse all data.
'''

# obtain data 
[data_set, label_set] = loadData()
max_epoch_num = 1000    # no. of iterations
batch_size = 64 # as per the handout
step = 1 # step is an int number
start_time = time.time()
losses = []
accuracies = []

for i in range (max_epoch_num):

    print "EPOCH: " + str(i) + "/" + str(max_epoch_num)
    elapsed_time = time.time() - start_time
    print "elapsed time: " + str(elapsed_time)

    '''
    random shuffle data 
    '''

    data_set_random, label_set_random = randomShuffle(data_set, label_set) # design function by yourself


    for j in range (step):
        # obtain a mini batch for this step training
        [data_bt, label_bt] = obtainMiniBatch(data_set_random, label_set_random, batch_size)  # design function by yourself

        # feedward data and label to the model
        loss, pred = my_model.forward(data_bt, label_bt)

        # backward loss
        my_model.backward(loss)

        # update parameters in model
        my_model.update_param()

        accuracy = (1 - np.mean(np.reshape(label_bt.astype(int), (64, 1)) != (pred > .5).astype(int)))

    losses.append(loss)
    accuracies.append(accuracy)

    if accuracy == 1:
        break

fig1 = plt.figure()
ax1 = fig1.add_subplot(2, 1, 1)
ax1.set_title('2.2 Loss/Accuracy vs. Training Iteration for Convolution Network')
ax1.set_xlabel('Iteration')
ax1.set_ylabel('Loss')
ax1.plot(np.arange(0, len(losses), 1), losses)

ax1 = fig1.add_subplot(2, 1, 2)
ax1.set_xlabel('Iteration')
ax1.set_ylabel('Accuracy')
ax1.plot(np.arange(0, len(accuracies), 1), accuracies)

plt.show()
fig1.savefig('convolution_graphs.jpg')