'''
  File name: anms.py
  Author: Prateek Singhal
  Date created: 11/22/2017
'''
import helper
import sys
import numpy as np
import scipy.spatial.distance
import math

def anms(cimg, max_pts):
  width = cimg.shape[1]
  height = cimg.shape[0]
  maxDistance = math.sqrt(math.pow(width, 2) + math.pow(height, 2))

  MinDistN_array = []
  corners = np.where(cimg > 0)
  numCorners = corners[0].size

  for i in range(0, numCorners):
    xPos = corners[1][i]
    yPos = corners[0][i]
    cur_strength = cimg[yPos, xPos]
    #print "{}{}".format("Strength: ", cur_strength)
    asStrongPts = np.where(cimg > cur_strength)
    #print asStrongPts
    distances = scipy.spatial.distance.cdist(np.array([[yPos,xPos]]), np.array(asStrongPts).transpose())
    min_dist_neighbor = maxDistance
    min_dist_neighborX = -1
    min_dist_neighborY = -1
    if distances.size != 0:
      min_dist_neighbor = distances.min()
      #print np.array(asStrongPts).transpose()
      #print "{}{}".format("Min Dist:", min_dist_neighbor)
      indexY = np.where(distances == min_dist_neighbor)[0][0]
      indexX = np.where(distances == min_dist_neighbor)[1][0]
      min_dist_neighborX = asStrongPts[1][indexY]
      min_dist_neighborY = asStrongPts[0][indexX]

    #print "{}{}{}".format(xPos, ", ", yPos)
    #print min_dist_neighbor
    #print "{}{}{}".format(min_dist_neighborX, ", ", min_dist_neighborY)
    #print "###################"

    data = [xPos, yPos, min_dist_neighborX, min_dist_neighborY]
    MinDistN_array.append([min_dist_neighbor, data])

  # Sort the array from biggest distance to smallest distance
  MinDistN_array.sort(reverse=True, key=lambda tup: tup[0])  # sorts in place

  x = np.zeros(max_pts, dtype=int)
  y = np.zeros(max_pts, dtype=int)

  #print MinDistN_array[:max_pts]

  for i in range(0, max_pts):
    x[i] = MinDistN_array[i][1][0]
    y[i] = MinDistN_array[i][1][1]
  rmax = MinDistN_array[max_pts-1][0]

  return x, y, rmax