% File name: feat_match.m
% Author:       Ariana Familiar
% Date created: Nov 2017

function [match] = feat_match(descs1, descs2)
% Input:
%   descs1 is a 64x(n1) matrix of double values
%   descs2 is a 64x(n2) matrix of double values

% Output:
%   match is n1x1 vector of integers where m(i) points to the index of the
%   descriptor in p2 that matches with the descriptor p1(:,i).
%   If no match is found, m(i) = -1

% Write Your Code Here

thresh = 0.6;

match = zeros(size(descs1,2), 1);

for i = 1:size(descs1,2) % for each corner in first image
    
    desc = descs1(:,i);
    
    % find 2 nearest neighbors in second image
    [ind] = kdtree(descs2', desc', 2);
    feat1 = descs2(:,ind(1)); % best matching feat 1
    feat2 = descs2(:,ind(2)); % best matching feat 2
    
    % compute SSD
    ssd1 = sum((desc - feat1).^2);
    ssd2 = sum((desc - feat2).^2);
    
    % ratio test
    if (ssd1/ssd2) < thresh
        match(i) = ind(1);
    else
        match(i) = -1; % no match found
    end
end

end