'''
  File name: p1_main.py
  Author:	Ariana Familiar
  Date:		Dec 2017
'''

import numpy as np
import numpy.matlib
from myLayers import *
from p1_utils import *
import math

# ********** NUMBER 1 *******************************************

# create single neuron with input array (1 x 1) and value 1
X = np.array([1])

# get sigmoid and relu outputs
samples = 50
W = np.linspace(-1.1,1.1,num=samples)
b = np.linspace(-1.1,1.1,num=samples)

sig_output  = np.zeros([len(W),len(b)])
relu_output = np.zeros([len(W),len(b)])
for i in range(len(W)):
	for j in range(len(b)):
		sig_output[i,j]  = Sigmoid((W[i]*X)+b[j])
		relu_output[i,j] = Relu((W[i]*X)+b[j])

# plot results
xPlot = np.repeat(W,samples)
yPlot = np.matlib.repmat(b,samples,1)

plot3D(xPlot,yPlot,sig_output)
plot3D(xPlot,yPlot,relu_output)


# ********** NUMBER 2 *******************************************

y = 0.5 # ground truth

sig_loss  = L2_loss(sig_output, y)
relu_loss = L2_loss(relu_output,y)

plot3D(xPlot,yPlot,sig_loss)
plot3D(xPlot,yPlot,relu_loss)

# backward gradient of l2 loss
sig_grad  = np.zeros([len(W),len(b)])
relu_grad = np.zeros([len(W),len(b)])
for i in range(len(W)):
	for j in range(len(b)):
		sig_grad[i,j]  = gradL2(y, sig_output[i,j], X, (W[i]*X)+b[j],'sigmoid')
		relu_grad[i,j] = gradL2(y, relu_output[i,j],X, (W[i]*X)+b[j],'relu')

plot3D(xPlot,yPlot,sig_grad)
plot3D(xPlot,yPlot,relu_grad)


# ********** NUMBER 3 *******************************************

sig_loss  = Cross_entropy_loss(sig_output, y)
relu_loss = Cross_entropy_loss(relu_output+(1*math.exp(-5)),y)

plot3D(xPlot,yPlot,sig_loss)
plot3D(xPlot,yPlot,relu_loss)

# backward gradient of CE loss
sig_grad  = np.zeros([len(W),len(b)])
relu_grad = np.zeros([len(W),len(b)])
for i in range(len(W)):
	for j in range(len(b)):
		sig_grad[i,j]  = gradCE(y, sig_output[i,j], X, (W[i]*X)+b[j],'sigmoid')
		relu_grad[i,j] = gradCE(y, relu_output[i,j]+(1*math.exp(-5)), X, (W[i]*X)+b[j],'relu')

plot3D(xPlot,yPlot,sig_grad)
plot3D(xPlot,yPlot,relu_grad)

