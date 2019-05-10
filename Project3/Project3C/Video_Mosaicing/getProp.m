function [weights] = getProp(im1, im2, x_im1, y_im1, x_im2, y_im2, inds)
%% get proportion im1/im2 for pixels defined by inds
%
%   INPUT
%       im1         input image #1
%       im2         input image #2
%       x_im1       warped pixels in x-dim for im1
%       y_im1       warped pixels in y-dim for im1
%       x_im2       warped pixels in x-dim for im2
%       y_im2       warped pixels in y-dim for im2
%       inds        index of pixels within image borders
%
%   OUTPUT
%       weights     distance-based blending results (weight of im1/im2 for
%                   each indexed pixel)

% select subset of pixels depending on inds
x_im1 = (x_im1(inds) - 1);
y_im1 = y_im1(inds);
x_im2 = (x_im2(inds) - 1);
y_im2 = y_im2(inds);

% get each pixels distance to the border
dist_im1 = pixDist(im1);
dist_im2 = pixDist(im2);

% assign im1/im2 accordingly 
ind_im1 = x_im1 * size(im1,1) + y_im1;
ind_im2 = x_im2 * size(im2,1) + y_im2;

weights = dist_im1(ind_im1) ./ (dist_im1(ind_im1) + dist_im2(ind_im2));
weights(isnan(weights)) = 0;

end