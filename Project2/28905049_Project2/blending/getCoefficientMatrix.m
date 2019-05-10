function [coeffA] = getCoefficientMatrix(indexes)
%% Enter Your Code Here
%  Generates coefficient matrix A (for solving Ax = b)
%
%       INPUT
%           indexes     (h' x w') double matrix, indices of replacement
%                                 pixels
%
%       OUTPUT
%           coeffA      (N x N) sparse matrix, coefficient matrix
%                               (N is number of replacement pixels)
%

t_rows = size(indexes,1);
t_cols = size(indexes,2);

N = max(indexes(:));
A = zeros(N,N);

for i = 1 : t_rows
    for j = 1 : t_cols
        if indexes(i,j)
            
            ind = indexes(i,j);
            A(ind,ind) = 4;
            
            if indexes(i,j+1)
                A(ind,indexes(i,j+1)) = -1;
            end
            
            if indexes(i,j-1)
                A(ind,indexes(i,j-1)) = -1;
            end
            
            if indexes(i+1,j)
                A(ind,indexes(i+1,j)) = -1;
            end
            
            if indexes(i-1,j)
                A(ind,indexes(i-1,j)) = -1;
            end

        end
    end
end

coeffA = sparse(A);

end
