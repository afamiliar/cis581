function genMorphVid(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac, type, vidName, numFrames)
%% Generate video of face morph
%
%   INPUT
%       im1     first image
%       im2     second image
%       im1_pts corresponding points for first image
%       im2_pts corresponding points for second image
%       

if strcmp('tri', type)
    morphed_im = morph_tri(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac);
elseif strcmp('tps', type)
    morphed_im = morph_tps(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac);
end

close all;
figure;
vid = VideoWriter(vidName);
vid.FrameRate = 15;
open(vid);

for i = 1:length(morphed_im)
    
    clc
    disp(['Frame: ' int2str(i)])
    disp(['   of ' int2str(numFrames)])
    
    imshow(morphed_im{i}); axis image; axis off;
    writeVideo(vid, getframe(gcf));
    
end

close(vid);
clc

end