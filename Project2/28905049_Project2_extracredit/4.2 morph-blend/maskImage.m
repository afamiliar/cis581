function mask = maskImage(Img)
%% Enter Your Code Here
% Creates a binary mask of a selected area of the input image
% using built-in matlab functions (imfreehand and createMask)
%
%   INPUT
%       Img     (h x w x 3) double matrix, source image
%
%   OUTPUT
%       mask    (h x w) logical matrix, binary mask of selected region


figure; imshow(Img);
im = imfreehand(gca);

mask = createMask(im);

mask = logical(mask);

end

