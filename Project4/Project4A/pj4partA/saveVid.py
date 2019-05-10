# ******************************************************************
# saveVid
#
#   writes frames to AVI video file of given output name

import cv2

def saveVid(vid, outputName):

    h, w, ch = vid[0].shape

    # Define the codec and create VideoWriter object
    # fourcc = cv2.VideoWriter_fourcc(*'XVID')
    fourcc = cv2.VideoWriter_fourcc('M','J','P','G')
    out    = cv2.VideoWriter(outputName,fourcc, 20.0, (w,h))

    nFrames = len(vid)
    for i in range(0,nFrames):
        # frame = cv2.flip(vid[i],0)
        # out.write(frame)
        out.write(vid[i])

    out.release()
    cv2.destroyAllWindows()
