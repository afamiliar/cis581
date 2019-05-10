% File name: anms.m
% Author:       Ariana Familiar
% Date created: Nov 2017

function [x, y, rmax] = anms(cimg, max_pts)
%%
% Input:
% cimg = corner strength map
% max_pts = number of corners desired

% Output:
% [x, y] = coordinates of corners
% rmax = suppression radius used to get max_pts corners

% Write Your Own Code Here

c = 0.9;
rows = size(cimg, 1);
cols = size(cimg, 2);
rad_sz = zeros(rows,cols);

% for each pixel, if it's a corner then check w/in radius of increasing
% sizes for other corners. When find another corner (> .9*current pixel)
% record the size of that radius
for i = 1:rows
    for j = 1:cols
        for rad = 1:min(rows,cols) % for increasing rad size
            if cimg(i,j) == 0
                rad_sz(i,j) = 1;
                break;
            else
                % keep w/in boundaries
                strR = max(1,i-rad);
                endR = min(rows,i+rad);
                strC = max(1,j-rad);
                endC = min(cols,j+rad);
                
                % check for corner pixels greater than .9*pixel w/in radius 
                thresh = c * cimg(i,j);
                
                u_l = sum(cimg(strR:endR, strC) > thresh);
                u_r = sum(cimg(strR:endR, endC) > thresh);
                b_l = sum(cimg(strR, strC:endC) > thresh);
                b_r = sum(cimg(endR, strC:endC) > thresh);
                
                if u_l || u_r || b_l || b_r
                        rad_sz(i,j) = rad;
                        break;
                end
            end
        end
    end
end

% define coords for each pixel/radius size
[x, y]  = meshgrid(1:cols, 1:rows);
rad_mat = [x(:) y(:) rad_sz(:)]; % column vect

% sort by descending radius size
[~, ind] = sort(rad_mat(:,3), 'descend');
rad_mat_sorted = rad_mat(ind,:);

% grab max_pts number of corners
x    = rad_mat_sorted(1:max_pts,1);
y    = rad_mat_sorted(1:max_pts,2);
rmax = rad_mat_sorted(max_pts, 3);

end