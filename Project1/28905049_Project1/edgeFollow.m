function edges = edgeFollow(edges, Mag, Ori, x, y, lowThresh)
%% follow along edge until current pixel is not above the low threshold
%   or if there is a strong neighbor
%   or if reach border of image
%
%   otherwise, find the neighbor in the gradient direction (discretized)
%       with the largest magnitude, mark that neighbor as edge, 
%       and continue following edge in that direction

%%  Input: 
%         edges = (H,W), double matrix, results of edge linking
%         Mag  = (H, W), double matrix, the magnitued of derivative
%         Ori = (H, W), double matrix, the orientation of derivative
%         x, double, location in first dimension  (H)
%         y, double, location in second dimension (W)
%         lowThresh, double, lower threshold

%%  Output:
%         edges = (H,W), double matrix, results of edge linking
%

    while Mag(x, y) > lowThresh
        
        edges(x, y) = 1;
        neighborhood = quadrant(Ori, x, y);
        strongNeighbors = neighborhood .* edges;
        
        if sum(strongNeighbors(:)) > 0
            return
        else
            [maxX, Xvect] = max((neighborhood .* Mag),[],2);
            [~, x] = max(maxX);
            y = Xvect(x);
        end
        
        if x > 321 || y > 481
            return
        end
    end
    
end