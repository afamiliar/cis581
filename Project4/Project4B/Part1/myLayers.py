'''
  File name: myLayers.py
  Author:   Ariana Familiar
  Date:     Dec 2017
'''

import numpy as np

'''
  Sigmoid layer
  - Input x: ndarray
  - Output y: nonlinearized result
'''
def Sigmoid(x):
  # TODO
  y = 1 / (1 + np.exp(-x))
  return y


'''
  Relu layer
  - Input x: ndarray 
  - Output y: nonlinearized result
'''
def Relu(x):
  # TODO
  y = np.maximum(x, 0, x)
  return y


'''
  l2 loss layer
  - Input pred: prediction values
  - Input gt: the ground truth 
  - Output loss: averaged loss
'''
def L2_loss(pred, gt):
  # TODO
  loss = .5*((pred-gt)**2)
  return loss



'''
  Cross entropy loss layer
  - Input pred: prediction values
  - Input gt: the ground truth 
  - Output loss: averaged loss
'''
def Cross_entropy_loss(pred, gt):
  # TODO
  loss = - (np.multiply(gt, np.log(pred)) + np.multiply((1-gt), np.log(1-pred)))
  return loss

