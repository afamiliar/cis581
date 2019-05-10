'''
  File name: applyGeometricTransformation.py
  Author:
  Date created:
'''
'''
  File clarification:
    Estimate the translation for bounding box
    - Input startXs: the x coordinates for all features wrt the first frame
    - Input startYs: the y coordinates for all features wrt the first frame
    - Input newXs: the x coordinates for all features wrt the second frame
    - Input newYs: the y coordinates for all features wrt the second frame
    - Input bbox: corner coordinates of all detected bounding boxes
    
    - Output Xs: the x coordinates(after eliminating outliers) for all features wrt the second frame
    - Output Ys: the y coordinates(after eliminating outliers) for all features wrt the second frame
    - Output newbbox: corner coordiantes of all detected bounding boxes after transformation
'''
from skimage import transform as tf
import numpy as np
def applyGeometricTransformation(startX, startY, newXs, newYs, bbox):
  #TODO: Your code here
    
  
    # newXs = np.matrix.transpose(np.asarray([newXs]))
    # newYs = np.matrix.transpose(np.asarray([newYs]))
    newbbox = np.zeros(bbox.shape)
    backup = bbox
    bbox = bbox[0,0:,0:]
    srcn = np.array([0,0])
    dstn = np.array([0,0])
        
    for f in range(0, startX.shape[1]): # for each face
        numf = startX.shape[0]
        src = np.zeros((numf,2))
        dst = np.zeros((numf,2))
        for i in range(0, startX.shape[0]):
            src[i] = [startX[i,f],startY[i,f]]
            dst[i] = [newXs[i,f],newYs[i,f]]
                
        tran = tf.estimate_transform('affine', src, dst)
        tform = np.linalg.inv(tran.params)
        
        src_t = np.hstack((src,np.ones((numf,1))))
        src_t = np.matrix.transpose(src_t)
        src_t = np.matmul(tform,src_t)
        src_t = src_t[0:2,0:]/src_t[2,0:]
        src_t = np.matrix.transpose(src_t)
        
        dist = (dst - src_t)**2
        dist = np.sqrt(np.sum(dist,axis=1))
        
        for i in range(0, startX.shape[0]): # for each feature
            if dist[i] < 7:
                srcn = np.vstack((srcn,[startX[i,f],startY[i,f]]))
                dstn = np.vstack((dstn,[newXs[i,f],newYs[i,f]]))       
                
        srcn = srcn[1:,0:]
        dstn = dstn[1:,0:]
        tran = tf.estimate_transform('affine', srcn, dstn)        
        tform = np.linalg.inv(tran.params)
        Xs = dstn[0:,0]
        Ys = dstn[0:,1]
        
        bbox = np.hstack((bbox,np.ones((4,1))))
        # bbox = np.hstack((bbox,np.ones(np.shape(bbox))))
        bbox = np.matrix.transpose(bbox)
        newbox = np.matmul(tform,bbox)
        newbox = newbox[0:2,0:]/newbox[2,0:]
        newbox = np.matrix.transpose(newbox)
        newbbox[0,0:,0:] = newbox
        Xs = np.ndarray.tolist(Xs)
        Ys = np.ndarray.tolist(Ys)
    
    Xs = np.array([Xs])
    Xs = Xs.T
    Ys = np.array([Ys])
    Ys = Ys.T
    if np.any(np.isnan(newbbox)):
        newbbox = backup

    return Xs, Ys, newbbox
    