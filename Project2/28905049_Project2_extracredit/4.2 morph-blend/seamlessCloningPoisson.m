function resultImg = seamlessCloningPoisson(sourceImg, targetImg, mask, offsetX, offsetY)
%% Enter Your Code Here
%  Wrapper function for gradient domain (Poisson) blending 
%  using Laplacian operator
%
%       INPUT
%           sourceImg   (h x w x 3), source image
%           targetImg   (h' x w' x 3), target image
%           mask        (h x w), logical matrix, replacement region
%           offsetX     double, x-axis offset of source image
%           offsetY     double, y-axis offset of target image
%
%       OUTPUT
%           resultImg   (h' x w' x 3), resulting cloned image
%

targetH = size(targetImg,1);
targetW = size(targetImg,2);

% if mask extends outside of target image, throw error and exit
if (size(mask,1) + offsetX) > targetH || ...
   (size(mask,2) + offsetY) > targetW || ...
        offsetX < 0 || offsetY < 0
    
   error('ERROR: Mask is outside of target image')
end

% index the replacement pixels
[indexes] = getIndexes(mask, targetH, targetW, offsetX, offsetY);

% if mask lies at edge of target image, ask to zero-pad or not (if not, exit)
trim = 0;
[ind_rows, ind_cols] = find(indexes);

if (min(ind_rows) == 1) || (max(ind_rows) == targetH) || ...
   (min(ind_cols) == 1) || (max(ind_cols) == targetW)
    
    disp('WARNING: Replacement region is at edge of target image.')
    disp('WARNING: Continue with zero-padding of target (y/n)? Blending will not be accurate.')
    
    % get button press (y/n)
    key = 0;
    while key == 0
        w = waitforbuttonpress;
        key = get(gcf, 'CurrentCharacter'); 
        disp(key)
    end
    
    if key == 'y'    % if yes, zero-pad
        close all;
        indexes   = padarray(indexes, [1 1]);
        targetImg = padarray(targetImg, [1 1]);
        trim = 1;
    elseif key == 'n' % if no, exit
        close all;
        error('Breaking out of blending function.');
        return
    end
end

% compute coefficient matrix A
[A] = getCoefficientMatrix(indexes);

% convolve source image with laplacian operator
laplacian = [0 -1 0; -1 4 -1; 0 -1 0];
filteredSourceR = imfilter(sourceImg(:,:,1), laplacian);
filteredSourceG = imfilter(sourceImg(:,:,2), laplacian);
filteredSourceB = imfilter(sourceImg(:,:,3), laplacian);

% compute vector b for each color channel separately
[R_b]  = getSolutionVect(indexes, filteredSourceR, targetImg(:,:,1), offsetX, offsetY);
[G_b]  = getSolutionVect(indexes, filteredSourceG, targetImg(:,:,2), offsetX, offsetY);
[B_b]  = getSolutionVect(indexes, filteredSourceB, targetImg(:,:,3), offsetX, offsetY);

% solve Ax = b
red     = A \ R_b';
green   = A \ G_b';
blue    = A \ B_b';

% reshape and combine results
[resultImg] = reconstructImg(indexes, red', green', blue', targetImg);

% if zero-padded, trim the border
if trim
    resultImg = resultImg(2:end-1, 2:end-1, :);
end

end