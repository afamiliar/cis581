%% Seam carving demo script
%
%   CIS 581
%   Project 3A
%   Oct 2017
%
%   Ariana Familiar
%
%       This shows how to implement seam carving for a given image and the
%       number of rows/columns to remove from it. Existing image examples:
%           (1) boat.jpg
%           (2) tree.jpg
%           (3) starrynight.jpg
%           (4) Test1.jpg
%           (5) Test2.jpg
%
%       See use defined options below.

clear all; close all; clc;

% ======== user defined options ======================================
showResult  = 1; % (1 = yes; 0 = no)
saveResult  = 0; % (1 = yes; 0 = no)
genVideo    = 0; % (1 = generate seam carving video; 0 = don't)
image       = 1; % which existing image to use (1-5)

if image == 1
    outputName = 'boat_resized';

    I = im2double(imread('boat.jpg'));
    I = imresize(I,.05);

    nr = 20; % number of rows to remove
    nc = 20; % number of columns to remove
    
elseif image == 2
    outputName = 'tree_resized';
    
    I = im2double(imread('tree.jpg'));
    I = imresize(I,.25);

    nr = 50; % number of rows to remove
    nc = 10; % number of columns to remove
    
elseif image == 3
    outputName = 'starrynight_resized';
    
    I = im2double(imread('starrynight.jpg'));
    I = imresize(I,.25);

    nr = 10; % number of rows to remove
    nc = 50; % number of columns to remove
    
elseif image == 4
    outputName = 'Test1Output';

    I = im2double(imread('Test1.jpg'));
    I = imresize(I,.5);

    nr = 100; % number of rows to remove
    nc = 100; % number of columns to remove
    
elseif image == 5
    outputName = 'Test2Output';
    
    I = im2double(imread('Test2.jpg'));
    I = imresize(I,.5);

    nr = 50; % number of rows to remove
    nc = 50; % number of columns to remove
    
end


% ======== discrete image resizing ==================================

if genVideo
    [Ic, T] = carv_genVideo(I, nr, nc, outputName);
else
    [Ic, T] = carv(I, nr, nc);
end

if showResult
    close all;
    figure; subplot(1,2,1); imshow(I);  title('Original image');
            subplot(1,2,2); imshow(Ic); title('Resized image');
end

if saveResult
    imwrite(Ic,[outputName '.jpg']);
end
