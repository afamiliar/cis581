% File name: ransac_est_homography.m
% Author:       Ariana Familiar
% Date created: Nov 2017

function [H, inlier_ind] = ransac_est_homography(x1, y1, x2, y2, consensus)
%%
% Input:
%    y1, x1, y2, x2 are the corresponding point coordinate vectors Nx1 such
%    that (y1i, x1i) matches (x2i, y2i) after a preliminary matching
%    thresh is the threshold on distance used to determine if transformed
%    points agree
%
% Output:
%    H is the 3x3 matrix computed in the final step of RANSAC
%    inlier_ind is the nx1 vector with indices of points in the arrays x1, y1,
%    x2, y2 that were found to be inliers

% Write Your Code Here

nRANSAC = 1000;   % iterations
N = length(x1);   % total # feature pairs

max_inliers = zeros(N, 1);

for i = 1:nRANSAC
    % randomly select 4 feature pairs
    ind = randi([1, N], 4, 1);
    
    % compute homography
    H_temp = est_homography(x2(ind), y2(ind), x1(ind), y1(ind));
    
    % compute inliers
    inliers = zeros(N, 1);
    
    % apply estimated homography
    [X, Y] = apply_homography(H_temp, x1', y1');
    
    for j = 1:N
        % line fitting error
        b = [X(j); Y(j); 1];
        a = [x2(j); y2(j); 1];
        ssd = sum((a-b).^2);
        
        % if below thresh, agrees w estimate
        if  ssd < consensus
            inliers(j) = 1;
        end
    end
    
    % keep estimate with largest # of inliers
    if sum(inliers) > sum(max_inliers)
        max_inliers = inliers;
        H = H_temp;
    end
    
end

% output coord's of final inliers
inlier_ind = find(max_inliers);

end