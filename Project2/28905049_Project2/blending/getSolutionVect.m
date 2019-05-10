function [solVectorb] = getSolutionVect(indexes, source, target, offsetX, offsetY)
%% Enter Your Code Here
%  Generates solution vector b (for solving Ax = b)
%
%       INPUT
%           indexes     (h' x w'), double matrix, indices of each
%                                   replacement pixel
%           source      (h x w), matrix of one color channel of
%                                   source image
%           target      (h' x w'), matrix of one color channel of
%                                   target image
%           offsetX     double, x-axis offset of source image
%           offsetY     double, y-axis offset of source image
%
%       OUTPUT
%           solVectorb  (1 x N), solution vector
%

s_rows = size(source,1);
s_cols = size(source,2);
ind = 1;

N = max(indexes(:));
b = zeros(1,N);

for i = 1 : s_rows
    for j = 1 : s_cols
        if indexes(i+offsetX, j+offsetY)
            
            b(ind) = source(i,j) ;

            if indexes(i+offsetX-1, j+offsetY) == 0
                b(ind) = b(ind) + target(i+offsetX-1, j+offsetY);
            end
            
            if indexes(i+offsetX+1, j+offsetY) == 0
                b(ind) = b(ind) + target(i+offsetX+1, j+offsetY);
            end
            
            if indexes(i+offsetX, j+offsetY-1) == 0
                b(ind) = b(ind) + target(i+offsetX, j+offsetY-1);
            end
            
            if indexes(i+offsetX, j+offsetY+1) == 0
                b(ind) = b(ind) + target(i+offsetX, j+offsetY+1);
            end
            
            ind = ind + 1;

        end
    end
end

solVectorb = b(:)';

end