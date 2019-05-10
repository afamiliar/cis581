%% Gradient domain blending demo script
%
%   CIS 581
%   Project 2
%   Fall 2017
%
%   Ariana Familiar
%
%       This shows how to implement the gradient domain blending functions
%       to blend a region of a source image onto a target image for 5
%       pairs of images (source/target):
%           (1) dog.jpg / moon.jpg
%           (2) himalayas.jpg / boathouserow.jpg
%           (3) whitewalker.jpg / kiss.jpg
%           (4) slinky.jpg / nightking.jpg
%           (5) SourceImage.jpg / TargetImage.jpg

%% =========== (1) Dog on the moon ========================================

clear all; close all; clc;

% load images
source = im2double(imread('dog.jpg'));
target = im2double(imread('moon.jpg'));

% create mask of replacement region in source
if exist('mask_dog.mat','file')
    load('mask_dog.mat')
else
    [mask] = maskImage(source);
end

% define offset of source image with respect to target image
offsetX = 172;   % vertical offset
offsetY = 92;    % horizontal offset

% perform blending
[resultImg] = seamlessCloningPoisson(source, target, mask, offsetX, offsetY);

% show and save result
imshow(resultImg)
imwrite(resultImg,'Result_dog.jpg')


%% =========== (2) Himalaya boathouse ==================================

clear all; close all; clc;

% load images
source = im2double(imread('himalayas.jpg'));
target = im2double(imread('boathouserow.jpg'));

% create mask of replacement region in source
if exist('mask_himalayas.mat','file')
    load('mask_himalayas.mat')
else
    [mask] = maskImage(source);
end

% define offset of source image with respect to target image
offsetX = 24;   % vertical offset
offsetY = 0;    % horizontal offset

% perform blending
[resultImg] = seamlessCloningPoisson(source, target, mask, offsetX, offsetY);

% show and save result
imshow(resultImg)
imwrite(resultImg,'Result_himalayas.jpg')


%% =========== (3) GoT Kiss ==================================

clear all; close all; clc;

% load images
source = im2double(imread('whitewalker.jpg'));
target = im2double(imread('kiss.jpg'));

% create mask of replacement region in source
if exist('mask_whitewalker.mat','file')
    load('mask_whitewalker.mat')
else
    [mask] = maskImage(source);
end

% define offset of source image with respect to target image
offsetX = 210;   % vertical offset
offsetY = 228;    % horizontal offset

% perform blending
[resultImg] = seamlessCloningPoisson(source, target, mask, offsetX, offsetY);

% show and save result
imshow(resultImg)
imwrite(resultImg,'Result_whitewalker.jpg')


%% =========== (4) Slinky night king ==================================

clear all; close all; clc;

% load images
source = im2double(imread('slinky.jpg'));
target = im2double(imread('nightking.jpg'));

% create mask of replacement region in source
if exist('mask_slinky.mat','file')
    load('mask_slinky.mat')
else
    [mask] = maskImage(source);
end

% define offset of source image with respect to target image
offsetX = 106;   % vertical offset
offsetY = 16;    % horizontal offset

% perform blending
[resultImg] = seamlessCloningPoisson(source, target, mask, offsetX, offsetY);

% show and save result
imshow(resultImg)
imwrite(resultImg,'Result_slinky.jpg')


%% =========== (5) test images =========================================== 

clear all; close all; clc;

% load images
source = im2double(imread('SourceImage.jpg'));
target = im2double(imread('TargetImage.jpg'));

source = imresize(source,0.35);

% create mask of replacement region in source
if exist('mask_minion.mat','file')
    load('mask_minion.mat')
else
    [mask] = maskImage(source);
end

% define offset of source image with respect to target image
offsetX = 180;   % vertical offset
offsetY = 250;   % horizontal offset

% perform blending
[resultImg] = seamlessCloningPoisson(source, target, mask, offsetX, offsetY);

% show and save result
imshow(resultImg)
imwrite(resultImg,'Result_minion.jpg')

