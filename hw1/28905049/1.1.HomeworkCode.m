%% Clear the environment
clc
clear
% close all

%% Read an image
% Attribution - Bikesgray.jpg By Davidwkennedy (http://en.wikipedia.org/wiki/File:Bikesgray.jpg) [CC BY-SA 3.0 (http://creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons
img1 = imread('Bikesgray.jpg'); %Write code here to read in the image named 'Bikesgray.jpg' into the variable img1
img1 = double(img1);

%% Display original image
figure; imagesc(img1); axis image; colormap(gray);

%% X gradient - Sobel Operator
f1 = [1 0 -1; 2 0 -2; 1 0 -1];

%% Convolve image with kernel f1 -> This highlights the vertical edges in the image
vertical_sobel = conv2(img1,f1,'same'); %Write code here to convolve img1 with f1

%% Display the image
% Write code here to display the image 'vertical_sobel'
figure; h = imagesc(vertical_sobel); colormap(gray)

% save the image
saveas(h,'Bikesgray_f1.jpg');

%% Y gradient - Sobel Operator
f2 = [1 2 1; 0 0 0; -1 -2 -1]; % Now if you want to highlight horizontal edges in the image, think about what the kernel should be. Store this kernel in the variable f2.
% or f2 = f1';

%% Convolve image with kernel f2 -> This should highlight the horizontal edges in the image
horz_sobel = conv2(img1,f2,'same'); %Write code here to convolve img1 with f2

%% Display the image
% Write code here to display the image 'horz_sobel'
figure; h = imagesc(horz_sobel); colormap(gray)

% save the image
saveas(h,'Bikesgray_f2.jpg');
