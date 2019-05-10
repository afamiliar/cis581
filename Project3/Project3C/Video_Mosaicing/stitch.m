function [im2] = stitch(im1, im2)
%% stitch two color images together
%
%   INPUT
%       im1     input image #1 (double)
%       im2     input image #2 (double)
%
%   OUTPUT
%       im2     resulting stitched image (double)

    % define features
    nFeatures = 500; % as per Brown, Szeliski & Winder (2005)
    cimg_im1 = corner_detector(rgb2gray(im1));
    [x_im1, y_im1, ~] = anms(cimg_im1, nFeatures);
    [descs_im1] = feat_desc(im1, x_im1, y_im1);

    cimg_im2 = corner_detector(rgb2gray(im2));
    [x_im2, y_im2, ~] = anms(cimg_im2, nFeatures);
    [descs_im2] = feat_desc(im2, x_im2, y_im2);

    % match features
    [matches] = feat_match(descs_im1, descs_im2);

    match_ind = (matches ~= -1); % exclude no match
    feat_x_im1 = x_im1(match_ind);
    feat_y_im1 = y_im1(match_ind);
    feat_x_im2 = x_im2(matches(match_ind));
    feat_y_im2 = y_im2(matches(match_ind));

    % RANSAC to estimate homography for matching features
    consensus = 50;
    [H, inds] = ransac_est_homography(feat_x_im1, feat_y_im1, feat_x_im2, feat_y_im2, consensus);

    % warp and dissolve images
    [im2] = blend(im1, im2, H);
    
end
