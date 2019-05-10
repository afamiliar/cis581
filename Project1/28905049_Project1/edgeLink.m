function E = edgeLink(M, Mag, Ori)
%%  Description
%       use hysteresis to link edges

%%  Input: 
%        M = (H, W), logic matrix, output from non-max suppression
%        Mag = (H, W), double matrix, the magnitude of gradient
%    	 Ori = (H, W), double matrix, the orientation of gradient
%
%%  Output:
%        E = (H, W), logic matrix, the edge detection result.
%
%% ****YOUR CODE STARTS HERE**** 

magMasked   = Mag .* M;

cv = (std(magMasked(find(magMasked~=0))) /...
        mean(magMasked(find(magMasked~=0)))); % coefficient of variance
    
threshHigh  = (3.4*cv) * mean(magMasked(find(magMasked~=0)));
threshLow   = (1.7*cv) * mean(magMasked(find(magMasked~=0)));

% find all pixels with mag >= high threshold (high mag map)
highMagIndx  = (magMasked >= threshHigh);
edges = highMagIndx;

% search along edges in high mag map for neighboring strong/weak pixels 
[a, b] = size(M);

for i = 2:a-1
    for j = 2:b-1
        if ~isempty(highMagIndx(i,j))
            
            edges = edgeFollow(edges, magMasked, Ori, i, j, threshLow);
            % also search along edge in opposite direction:
            edges = edgeFollow(edges, magMasked, -Ori, i, j, threshLow);
            
        end
    end
end

E = logical(edges);

end


