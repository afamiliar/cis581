 function E = cannyEdge(I)
%%  Description
%       the main function of canny edge
%%  Input: 
%        I = (H, W, 3), uint8 matrix, the input RGB image
%
%%  Output:
%        E = (H, W), uint8 matrix, the edge detection result.
%

%% Separate color channels
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

%% Compute magnitutde and orientation of derivatives
%% **TODO: finish the findDerivative function
[MagR, MagxR, MagyR, OriR] = findDerivatives(R);
% visDerivatives(R, MagR, MagxR, MagyR);

[MagG, MagxG, MagyG, OriG] = findDerivatives(G);
% visDerivatives(G, MagG, MagxG, MagyG);

[MagB, MagxB, MagyB, OriB] = findDerivatives(B);
% visDerivatives(B, MagB, MagxB, MagyB);

%% Detect local maximum
%% **TODO: finish the nonMaxSup function
MR = nonMaxSup(MagR, OriR);
% figure; imagesc(MR); colormap(gray);

MG = nonMaxSup(MagG, OriG);
% figure; imagesc(MG); colormap(gray);

MB = nonMaxSup(MagB, OriB);
% figure; imagesc(MB); colormap(gray);

%% Link edges
%% **TODO: finish the edgeLink function
ER = edgeLink(MR, MagR, OriR);
% figure; imagesc(ER); colormap(gray);

EG = edgeLink(MG, MagG, OriG);
% figure; imagesc(EG); colormap(gray);

EB = edgeLink(MB, MagB, OriB);
% figure; imagesc(EB); colormap(gray);

maskedR = double(R) .* ER;
maskedG = double(G) .* EG;
maskedB = double(B) .* EB;

% final(:,:,1) = maskedR;
% final(:,:,2) = maskedG;
% final(:,:,3) = maskedB;
final = maskedR + maskedG + maskedB;

gcf = figure; imagesc(final); colormap(jet); colorbar;

E = uint8(final);

end
