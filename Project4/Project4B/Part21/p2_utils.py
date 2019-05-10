'''
  File name: p2_utils.py
  Author: 	Ariana Familiar
  Date:		Dec 2017
'''


import numpy as np

def randomShuffle(data_set, label_set):
	range = np.arange(len(data_set))
	np.random.shuffle(range) # shuffle by row only

	data_set_cur  = data_set[range]
	label_set_cur = label_set[range]

	return data_set_cur, label_set_cur
