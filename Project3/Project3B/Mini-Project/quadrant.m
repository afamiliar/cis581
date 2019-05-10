function neighborhood = quadrant(Ori, x, y)
%% DESCRIPTION
%   define 3 neighbors for current pixel based on its gradient direction
%   output a binary mask of this neighborhood

%%  Input: 
%         Ori = (H, W), double matrix, the orientation of derivative
%         x, double, location in first dimension  (H)
%         y, double, location in second dimension (W)

%%  Output:
%         neighborhood = (H, W), double matrix, binary map of 3 neighbors
%


    neighborhood = zeros(size(Ori,1), size(Ori,2));
    orientation = Ori(x, y);

    if (orientation < 0)
        orientation = orientation + 360; end;

    if (orientation >= 0) && (orientation <= 90)
        coords = [0 1; -1 1; -1 0];
    elseif (orientation > 90) && (orientation <= 180)
        coords = [0 -1; -1 -1; -1 0];
    elseif (orientation > 180) && (orientation <= 270)
        coords = [0 -1; 1 -1; 1 0];
    elseif (orientation > 270) && (orientation <= 360)
        coords = [1 0; 1 1; 0 1];
    end

    neighborhood(x+coords(1,1), y+coords(1,2)) = 1;
    neighborhood(x+coords(2,1), y+coords(2,2)) = 1;
    neighborhood(x+coords(3,1), y+coords(3,2)) = 1;
    
end