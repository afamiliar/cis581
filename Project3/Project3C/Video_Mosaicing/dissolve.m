function [im2] = dissolve(im1, im2, x_im1, y_im1, x_im2, y_im2, inds, weights)
%% combine im1 and im2 depending on weight of im1/im2
%
%   INPUT
%       im1         input image #1
%       im2         input image #2
%       x_im1       warped pixels in x-dim of im1
%       y_im1       warped pixels in y-dim of im1
%       x_im2       warped pixels in x-dim of im2
%       y_im2       warped pixels in y-dim of im2
%       inds        index of pixels within image borders
%       weights     distance-based blending results (weight of im1/im2 for
%                   each indexed pixel)
%
%   OUTPUT
%       im2         resulting stitched image

rows_im1 = size(im1,1);
rows_im2 = size(im2,1);
cols_im1 = size(im1,2);
cols_im2 = size(im2,2);

% get subset of pixels depending on inds
x_im1_sub = x_im1(inds);
y_im1_sub = y_im1(inds);
x_im2_sub = x_im2(inds);
y_im2_sub = y_im2(inds);

im1_ind = (x_im1_sub-1)*rows_im1 + y_im1_sub;
im2_ind = (x_im2_sub-1)*rows_im2 + y_im2_sub;

% for separate color channels
im1_G_ind = rows_im1*cols_im1;
im1_B_ind = rows_im1*cols_im1*2;
im2_G_ind = rows_im2*cols_im2;
im2_B_ind = rows_im2*cols_im2*2;

% dissolve each channel
im2(im2_ind) = ...
        weights     .* im1(im1_ind) + ... 
        (1-weights) .* im2(im2_ind);

im2(im2_ind + im2_G_ind) = ...
        weights     .* im1(im1_ind + im1_G_ind) + ... 
        (1-weights) .* im2(im2_ind + im2_G_ind);

im2(im2_ind + im2_B_ind) = ...
        weights     .* im1(im1_ind + im1_B_ind) + ... 
        (1-weights) .* im2(im2_ind + im2_B_ind);

end