% File name: mymosaic.m
% Author:       Ariana Familiar
% Date created: Nov 2017

function [video_mosaic] = myvideomosaic(img_mosaic)
%%
% Input:
%   img_mosaic is a cell array of stitched color images (M x 1 vector with
%   stitched image mosaic for every frame)
%
% Output:
%   video_mosaic is the output mosaic file in .avi format

nFrames = size(img_mosaic,1);

figure;
vid = VideoWriter('Ori_results.avi');
vid.FrameRate = 15;
open(vid);

for i = 1:nFrames

    clc; close all;
    disp(['Frame: ' int2str(i) ' of ' int2str(nFrames)])

    imshow(img_mosaic{i,1}); axis image; axis off;
    writeVideo(vid, getframe(gcf));
    
end

close(vid);
clc

video_mosaic = [];

end