% File Name: cumMinEngHor.m
% Author:  Ariana Familiar
% Date:    10-2017

function [My, Tby] = cumMinEngHor(e)
% Input:
%   e is the energy map.

% Output:
%   My is the cumulative minimum energy map along horizontal direction.
%   Tby is the backtrack table along horizontal direction.

% Write Your Code Here

%% horizontal = left to right

e_rows = size(e,1);
e_cols = size(e,2);

My = zeros(e_rows, e_cols); % value matrix
Py = zeros(e_rows, e_cols); % path matrix

% value of pixel in accumulated cost matrix is = to pixel value in energy 
% map added to minimum of left 3 neighbors (left-top, left-center, left-bottom) 
% from accumulated cost matrix

for j = 1 : e_cols
    for i = 1 : e_rows
        if j == 1
            My(i,j) = e(i,j); % value of leftmost col is = energy map
            Py(i,j) = 0;
        else
            if i == 1 % if first row
                [neigh, loc] = min([My(i, j-1), My(i+1, j-1)]);
                My(i,j) = e(i,j) + neigh;
                if loc == 1
                    Py(i,j) = 0;
                elseif loc == 2
                    Py(i,j) = 1;
                end
                
            elseif i == size(My,1) % if last row
                [neigh, loc] = min([My(i-1, j-1), My(i, j-1)]);
                My(i,j) = e(i,j) + neigh;
                if loc == 1
                    Py(i,j) = -1;
                elseif loc == 2
                    Py(i,j) = 0;
                end
                
            else
                [neigh, loc] = min([My(i-1, j-1), My(i, j-1), My(i+1, j-1)]);
                My(i,j) = e(i,j) + neigh;
                if loc == 1
                    Py(i,j) = -1;
                elseif loc == 2
                    Py(i,j) = 0;
                elseif loc == 3
                    Py(i,j) = 1;
                end
            end
        end
    end
end

% The minimum seam is then calculated by backtracing from the bottom to 
% the top edge. First, the minimum value pixel in the right column of the 
% accumulated cost matrix is located. This is the right-most pixel of the 
% minimum seam. The seam is then traced to the left-most column of the 
% accumulated cost matrix by following the path matrix.

[~, minLoc] = min(My(:,e_cols)); % minimum of last column
ind = e_cols;
Tby = zeros(e_rows, e_cols);
Tby(minLoc, e_cols) = 1;

for i = 1 : e_cols-1
    ind = ind - 1;

    Tby(minLoc + Py(minLoc, ind), ind) = 1;
    minLoc = minLoc + Py(minLoc, ind);
    
end

end