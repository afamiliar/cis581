function [up_l, bot_l, up_r, bot_r] = transformCorners(H, im1)
%% apply homography to get new image corners
%
%   INPUT
%       H    estimated homography
%       im1  image to be warped
%
%   OUTPUT
%       up_l    upper left corner
%       bot_l   bottom left corner
%       up_r    upper right corner
%       bot_r   bottom right corner

rows_im1 = size(im1,1);
cols_im1 = size(im1,2);

up_l = H * [1; 1; 1];
up_l = up_l/up_l(3);

up_r = H * [cols_im1; 1; 1];
up_r = up_r/up_r(3);

bot_l = H * [1; rows_im1; 1];
bot_l = bot_l/bot_l(3);

bot_r = H * [cols_im1; rows_im1; 1];
bot_r = bot_r/bot_r(3);

end