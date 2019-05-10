'''
  File name: p3_dataloader.py
  Author:	Ariana Familiar
  Date:		Dec 2017
'''

import numpy as np
import cv2

'''
  Load training or testing data and labels
'''
def dataloader(type,nFiles):
	if type == 'training':
		file  = open("../../dataset/p3/MTFL/training_new.txt","r")
		if nFiles == 'all':
			nFiles = 4151
		data_set = np.zeros([nFiles,250,250,3],dtype=np.uint8)
	elif type == 'testing':
		if nFiles == 'all':
			nFiles = 2995
		file  = open("../../dataset/p3/MTFL/testing.txt","r")
		data_set = np.zeros([nFiles,150,150,3],dtype=np.uint8)

	lines = file.readlines()
	words = []
	for line in lines:
		words.append(line.split())
	words = np.array(words)

	label_set = np.zeros([nFiles,10])
	for i in range(nFiles):
		data_set[i]  = cv2.imread('../../dataset/p3/MTFL/' + words[i][0])
		label_set[i] = [words[i][1],words[i][2],words[i][3],words[i][4], words[i][5],
						words[i][6],words[i][7],words[i][8],words[i][9],words[i][10]]
		# x1...x5,y1...y5: the locations for left eye, right eye, nose, left mouth corner, right mouth corner.

	return data_set, label_set