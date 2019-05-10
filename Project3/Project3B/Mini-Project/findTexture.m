function texture = findTexture(image)
%% outputs texture within given region

rows = size(image,1);
cols = size(image,2);

% make mask to find textures
% square window:
centerX = rows/2;
centerY = cols/2;
radius = round(rows/10);
squareMask = zeros(rows,cols);
squareMask((centerY-radius):(centerY+radius),...
          (centerX-radius):(centerX+radius)) = 1;
mask = squareMask;

textMask(:,:,1) = mask;
textMask(:,:,2) = mask;
textMask(:,:,3) = mask;

% mask original image
image = im2double(image);

texture = image .* textMask;

% select only center
texture = texture((centerY-radius):(centerY+radius),...
                  (centerX-radius):(centerX+radius),:);

end