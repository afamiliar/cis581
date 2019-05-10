%% Gradient mixing demo script
%
%   CIS 581
%   Project 2
%   Fall 2017
%
%   Ariana Familiar
%
%       This shows how to implement gradient mixing to blend a region of a 
%       source image onto a target image for 4 pairs of images 
%       (source/target):
%
%       Examples of GOOD mixing results:
%
%           (1) glass.jpg / table.jpg
%           (2) roses.jpg / back.jpg
%
%       Examples of BAD mixing results:
%
%           (3) chimp.jpg / ironthrone.jpg
%           (4) SourceImage.jpg / TargetImage.jpg


%% =========== Glass on table =========================================== 

clear all; close all; clc;

% load images
source = im2double(imread('glass.jpg'));
target = im2double(imread('table.jpg'));

% create mask of replacement region in source
if exist('mask_glass.mat','file')
    load('mask_glass.mat')
else
    [mask] = maskImage(source);
end

source = imresize(source,.15);
mask = imresize(mask,.15);

% perform blending
offsetX = 350;   % vertical offset
offsetY = 100;   % horizontal offset

[resultImg] = seamlessCloningPoisson(source, target, mask, offsetX, offsetY);

% show and save result
imshow(resultImg)
imwrite(resultImg,'Result_glass.jpg')


%% =========== Rose tattoo =========================================== 

clear all; close all; clc;

% load images
source = im2double(imread('roses.jpg'));
target = im2double(imread('back.jpg'));

% create mask of replacement region in source
if exist('mask_roses.mat','file')
    load('mask_roses.mat')
else
    [mask] = maskImage(source);
end

% perform blending
offsetX = 50;   % vertical offset
offsetY = 210;   % horizontal offset

[resultImg] = seamlessCloningPoisson(source, target, mask, offsetX, offsetY);

% show and save result
imshow(resultImg)
imwrite(resultImg,'Result_roses.jpg')


%% =========== Iron chimp =========================================== 

clear all; close all; clc;

% load images
source = im2double(imread('chimp.jpg'));
target = im2double(imread('ironthrone.jpg'));

% create mask of replacement region in source
if exist('mask_chimp.mat','file')
    load('mask_chimp.mat')
else
    [mask] = maskImage(source);
end

% perform blending
offsetX = 110;   % vertical offset
offsetY = 170;   % horizontal offset

[resultImg] = seamlessCloningPoisson(source, target, mask, offsetX, offsetY);

% show and save result
imshow(resultImg)
imwrite(resultImg,'Result_chimp.jpg')


%% =========== test images =========================================== 

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

% perform blending
offsetX = 180;   % vertical offset
offsetY = 250;   % horizontal offset

[resultImg] = seamlessCloningPoisson(source, target, mask, offsetX, offsetY);

% show and save result
imshow(resultImg)
imwrite(resultImg,'Result_minion.jpg')

