'''
  File name: p2_utils.py
  Author: Prateek Singhal
  Date: 12-11-2017
'''
import numpy as np
def loadData():
    data_set = np.load('p22_line_imgs.npy')
    label_set = np.load('p22_line_labs.npy')
    return data_set, label_set


def randomShuffle(data_set, label_set):
    indices = np.arange(len(data_set))
    np.random.shuffle(indices)
    data_set_random = data_set[indices]
    label_set_random = label_set[indices]
    return data_set_random, label_set_random


def obtainMiniBatch(data_set, label_set, batch_size):
    length = np.arange(len(data_set))
    indices = np.random.choice(length, batch_size)
    data_set_bt = data_set[indices]
    label_set_bt = label_set[indices]
    data_set_bt = data_set_bt[:, np.newaxis, :, :]
    label_set_bt = label_set_bt[:, np.newaxis]
    return data_set_bt, label_set_bt