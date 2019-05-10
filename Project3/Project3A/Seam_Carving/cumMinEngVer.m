% File Name: cumMinEngVer.m
% Author:  Ariana Familiar
% Date:    10-2017

function [Mx, Tbx] = cumMinEngVer(e)
% Input:
%   e is the energy map

% Output:
%   Mx is the cumulative minimum energy map along vertical direction.
%   Tbx is the backtrack table along vertical direction.

% Write Your Code Here

%% vertical = top to bottom

e_rows = size(e,1);
e_cols = size(e,2);

Mx  = zeros(e_rows, e_cols); % value matrix
Px = zeros(e_rows, e_cols);  % path matrix


% value of pixel in accumulated cost matrix is = to pixel value in energy 
% map added to minimum of top 3 neighbors (top-left, top-center, top-right) 
% from accumulated cost matrix

for i = 1 : e_rows
    for j = 1 : e_cols
        if i == 1
            Mx(i,j) = e(i,j); % value of very top row is = energy map
            Px(i,j) = 0;     % first row is 0s
        else
            if j == 1 % if first column
                [neigh, loc] = min([Mx(i-1, j), Mx(i-1, j+1)]);
                Mx(i,j) = e(i,j) + neigh;
                if loc == 1
                    Px(i,j) = 0;
                elseif loc == 2
                    Px(i,j) = 1;
                end
                
            elseif j == size(Mx,2) % if last column
                [neigh, loc] = min([Mx(i-1, j-1), Mx(i-1, j)]);
                Mx(i,j) = e(i,j) + neigh;
                if loc == 1
                    Px(i,j) = -1;
                elseif loc == 2
                    Px(i,j) = 0;
                end
                
            else
                [neigh, loc] = min([Mx(i-1, j-1), Mx(i-1, j), Mx(i-1, j+1)]);
                Mx(i,j) = e(i,j) + neigh;
                if loc == 1
                    Px(i,j) = -1;
                elseif loc == 2
                    Px(i,j) = 0;
                elseif loc == 3
                    Px(i,j) = 1;
                end
            end
        end
    end
end

% The minimum seam is then calculated by backtracing from the bottom to 
% the top row. First, the minimum value pixel in the bottom row of the 
% accumulated cost matrix is located. This is the bottom pixel of the 
% minimum seam. The seam is then traced back up to the top row of the 
% accumulated cost matrix by following the path matrix.

[~, minLoc] = min(Mx(e_rows,:)); % minimum of last row
ind = e_rows;
Tbx = zeros(e_rows, e_cols);
Tbx(ind, minLoc) = 1;

for i = 1 : e_rows-1
    ind = ind - 1;

    Tbx(ind, minLoc + Px(ind, minLoc)) = 1;
    minLoc = minLoc + Px(ind, minLoc);
    
end

end