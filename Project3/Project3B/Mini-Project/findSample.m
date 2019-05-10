function dissolvedText = findSample(images, permInd)
%%

numIm = length(images);

% find texture regions for all images
for i = 1:numIm
    textures{i} = findTexture(images{i});
end

dissolve_frac = 1/numIm;
for i = 1:numIm-1
    if i == 1
        dissolvedText = ((1-dissolve_frac)*textures{permInd(1)}) + (dissolve_frac*textures{permInd(2)});
    else
        dissolvedText = ((1-dissolve_frac)*dissolvedText) + (dissolve_frac*textures{permInd(i+1)});
    end
end
    
end