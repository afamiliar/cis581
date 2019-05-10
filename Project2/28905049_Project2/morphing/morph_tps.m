function [morphed_im] = morph_tps(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)
%% MORPH_TPS  Image morphing via TPS
%	Input im1: target image
%	Input im2: source image
%	Input im1_pts: correspondences coordiantes in the target image
%	Input im2_pts: correspondences coordiantes in the source image
%	Input warp_frac: a vector contains warping parameters
%	Input dissolve_frac: a vector contains cross dissolve parameters
% 
%	Output morphed_im: a set of morphed images obtained from different warp and dissolve parameters


% zero-pad images if not same size
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


% ===== Warp im1 and im2 into intermediate shape configuration =====
% =====  controlled by warp_frac

for n = 1:length(warp_frac)
    
    interim_pts = ((1-warp_frac(n)) * im1_pts) + (warp_frac(n) * im2_pts);

    % TPS model computation
    
    % compute 2 TPS, one for x-coords & one for y-coords
    % then transform all pixels in source image by TPS model
    [a1_x, ax_x, ay_x, w_x] = est_tps(interim_pts, im1_pts(:,1));
    [a1_y, ax_y, ay_y, w_y] = est_tps(interim_pts, im1_pts(:,2));

    im1_warped{n} = obtain_morphed_tps(im1_padded, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, interim_pts, [rows, cols]);

    [a1_x,ax_x,ay_x,w_x] = est_tps(interim_pts, im2_pts(:,1));
    [a1_y,ax_y,ay_y,w_y] = est_tps(interim_pts, im2_pts(:,2));

    im2_warped{n} = obtain_morphed_tps(im2_padded, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, interim_pts, [rows, cols]);

end


% ===== Cross-dissolve the warped images according to dissolve_frac =====

for m = 1:length(dissolve_frac)
    
    morph = ((1-dissolve_frac(m)) * im1_warped{m}) + (dissolve_frac(m) * im2_warped{m});
    morphed_im{m} = uint8(morph);
    
end

end