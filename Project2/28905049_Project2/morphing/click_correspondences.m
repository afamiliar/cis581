function [im1_pts, im2_pts] = click_correspondences(im1, im2)
%CLICK_CORRESPONDENCES Find and return point correspondences between images
%   Input im1: target image
%	Input im2: source image
%	Output im1_pts: correspondence-coordiantes in the target image
%	Output im2_pts: correspondence-coordiantes in the source image

%% Your code goes here
% You can use built-in functions such as cpselect to manually select the
% correspondences

% pad images if not same size
[rowsim1, colsim1, ~] = size(im1);
[rowsim2, colsim2, ~] = size(im2);
if rowsim1 == rowsim2 && colsim1 == colsim2
    rows = rowsim1;
    cols = colsim1;
    im1_padded = im1;
    im2_padded = im2;
else
    rows = max(rowsim1, rowsim2); 
    cols = max(colsim1, colsim2);
    im1_padded = padarray(im1, [rows-rowsim1, cols-colsim1], 'replicate', 'post');
    im2_padded = padarray(im2, [rows-rowsim2, cols-colsim2], 'replicate', 'post');
end

% corresponding points
[im1_pts, im2_pts] = cpselect(im1_padded, im2_padded, 'Wait', true);

% add corner points
im1_pts = [im1_pts; 0, 0; 0, rows; cols, rows; cols, 0];
im2_pts = [im2_pts; 0, 0; 0, rows; cols, rows; cols, 0];

end