function indexes = getIndexes(mask, targetH, targetW, offsetX, offsetY)
%% Enter Your Code Here
%  Obtains indexes of replacement pixels for source image
%
%       INPUT
%           mask        (h x w) logical matrix, binary mask of replacement
%                               region
%           targetH     (h') double, target image height
%           targetW     (w') double, target image width
%           offsetX     double, x-axis offset of source image 
%           offsetY     double, y-axis offset of source image
%
%       OUTPUT
%           indexes     (h' x w') double matrix, indices of each
%                                 replacement pixel
%

m_rows = size(mask, 1);
m_cols = size(mask, 2);

indexes = zeros(targetH, targetW);

ind = 1;

for i = 1:m_rows
    for j = 1:m_cols
        if mask(i,j)
            
            indexes(i+offsetX,j+offsetY) = ind;
            ind = ind + 1;

        end
    end
end

end