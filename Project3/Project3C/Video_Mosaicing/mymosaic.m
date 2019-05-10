% File name: mymosaic.m
% Author:       Ariana Familiar
% Date created: Nov 2017

function [img_mosaic] = mymosaic(img_input)
%%
% Input:
%   img_input is a cell array of color images (HxWx3 uint8 values in the
%   range [0,255])
%
% Output:
%   img_mosaic is the output mosaic

nFrames = size(img_input,1);
nVideos = size(img_input,2);

% use first frame of middle video as reference
if ~mod(nVideos,2)
    ind = round(nVideos/2);
else
    ind = round((1+nVideos)/2);
end
nums    = 1:nVideos;
mid_vid = nums(ind);

% convert to double if necessary
if isa(img_input{1, mid_vid}, 'uint8')
    img_ref = im2double(img_input{1, mid_vid});
else
    img_ref = img_input{1, mid_vid};
end

% pad reference frame
[rows_img, cols_img, ~] = size(img_ref);
szRows  = 3*rows_img;
szCols  = 3*cols_img;
img_ref = padarray(img_ref,[(szRows-rows_img)/2, (szCols-cols_img)/2]);

% for each frame, warp the middle video ("vid2") frame to the reference
% frame, then warp the first frame to the result, then warp the third frame
% to the result, then combine
for f = 1:nFrames % for each frame
    if f == 1
        img2ref = img_ref;
    else
        % warp vid2 frame to ref
        if isa(img_input{f,2},'uint8')
            img1 = im2double(img_input{f,2});
        else
            img1 = img_input{f,2};
        end
        img2ref  = stitch(img1, img_ref);
    end

    % warp vid1 frame to vid2/ref
    if isa(img_input{f,1},'uint8')
        img1 = im2double(img_input{f,1});
    else
        img1 = img_input{f,1};
    end
    img2  = stitch(img1, img2ref);

    % warp vid3 frame to vid2/ref
    if isa(img_input{f,3},'uint8')
        img1 = im2double(img_input{f,3});
    else
        img1 = img_input{f,3};
    end
    img3 = stitch(img1, img2ref);

    % combine results
    img_mosaic{f,1} = stitch(img2, img3);

    clc
    disp(['COMPLETED: ' int2str(f) ' out of ' int2str(nFrames) ' frames'])
end

end
