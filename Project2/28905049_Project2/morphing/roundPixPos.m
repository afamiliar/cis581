function [pixPos] = roundPixPos(pixPos, rows, cols)
%% round any positions outside of image border

pixPos = round(pixPos);

indx           = pixPos(2,:) > rows;
indy           = pixPos(1,:) > cols;
pixPos(2,indx) = rows;
pixPos(1,indy) = cols;

ind         = pixPos < 1;
pixPos(ind) = 1;

end