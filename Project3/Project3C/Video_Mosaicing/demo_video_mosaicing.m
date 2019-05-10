%% demo video mosaicing
%
%   CIS 581
%   Project 3C
%
%   Ariana Familiar
%   Nov 2017
%
%   This shows how to implement video mosaicing for 3 input videos.
%       First, input videos are loaded ("loadVideo").
%       Second, the first or last frame of the shorter videos are repeated
%               to make the videos the same length ("repFrames").
%       Next, each frame is stitched together across the videos. In this
%               implementation, the first and third videos are stitched to
%               the second video ("mymosaic").
%       Last, a video of the stitched frames is generated ("myvideomosaic")
%               
%   Please see function files for more detailed description of operations.

clear all; close all; clc;

%% user definitions

example = 1; % 1 or 2

%% load input videos
if example == 1
    video1 = loadVideo(VideoReader('Video1.mp4'));
    video2 = loadVideo(VideoReader('Video2.mp4'));
    video3 = loadVideo(VideoReader('Video3.mp4'));
    repLast = 1; % repeat last frame
elseif example == 2
    video1 = loadVideo(VideoReader('Ori1.mov'));
    video2 = loadVideo(VideoReader('Ori2.mov'));
    video3 = loadVideo(VideoReader('Ori3.mov'));
    repLast = 0; % repeat first frame
end

%% stitch frames

% repeat last frames to fill gaps depending on different video lengths
% make cell array of frames for each video
[vid1, vid2, vid3] = repFrames(video1, video2, video3, repLast);

% stitch all frames
[img_mosaic] = mymosaic([vid1, vid2, vid3]);

%% make video

[video_mosaic] = myvideomosaic(img_mosaic);
