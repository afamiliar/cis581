% File name: apply_homography.m
% Author:        Ariana Familiar
% Date created:  Nov 2017

function [X, Y] = apply_homography(H, x, y)
%%
% Input:
%   H : 3*3 homography matrix, refer to setup_homography
%   x : the column coords vector, n*1, in the source image
%   y : the column coords vector, n*1, in the source image

% Output:
%   X : the column coords vector, n*1, in the destination image
%   Y : the column coords vector, n*1, in the destination image

% Write Your Code Here

A = H * [x; y; ones(1, length(x))];
A = A ./ [A(3,:); A(3,:); A(3,:)];

X = A(1,:)';
Y = A(2,:)';

end