'''
  File name: morph_tri.py
  Author:
  Date created:
'''

'''
  File clarification:
    Image morphing via Triangulation
    - Input im1: target image
    - Input im2: source image
    - Input im1_pts: correspondences coordiantes in the target image
    - Input im2_pts: correspondences coordiantes in the source image
    - Input warp_frac: a vector contains warping parameters
    - Input dissolve_frac: a vector contains cross dissolve parameters

    - Output morphed_im: a set of morphed images obtained from different warp and dissolve parameters.
                         The size should be [number of images, image height, image Width, color channel number]
'''
import scipy
from scipy.spatial import Delaunay
import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
import math

def morph_tri(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac):
  # TODO: Your code here
  # Tips: use Delaunay() function to get Delaunay triangulation;
  # Tips: use tri.find_simplex(pts) to find the triangulation index that pts locates in.

  im1_pts = np.array(im1_pts)
  im2_pts = np.array(im2_pts)

  tri1 = scipy.spatial.Delaunay(im1_pts)
  tri2 = scipy.spatial.Delaunay(im2_pts)

  # now create meshgrids for the x and y coordinates of the pixels
  arraySize = im1.shape
  rowCount1 = arraySize[0]
  columnCount1 = arraySize[1]
  colorCount = arraySize[2]
  arraySize = im2.shape
  rowCount2 = arraySize[0]
  columnCount2 = arraySize[1]

  I1 = np.linspace(1, rowCount1, rowCount1)
  J1 = np.linspace(1, columnCount1, columnCount2)
  I1, J1 = np.meshgrid(I1, J1, indexing = 'ij')
  I1 = I1.ravel()
  J1 = J1.ravel()
  I1 = I1.reshape(I1.size, 1)
  J1 = J1.reshape(J1.size, 1)
  hstack_im1 = np.hstack((I1, J1))

  I2 = np.linspace(1, rowCount2, rowCount2)
  J2 = np.linspace(1, columnCount2, columnCount2)
  I2, J2 = np.meshgrid(I2, J2, indexing = 'ij')
  I2 = I2.ravel()
  J2 = J2.ravel()
  I2 = I2.reshape(I2.size, 1)
  J2 = J2.reshape(J2.size, 1)
  hstack_im2 = np.hstack((I2, J2))

  im = np.zeros((warp_frac.size, rowCount1, columnCount1, colorCount))
  
  for k in range(0, warp_frac.size):
    
    frames = im1_pts*(1-warp_frac[k]) + im2_pts*warp_frac[k]
    
    tri = scipy.spatial.Delaunay(frames)

    for i in range(0, rowCount1):
      for j in range(0, columnCount1):
        
        triangle = tri.find_simplex(np.array([j, i]))
       
        if triangle < 0:
          print i
          print j
          exit()
        
        vertices = np.array([[frames[tri.simplices[triangle, 0], 0], frames[tri.simplices[triangle, 1], 0], frames[tri.simplices[triangle, 2], 0]], [frames[tri.simplices[triangle, 0], 1], frames[tri.simplices[triangle, 1], 1], frames[tri.simplices[triangle, 2], 1]], [1, 1, 1]])
        
        pixel = np.array([[j], [i], [1]])
        
        vertices_inv = np.linalg.inv(vertices)
        bary = np.dot(vertices_inv, pixel)
        
        vertices1 = np.array([[im1_pts[tri.simplices[triangle, 0], 0], im1_pts[tri.simplices[triangle, 1], 0], im1_pts[tri.simplices[triangle, 2], 0]], [im1_pts[tri.simplices[triangle, 0], 1], im1_pts[tri.simplices[triangle, 1], 1], im1_pts[tri.simplices[triangle, 2], 1]], [1, 1, 1]])
        
        
        vertices2 = np.array([[im2_pts[tri.simplices[triangle, 0], 0], im2_pts[tri.simplices[triangle, 1], 0], im2_pts[tri.simplices[triangle, 2], 0]], [im2_pts[tri.simplices[triangle, 0], 1], im2_pts[tri.simplices[triangle, 1], 1], im2_pts[tri.simplices[triangle, 2], 1]], [1, 1, 1]])
        pixel1 = np.matmul(vertices1, bary)
        
        np.putmask(pixel1, pixel1>columnCount1-1, columnCount1-1)
        np.putmask(pixel1, pixel1<0, 0)
        pixel2 = np.matmul(vertices2, bary)
        np.putmask(pixel2, pixel2>columnCount1-1, columnCount1-1)
        np.putmask(pixel2, pixel2<0, 0)
        
        source = im1[int(round(pixel1[1][0], 2)), int(round(pixel1[0][0], 2)), :] # corresponding pixel intensity in the source image
        
        dest = im2[int(pixel2[1][0]), int(pixel2[0][0]), :]
        
        im[k, i, j, :] = source*(1-dissolve_frac[k]) + dest*dissolve_frac[k]
        
    im_temp = np.asarray(im[k, :, :, :], dtype = np.uint8)
    
    plt.imshow(im_temp)
    outfile ='frame%d.jpg' % k
    plt.savefig(outfile)
    Image.open(outfile).show()
  

  return im
  