% File name: feat_desc.m
% Author:       Ariana Familiar
% Date created: Nov 2017

function [descs] = feat_desc(img, x, y)
%%
% Input:
%    img = double (height)x(width) array (grayscale image) with values in the
%    range 0-255
%    x = nx1 vector representing the column coordinates of corners
%    y = nx1 vector representing the row coordinates of corners

% Output:
%   descs = 64xn matrix of double values with column i being the 64 dimensional
%   descriptor computed at location (xi, yi) in im

% Write Your Code Here

win    = 40; % 40 x 40 pix window
stdDev = 1;  % standard deviation
s      = 5;  % spacing of 5 pix between samples
rows   = size(img,1);
cols   = size(img,2);
descs  = zeros(64, length(x));

for i = 1:length(x) % for each corner coord
    % get large sample centered on coord
    strR = x(i) - win/2+1; % slightly offset
    endR = x(i) + win/2;
    strC = y(i) - win/2+1;
    endC = y(i) + win/2;
    
    [col, row] = meshgrid(strR:endR, strC:endC);
    col(col<=0) = 1;      % stay w/in borders
    col(col>cols) = cols;
    row(row<=0) = 1;
    row(row>rows) = rows;

    % get this section of input img
    ind  = (col(:)-1) * rows + row(:);
    feat = img(ind);
    
    % blur it
    feat    = reshape(feat, [win, win]);
    feature = imgaussfilt(feat, stdDev);
    
    % get smaller patches (8x8 with 5 pix spacing)
    feature = feature(1:s:win, 1:s:win);
    feature = double(feature);
    
    % normalize (M=0, SD=1)
    feature = (feature(:) - mean(feature(:))) / std(feature(:));
    
    % update output mat
    descs(:, i) = feature;
end

end