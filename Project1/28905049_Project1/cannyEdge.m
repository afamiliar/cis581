 function E = cannyEdge(I)
%%  Description
%       the main function of canny edge
%%  Input: 
%        I = (H, W, 3), uint8 matrix, the input RGB image
%
%%  Output:
%        E = (H, W), logic matrix, the edge detection result.
%


%% Convert the color image to gray scale image
I_gray = rgb2gray(I);


%% Compute magnitutde and orientation of derivatives
%% **TODO: finish the findDerivative function
[Mag, Magx, Magy, Ori] = findDerivatives(I_gray);
visDerivatives(I_gray, Mag, Magx, Magy);


%% Detect local maximum
%% **TODO: finish the nonMaxSup function
M = nonMaxSup(Mag, Ori);
figure; imagesc(M); colormap(gray);

%% Link edges
%% **TODO: finish the edgeLink function
E = edgeLink(M, Mag, Ori);
figure; imagesc(E); colormap(gray);
end
