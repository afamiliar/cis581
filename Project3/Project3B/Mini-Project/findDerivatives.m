function [Mag, Magx, Magy, Ori] = findDerivatives(I_gray)
%%  Description
%       compute gradient from grayscale image 
%%  Input: 
%         I_gray = (H, W), double matrix, grayscale image matrix 
%
%%  Output:
%         Mag  = (H, W), double matrix, the magnitued of derivative
%         Magx = (H, W), double matrix, the magnitude of derivative in x-axis
%         Magy = (H, W), double matrix, the magnitude of derivative in y-axis
% 		  Ori  = (H, W), double matrix, the orientation of the derivative
%
%% ****YOUR CODE STARTS HERE**** 

%% Compute derivative & convolve image
sigma = 1; %2;
[x,y] = meshgrid(-11:11,-11:11);
G = exp(-x.^2/(2*sigma^2) - y.^2/(2*sigma^2));

[dx,dy] = gradient(G); % G is a 2D gaussain

Magx = conv2(double(I_gray),dx,'same');
Magy = conv2(double(I_gray),dy,'same');

%% Compute magnitude of gradient
Mag = sqrt(Magx.*Magx + Magy.*Magy);
Mag = real(Mag);

%% Find orientation
Ori = atan2(Magy, Magx) * (180.0/pi);

end