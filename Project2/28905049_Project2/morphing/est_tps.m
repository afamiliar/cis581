function [a1, ax, ay, w] = est_tps(interim_pts, source_pts)
%EST_TPS Thin-plate parameter estimation
%	Input interim_pts: correspondences position in the intermediate image 
%	Input source_pts: correspondences position in the source image
% 
%	Output a1: TPS parameters
%	Output ax: TPS parameters
%	Output ay: TPS parameters
%	Output w: TPS parameters

numPts = length(interim_pts); % number of corresponding points

P       = [ones(numPts, 1) interim_pts]; % size = numPts x 3
warp_pts_x = repmat(interim_pts(:,1), 1, numPts);
warp_pts_y = repmat(interim_pts(:,2), 1, numPts);
r_sqr   = ((warp_pts_x - warp_pts_x').^2) + ((warp_pts_y - warp_pts_y').^2);
K       = -r_sqr .* log(r_sqr); % size = numPts x numPts
K(isnan(K)) = 0;

L   = [K P; P' zeros(3,3)];
v   = [source_pts; zeros(3,1)];
I   = eye(numPts + 3, numPts + 3); % identity matrix
lambda = 0;

% compute solution
warning('off','MATLAB:nearlySingularMatrix')
params = (inv(L) + (lambda * I)) * v;
w    = params(1:numPts);
a1   = params(numPts+1);
ax   = params(numPts+2);
ay   = params(numPts+3);

end