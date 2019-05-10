function [morphed_im] = morph_tri(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)
%% MORPH_TRI Image morphing via Triangulation
%	Input im1: target image
%	Input im2: source image
%	Input im1_pts: correspondences coordiantes in the target image
%	Input im2_pts: correspondences coordiantes in the source image
%	Input warp_frac: a vector contains warping parameters
%	Input dissolve_frac: a vector contains cross dissolve parameters
% 
%	Output morphed_im: a set of morphed images obtained from different warp and dissolve parameters
%
%   Calls: roundPixPos

% Helpful functions: delaunay, tsearchn

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

% ===== Warp im1 and im2 into intermediate shape configuration =====
% =====  controlled by warp_frac
for n = 1:length(warp_frac)

    % intermediate shape configuration
    intermShape = ((1-warp_frac(n)) * im1_pts) + (warp_frac(n) * im2_pts);

    % triangulation at midway shape using Delaunay triangulation
    im_pts    = intermShape;
    triangles = delaunay(im_pts);

    % for each pixel in intermediate shape, 
    %   determine which triangle it belongs to & the barycentric coordinates
    pixCoords  = [ repmat(1:cols, 1, rows); ...
                    reshape(repmat(1:rows, cols, 1), [1 rows*cols]) ];
                
    [row_ind] = tsearchn(intermShape, triangles, pixCoords');

    pixCoords  = [ pixCoords; ones(1, rows * cols) ];

    % for each pixel, compute corresponding position in source images
    pixPos_im1 = zeros(3, rows * cols);
    pixPos_im2 = zeros(3, rows * cols);

    for i = 1:length(triangles)

        % for each triangle, calculate the affine transform matrix
        mat_im1  = [ im1_pts(triangles(i,1),:)' im1_pts(triangles(i,2),:)' im1_pts(triangles(i,3),:)'; ...
                        ones(1,3) ] ;
        mat_im2  = [ im2_pts(triangles(i,1),:)' im2_pts(triangles(i,2),:)' im2_pts(triangles(i,3),:)'; ...
                        ones(1,3) ] ;
        mat_warp = [ im_pts(triangles(i,1),:)' im_pts(triangles(i,2),:)' im_pts(triangles(i,3),:)'; ...
                        ones(1,3) ] ;

        transform_im1 = mat_im1 / mat_warp;
        transform_im2 = mat_im2 / mat_warp;

        % apply the transform matrix to each pixel in the triangle in source image
        pixPos_im1(:, row_ind == i) = transform_im1 * pixCoords(:, row_ind == i);
        pixPos_im2(:, row_ind == i) = transform_im2 * pixCoords(:, row_ind == i);

    end

    % round position values & keep w/in image borders
    [pixPos_im1] = roundPixPos(pixPos_im1, rows, cols);
    [pixPos_im2] = roundPixPos(pixPos_im2, rows, cols);


    % Copy the pixel value at (xs,ys) in the source image back to the
    %   intermediate image
    for i = 1:length(row_ind)

        im1_warped{n}(pixCoords(2, i), pixCoords(1, i), :) = im1_padded(pixPos_im1(2, i), pixPos_im1(1, i), :);
        im2_warped{n}(pixCoords(2, i), pixCoords(1, i), :) = im2_padded(pixPos_im2(2, i), pixPos_im2(1, i), :);

    end

end


% ===== Cross-dissolve the warped images according to dissolve_frac =====

for m = 1:length(dissolve_frac)

    morph = ((1-dissolve_frac(m)) * im1_warped{m}) + (dissolve_frac(m) * im2_warped{m});

    morphed_im{m} = uint8(morph);

end

end