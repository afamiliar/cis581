# ******************************************************************
# loadVid
#
#   loads video of given input name, outputs frames

import cv2

def loadVid(inputName):
    
    frames = []
    # Create a VideoCapture object and read from input file
    # If the input is the camera, pass 0 instead of the video file name
    cap = cv2.VideoCapture(inputName)
    
    # Check if camera opened successfully
    if (cap.isOpened()== False): 
        print("Error opening video stream or file")
     
    # Read until video is completed
    while(cap.isOpened()):
        # Capture frame-by-frame
        ret, frame = cap.read()
        if ret == True:
            # append to outputs
            frames.append(frame)
        # Break the loop
        else: 
            break
     
    # When everything done, release the video capture object
    cap.release()
     
    return frames


