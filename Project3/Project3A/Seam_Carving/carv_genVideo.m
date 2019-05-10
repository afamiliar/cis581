% File Name: carv.m
% Author:  Ariana Familiar
% Date:    10-2017

function [Ic, T] = carv_genVideo(I, nr, nc, outputName)
% discrete image resizing, generates video of seam carving operation
%
% Input:
%   I is the image being resized
%   [nr, nc] is the numbers of rows and columns to remove.
%   outputName is the desired name of the output files
% 
% Output: 
%   Ic is the resized image
%   T is the transport map

% Write Your Code Here

%%
% ====== find optimal order of vert/horz seam removal ================ 
% initialize
T = zeros(nr + 1, nc + 1);
choiceMap = ones(size(T)) * -1;
rows = size(I,1);
cols = size(I,2);

% fill T & TI starting from top row
Itemp = I;
for i = 2 : size(T,1)
    [My, Tby]   = cumMinEngHor(genEngMap(Itemp)); % horizontal direction
    [Itemp, Ey] = rmHorSeam(Itemp, My, Tby);

    T(i,1) = T(i-1,1) + Ey;
    choiceMap(i,1) = 1;
end

% fill T & TI starting from left column
Itemp = I;
for j = 2 : size(T,2)
    [Mx, Tbx]   = cumMinEngVer(genEngMap(Itemp)); % vertical direction
    [Itemp, Ex] = rmVerSeam(Itemp, Mx, Tbx);
        
    T(1,j) = T(1, j-1) + Ex;
    choiceMap(1,j) = 0;
end

% remove vertical and horizontal seam
[Mx, Tbx]   = cumMinEngVer(genEngMap(I)); % vertical direction
[Ix, ~]     = rmVerSeam(I, Mx, Tbx);
    
[My, Tby]   = cumMinEngHor(genEngMap(I)); % horizontal direction
[Iy, ~]     = rmHorSeam(I, My, Tby);    

% fill the rest of T & TI by minimizing cost
for i = 2 : size(T,1)
    Iy_temp = Iy; % horizontal
    Ix_temp = Ix; % vertical
    
    for j = 2 : size(T,2)
        [My, Tby]   = cumMinEngHor(genEngMap(Ix_temp)); % horizontal direction
        [~, Ey]     = rmHorSeam(Ix_temp, My, Tby);

        [Mx, Tbx]       = cumMinEngVer(genEngMap(Iy_temp)); % vertical direction
        [Iy_temp, Ex]   = rmVerSeam(Iy_temp, Mx, Tbx);
      
        horzCost = T(i-1,j) + Ey;
        vertCost = T(i,j-1) + Ex;
        
        if horzCost <= vertCost % minimize cost
            T(i,j) = horzCost;
            choiceMap(i,j) = 1;
        else
            T(i,j) = vertCost;
            choiceMap(i,j) = 0;
        end
        
        [Mx, Tbx]       = cumMinEngVer(genEngMap(Ix_temp)); % vertical direction
        [Ix_temp, ~]    = rmVerSeam(Ix_temp, Mx, Tbx);
    
    end
    
    [My, Tby]   = cumMinEngHor(genEngMap(Ix));
    [Ix, ~]     = rmHorSeam(Ix, My, Tby);
    
    [My, Tby]   = cumMinEngHor(genEngMap(Iy));
    [Iy, ~]     = rmHorSeam(Iy, My, Tby);

end


% ================ remove seams in optimal order ================ 
r = size(choiceMap, 1);
c = size(choiceMap, 2);

TI = cell(1,(nr + nc)+1);
TI{1} = I;

for i = 1 : (nr + nc)

    if (choiceMap(r,c) == 0)
        [Mx, Tbx]   = cumMinEngVer(genEngMap(I)); % vertical direction
        [I, ~]      = rmVerSeam(I, Mx, Tbx);
        
        c = c - 1;
        
        TI{i+1} = padarray(I,[size(choiceMap,1)-r,size(choiceMap,2)-c],0,'post');
    else
        [My, Tby]   = cumMinEngHor(genEngMap(I)); % horizontal direction
        [I, ~]      = rmHorSeam(I, My, Tby);
    
        r = r - 1;
        
        TI{i+1} = padarray(I,[size(choiceMap,1)-r,size(choiceMap,2)-c],0,'post');
    end
    
end

Ic = I;

% ================ generate movie ================ 
figure;
vid = VideoWriter([outputName '.avi']);
vid.FrameRate = 20;
open(vid);

for i = 1:length(TI)
    
    imshow(TI{i}); axis image; axis off;
    writeVideo(vid, getframe(gcf));
    
end

close(vid);


end