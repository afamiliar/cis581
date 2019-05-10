% File Name: rmHorSeam.m
% Author:
% Date:

function [Iy, E] = rmHorSeam(I, My, Tby)
% Input:
%   I is the image. Note that I could be color or grayscale image.
%   My is the cumulative minimum energy map along horizontal direction.
%   Tby is the backtrack table along horizontal direction.

% Output:
%   Iy is the image removed one row.
%   E is the cost of seam removal

% Write Your Code Here
%%
% All the pixels in each row after the pixel to be removed are shifted 
% left one column. Then, the width of the image is reduced by one pixel

I_rows = size(I,1);
I_cols = size(I,2);
Iy = I;
E = 0;

for i = 1 : I_cols
    ind = find(Tby(:,i));
    E = E + My(ind,i);
    
    for j = ind+1 : I_rows
        if length(size(Iy)) == 3
            Iy(j-1,i,:) = Iy(j,i,:);
        else
            Iy(j-1,i) = Iy(j,i);
        end
    end
    
end

if ndims(I) == 3
    Iy(I_rows,:,:) = [];
else
    Iy(I_rows,:) = [];
end

end