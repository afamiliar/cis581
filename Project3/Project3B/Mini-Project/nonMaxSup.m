function M = nonMaxSup(Mag, Ori)
%%  Description
%       compute the local minimal along the gradient.

%%  Input: 
%         Mag = (H, W), double matrix, the magnitude of derivative 
%         Ori = (H, W), double matrix, the orientation of derivative

%%  Output:
%         M = (H, W), logic matrix, the edge map
%
%% ****YOUR CODE STARTS HERE**** 

%% Non-maximal suppression

% interpolate neighbors and see if center is local max ("thinning")
[n,m] = size(Mag);
M = zeros(size(Mag));

for i = 2:n-1
    for j = 2:m-1
        
        orientation = Ori(i,j); % orientation for this pixel
        if (orientation < 0)
            orientation = orientation + 180; end;
                
        % define each pair of coord's to interpolate between
        if (orientation >= 0) && (orientation <= 45)
            coords1 = [-1 1; 0 1];
            coords2 = [0 -1; 1 -1];
        elseif (orientation > 45) && (orientation <= 90)
            coords1 = [-1 0; -1 1];
            coords2 = [1 -1; 1 0];
        elseif (orientation > 90) && (orientation <= 135)
            coords1 = [-1 -1; -1 0];
            coords2 = [1 0; 1 1];
        elseif (orientation > 135) && (orientation <= 180)
            coords1 = [-1 -1; 0 -1];
            coords2 = [0 1; 1 1];
        end

        % interpolate mag between a pair of coord's 
        %   given the exact orientation of gradient
        Z1 = interp1([0 1], ...
                        [Mag(i+coords1(1,1),j+coords1(1,2)) Mag(i+coords1(2,1),j+coords1(2,2))], ...
                        [0 orientation/180 1]);
        Z2 = interp1([0 1], ...
                        [Mag(i+coords2(1,1),j+coords2(1,2)) Mag(i+coords2(2,1),j+coords2(2,2))], ...
                        [0 orientation/180 1]);

        % mark as edge if local maximum (i.e. > both interpolated values)
        if (Mag(i,j) > Z1(2)) && (Mag(i,j) > Z2(2))
            M(i,j) = 1;
        end
        
    end
end

M = logical(M);

end