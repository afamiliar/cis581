function video = loadVideo(vid)
%% load video file into structure
%
%   INPUT
%       vid     name of video file to be loaded (e.g. 'Video1.mp4')
%
%   OUTPUT
%       video   structure of input video (one row per frame)

video = struct('cdata',zeros(vid.Height,vid.Width,3,'uint8'),...
               'colormap',[]);

k = 1;
while hasFrame(vid)
    video(k).cdata = readFrame(vid);
    k = k+1;
end

end