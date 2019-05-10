% File name: corner_detector.m
% Author:        Ariana Familiar
% Date created:  Nov 2017

function [cimg] = corner_detector(img)
%%
% Input:
% img is an image

% Output:
% cimg is a corner matrix

% Write Your Code Here

% cimg = cornermetric(img); 
points = detectHarrisFeatures(img);

coords = round(points.Location); % (x,y pixel coord's)
metrics = points.Metric;

cimg = zeros(size(double(img),1),size(double(img),2));
for i = 1:length(coords)
    cimg(coords(i,2),coords(i,1)) = metrics(i);
end

end