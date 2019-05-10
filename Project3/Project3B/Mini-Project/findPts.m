function [im1_pts, im2_pts] = findPts(im1, im2, numPoints)
%% find corresponding points along borders

% separate top/bottom of images so corresponding pts match up
im1_top     = im1(1:floor(size(im1,1)/2),:);
im1_top     = [im1_top ; zeros(size(im1,1)-size(im1_top,1),size(im1,2))];
im1_bottom  = im1(floor(size(im1,1)/2):end,:);
im1_bottom  = [zeros(size(im1,1)-size(im1_bottom,1),size(im1,2)) ; im1_bottom];

im2_top     = im2(1:floor(size(im2,1)/2),:);
im2_top     = [im2_top ; zeros(size(im2,1)-size(im2_top,1),size(im2,2))];
im2_bottom  = im2(floor(size(im2,1)/2):end,:);
im2_bottom  = [zeros(size(im2,1)-size(im2_bottom,1),size(im2,2)) ; im2_bottom];

% define corresponding points by finding coordinates of all points along 
% border and then taking a subset (numPoints) of the points that are 
% equidistant, for each half of image separately
[im1_x, im1_y] = find(im1_top);
[im2_x, im2_y] = find(im2_top);

im1_pts = [im1_y im1_x];
im2_pts = [im2_y im2_x];

% grab subset of points that are equidistant (top half)
if numPoints < length(im1_pts)   
    dstIm1 = round(linspace(1,length(im1_pts),numPoints));
    im1_pts = im1_pts(dstIm1,:);
else
    dstIm1 = round(linspace(1,length(im1_pts),length(im1_pts)));
    im1_pts = im1_pts(dstIm1,:);
end
if numPoints < length(im2_pts)
    dstIm2 = round(linspace(1,length(im2_pts),numPoints));
    im2_pts = im2_pts(dstIm2,:);
else
    dstIm2 = round(linspace(1,length(im2_pts),length(im2_pts)));
    im2_pts = im2_pts(dstIm2,:);
end
if length(im1_pts) > length(im2_pts)
    im1_pts = im1_pts(1:length(im2_pts),:);
elseif length(im2_pts) > length(im1_pts)
    im2_pts = im2_pts(1:length(im1_pts),:);
end

% do the same for the bottom half
[im1_x, im1_y] = find(im1_bottom);
[im2_x, im2_y] = find(im2_bottom);

im1_temp = [im1_y im1_x];
im2_temp = [im2_y im2_x];

if numPoints <= length(im1_temp)   
    dstIm1 = round(linspace(1,length(im1_temp),numPoints));
    im1_temp = im1_temp(dstIm1,:);
end
if numPoints <= length(im2_temp)
    dstIm2 = round(linspace(1,length(im2_temp),numPoints));
    im2_temp = im2_temp(dstIm2,:);
end
if length(im1_temp) > length(im2_temp)
    im1_temp = im1_temp(1:length(im2_temp),:);
elseif length(im2_temp) > length(im1_temp)
    im2_temp = im2_temp(1:length(im1_temp),:);
end

% stack top half and bottom half ind's
im1_pts = [im1_pts ; im1_temp];
im2_pts = [im2_pts ; im2_temp];

% add corners
rows = size(im1,1);
cols = size(im1,2);

im1_pts = [im1_pts; 0, 0; 0, rows; cols, rows; cols, 0];
im2_pts = [im2_pts; 0, 0; 0, rows; cols, rows; cols, 0];

% add midway borders
im1_pts = [im1_pts; 0, rows/2; cols/2, 0; cols, rows/2; cols/2, rows];
im2_pts = [im2_pts; 0, rows/2; cols/2, 0; cols, rows/2; cols/2, rows];

end