function [morphed_im] = obtain_morphed_tps(im_source, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, interim_pts, sz)
%OBTAIN_MORPHED_TPS	Image morphing based on TPS parameters 
%	Input im_source: the source image
%	Input a1_x, ax_x, ay_x, w_x: the TPS parameters in x dimension
%	Input a1_y, ax_y, ay_y, w_y: the TPS parameters in y dimension
%	Input interim_pts: correspondences position in the intermediate image 
%	Input sz: a vector rerpesents the intermediate image size
% 
%	Output morphed_im: the morphed image

rows = sz(1);
cols = sz(2);

%%
pixPos     = [ zeros(2, rows * cols); ones(1, rows * cols) ];
numPts     = length(interim_pts);
pixInd     = [ repmat(1:cols, 1, rows); reshape(repmat(1:rows, cols, 1), [1 rows*cols]) ];
morphed_im = zeros(rows, cols, 3);

r_sqr       = ((repmat(interim_pts(:,1), 1, length(pixInd)) - repmat(pixInd(1,:), numPts, 1)).^2) + ...
              ((repmat(interim_pts(:,2), 1, length(pixInd)) - repmat(pixInd(2,:), numPts, 1)).^2);
K           = -r_sqr.* log(r_sqr);
K(isnan(K)) = 0;

pixPos(1:2, :)  = repmat([a1_x ;a1_y], 1, length(pixInd)) ...
                    + [ax_x, ay_x; ax_y, ay_y] * pixInd + [w_x'; w_y'] * K;

% round position values & keep w/in image borders
[pixPos] = roundPixPos(pixPos, rows, cols);

% Copy the pixel value at (xs,ys) in the source image back to the
%   intermediate image
for i = 1 : rows*cols
    morphed_im(pixInd(2,i), pixInd(1,i), :) = im_source(pixPos(2, i), pixPos(1, i), :);
end
    
end

