for j in range(0,len(points1)):
        im = cv2.circle(frame1, (int(points1[j][0]), int(points1[j][1])), 1, (0,0,255), 2)

for j in range(0,len(points2)):
    im = cv2.circle(frame2, (int(points2[j][0]), int(points2[j][1])), 1, (0,0,255), 2)

cv2.imshow('test',im)

cv2.destroyAllWindows()


np.savetxt('pred_lEye.txt',pred[0,0,:,:])
np.savetxt('pred_rEye.txt',pred[0,1,:,:])
np.savetxt('pred_nose.txt',pred[0,2,:,:])
np.savetxt('pred_lMouth.txt',pred[0,3,:,:])
np.savetxt('pred_rMouth.txt',pred[0,4,:,:])
