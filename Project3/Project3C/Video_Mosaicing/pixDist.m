function [dist] = pixDist(im)
%% get each pixels distance to the border
%
%   INPUT
%       im      input image
%
%   OUTPUT
%       dist    matrix of each pixel's distance to the border (in im)

    if ndims(im) == 3
        im = rgb2gray(im); % in order to make binary image for bwdist
    end
    
    dist = (im == 0);
    
    % make borders = 1
    dist(1:size(im,1), 1) = 1;
    dist(1:size(im,1), size(im,2)) = 1;
    dist(1, 1:size(im,2)) = 1;
    dist(size(im,1), 1:size(im,2)) = 1;
    
    % get distance transform
    dist = bwdist(dist);
    
end
