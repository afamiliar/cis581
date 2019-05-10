function [ind_nearest] = kdtree(x, y, k)
%% find k nearest neighbors
%
%   INPUT
%       x       data matrix (N x 64)
%       y       sample points (1 x 64)
%       k       how many neighbors to find
%
%   OUTPUT
%       ind_nearest     indices of k nearest neighbors 

% compute sum of squares
SSDy = sum(y.^2, 2); % for each row of y (sample points)
SSDx = sum(x.^2, 2); % for each row of x (data points)

% compute distance matrix
D = (SSDy + SSDx.') - 2*y*x.'; 
D = D.^(0.5); % square root

% sort distances in ascending order
[~, ind] = sort(D, 2);

% find k nearest neighbors
ind_nearest = ind(:, 1:k);

end