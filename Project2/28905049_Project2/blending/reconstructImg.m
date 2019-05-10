function resultImg = reconstructImg(indexes, red, green, blue, targetImg)
%% Enter Your Code Here
%  Obtains the composite image
%
%       INPUT
%           indexes     (h' x w'), double matrix, indices of each
%                                   replacement pixel
%           red         (1 x N), intensity of red channel replacement pixel
%           green       (1 x N), intensity of green channel replacement pixel
%           blue        (1 x N), intensity of blue channel replacement pixel
%           targetImg   (h' x w' x 3), target image
%
%       OUTPUT
%           resultImg   (h' x w' x 3) double matrix, resulting cloned image
%

tar_rows = size(targetImg, 1);
tar_cols = size(targetImg, 2);

resultImg = zeros(size(targetImg));
resultImg_R = targetImg(:,:,1);
resultImg_G = targetImg(:,:,2);
resultImg_B = targetImg(:,:,3);

for i = 1:tar_rows
    for j = 1:tar_cols
        if indexes(i,j)
            resultImg_R(i,j)  = red(indexes(i,j));
            resultImg_G(i,j)  = green(indexes(i,j));
            resultImg_B(i,j)  = blue(indexes(i,j));
        end
    end
end

resultImg(:,:,1) = resultImg_R;
resultImg(:,:,2) = resultImg_G;
resultImg(:,:,3) = resultImg_B;

end