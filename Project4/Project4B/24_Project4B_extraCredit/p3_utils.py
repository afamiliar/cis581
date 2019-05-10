'''
  File name: p3_utils.py
  Author: 	Ariana Familiar
  Date: 	Dec 2017
'''

import numpy as np

'''
random shuffle data 
'''
def randomShuffle(data_set, label_set):
	range = np.arange(len(data_set))
	np.random.shuffle(range) # shuffle by row only

	data_set_cur  = data_set[range]
	label_set_cur = label_set[range]

	return data_set_cur, label_set_cur

'''
obtain minibatch for this step
'''
def obtainMiniBatch(data_set, label_set, batch_size):
	num_train = data_set.shape[0]
	inds = np.random.choice(num_train, batch_size)

	data_bt  = data_set[int(inds)]   # shuffle by first ind
	label_bt = label_set[int(inds)]

	data_bt = data_bt[np.newaxis,:]
	label_bt = label_bt[np.newaxis,:]

	return data_bt, label_bt

'''
normalize RGB channels from 0 to 255 to -1 to 1
'''
def normRGB(data):
	normed_data = np.zeros(data.shape)
	normed_data[:,:,:,0] = (data[:,:,:,0] - 119.78) / 255 # blue
	normed_data[:,:,:,1] = (data[:,:,:,1] - 99.50) / 255  # green
	normed_data[:,:,:,2] = (data[:,:,:,2] - 89.93) / 255  # red

	return normed_data