function [im2] = blend(im1, im2, H)
%% warp and combine two images to stitch together
%
%   INPUT
%       im1     input image #1
%       im2     input image #2
%       H       estimated homography (output of RANSAC)
%
%   OUTPUT
%       im2     resulting stitched image

%%  warp

% apply homography to get new image corners
[up_l, bot_l, up_r, bot_r] = transformCorners(H, im1);

% apply homography to rest of image
strR = round(min(up_l(2) , up_r(2)));
endR = round(max(bot_l(2), bot_r(2)));
strC = round(min(up_l(1) , bot_l(1)));
endC = round(max(bot_r(1), up_r(1)));
[y_im2, x_im2] = meshgrid(strR:endR, strC:endC);

y_im2 = y_im2(:); % column vect
x_im2 = x_im2(:);

im2_pix = [x_im2, y_im2, ones(size(x_im2,1),1)]';
trnsf = H \ im2_pix;
x_im1 = int32(trnsf(1,:)'./trnsf(3,:)');
y_im1 = int32(trnsf(2,:)'./trnsf(3,:)');

%% combine

rows_im1 = size(im1,1);
cols_im1 = size(im1,2);
rows_im2 = size(im2, 1);
cols_im2 = size(im2, 2);

% pixels w/in borders
inds = x_im1 > 0 & ...
            x_im1 <= cols_im1 & ...
            y_im1 > 0 & ...
            y_im1 <= rows_im1 & ...
            x_im2 > 0 & ...
            x_im2 <= cols_im2 & ...
            y_im2 > 0 & ...
            y_im2 <= rows_im2;

% get which im to use for each indexed pixel (im1/im2)
[weights] = getProp(im1, im2, x_im1, y_im1, x_im2, y_im2, inds);

% 'distance-based' blending
[im2] = dissolve(im1, im2, x_im1, y_im1, x_im2, y_im2, inds, weights);

end