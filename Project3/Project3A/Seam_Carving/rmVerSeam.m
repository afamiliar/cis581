% File Name: rmVerSeam.m
% Author:
% Date:

function [Ix, E] = rmVerSeam(I, Mx, Tbx)
% Input:
%   I is the image. Note that I could be color or grayscale image.
%   Mx is the cumulative minimum energy map along vertical direction.
%   Tbx is the backtrack table along vertical direction.

% Output:
%   Ix is the image removed one column.
%   E is the cost of seam removal

% Write Your Code Here

%%
% All the pixels in each column after the pixel to be removed are shifted 
% up one row. Then, the height of the image is reduced by one pixel

I_rows = size(I,1);
I_cols = size(I,2);
Ix = I;
E = 0;

for i = 1 : I_rows
    ind = find(Tbx(i,:));
    E = E + Mx(i,ind);
    
    for j = ind+1 : I_cols
        if length(size(Ix)) == 3
            Ix(i,j-1,:) = Ix(i,j,:);
        else
            Ix(i,j-1) = Ix(i,j);
        end
    end
end

if ndims(I) == 3
    Ix(:,I_cols,:) = [];
else
    Ix(:,I_cols) = [];
end

end