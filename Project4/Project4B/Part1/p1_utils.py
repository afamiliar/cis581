'''
  File name: p1_utils.py
  Author:	Ariana Familiar
  Date:		Dec 2017
'''

'''
  Generate 3D plot
'''
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from myLayers import *

def plot3D(x,y,z):

	fig = plt.figure()
	ax = fig.add_subplot(111, projection='3d')

	cm = plt.cm.RdYlGn
	ax.scatter(x, y, z,c=z,cmap=cm)
	ax.set_xlabel('Weight')
	ax.set_ylabel('Bias')
	ax.set_zlabel('Output')

	plt.show()


'''
  Compute derivative of sigmoid
'''
def sig_deriv(x):
	return Sigmoid(x)*(1-Sigmoid(x))


'''
  Compute derivative of ReLu
'''
def relu_deriv(x):
	x[x<=0] = 0
	x[x>0] = 1
	return x


'''
  Compute gradient (dL / dW) for L2 loss
  	y 		ground truth
  	B 		output
  	X 		input
  	z 		input to activ fn (W*X+b)
  	type	activation function

  	z is input to Sigmoid fn (W*X+b)
'''
def gradL2(y,B,X,z,type):
	if type == 'sigmoid':
		return (B-y) * sig_deriv(z) * X
	elif type == 'relu':
		return (B-y) * relu_deriv(z) * X


'''
  Compute gradient (dL / dW) for cross entropy loss 
  	y 		ground truth
  	B 		output
  	X 		input
  	type	activation function
'''
def gradCE(y,B,X,z,type):
	if type == 'sigmoid':
		return (B-y) * X 
		# return ((B-y)/(B*(1-B)))*sig_deriv(z)*X
	elif type == 'relu':
		return ((B-y)/(B*(1-B)))*relu_deriv(z)*X


