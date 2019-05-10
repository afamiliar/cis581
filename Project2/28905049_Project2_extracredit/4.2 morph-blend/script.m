%% 4.2 extra-credit demo script
%
%   CIS 581
%   Project 2
%   Fall 2017
%
%   Ariana Familiar
%
%       This shows a combination of morphing and blending. First, a
%       replacement region of the source image is selected. Then,  
%       corresponding points are chosen and the source and target images 
%       are morphed using TPS. The resulting morph is then blended onto 
%       the target image for the desired replacement region. The result is 
%       saved as "Output.jpg".
%

clear all; close all; clc;

% define options
displayResult = 1; % (1 = yes; 0 = no)
saveResult    = 1; % (1 = yes; 0 = no)

% load images
source        = imread('myface.jpg');
target        = imread('wonderwoman.jpg');
offsetX       = 50;       % vertical offset
offsetY       = 378;      % horizontal offset
warp_frac     = 0.5;
dissolve_frac = 0.5;

% =================================================================
% create mask of replacement region in source
if exist('mask_face.mat','file')
    load('mask_face.mat')
else
    [mask] = maskImage(source);
end

targetSubregion(:,:,1) = target(offsetX:offsetX+size(source,1),offsetY:offsetY+size(source,2),1);
targetSubregion(:,:,2) = target(offsetX:offsetX+size(source,1),offsetY:offsetY+size(source,2),2);
targetSubregion(:,:,3) = target(offsetX:offsetX+size(source,1),offsetY:offsetY+size(source,2),3);

% define corresponding points between source/target
if exist('points.mat','file')
    load('points.mat');
else
    [im1_pts, im2_pts] = click_correspondences(source, targetSubregion);
end

% morph source/target
morphed_im = morph_tps(source, targetSubregion, im1_pts, im2_pts, warp_frac, dissolve_frac);
morph      = morphed_im{1};
% imshow(morphed_im{1})

% blend replacement region of morph onto target
morph       = im2double(morph);
target      = im2double(target);
[resultImg] = seamlessCloningPoisson(morph, target, mask, offsetX, offsetY);

% show and save result
if displayResult
    imshow(resultImg)
end

if saveResult
    imwrite(resultImg,'Output.jpg')
end
