function [vid1, vid2, vid3] = repFrames(video1,video2,video3, repLast)
%% repeat frames of shorter videos to make all three the same length
%
%   INPUT
%       video1    input video #1 (struct.) - output of loadVideo
%       video2    input video #2 (struct.) - output of loadVideo
%       video3    input video #3 (struct.) - output of loadVideo
%       repLast   repeat first or last frame (1 = last, 0 = first)
%
%   OUTPUT
%       vid1    cell array of frames for input video #1 (M x 1, for M frames)
%       vid2    cell array of frames for input video #2 (M x 1, for M frames)
%       vid3    cell array of frames for input video #3 (M x 1, for M frames)


minSz = min([length(video1),length(video2),length(video3)]);
for i = 1:minSz
    vid1{i} = video1(i).cdata;
    vid2{i} = video2(i).cdata;
    vid3{i} = video3(i).cdata;
end

if repLast
    ind1 = length(video1);
    ind2 = length(video2);
    ind3 = length(video3);
else
    ind1 = 1;
    ind2 = 1;
    ind3 = 1;
end

[val, loc] = max([length(video1),length(video2),length(video3)]);
if loc == 1
    diffVid2 = length(video1) - length(video2);
    diffVid3 = length(video1) - length(video3);
    [diff, loc] = max([diffVid2, diffVid3]);
    
    if loc == 1
        video2rep = repmat({video2(ind2).cdata},1,diffVid2);
        video3rep = repmat({video3(ind3).cdata},1,diffVid3+abs(diffVid2-diffVid3));
    else
        video2rep = repmat({video2(ind2).cdata},1,diffVid2+abs(diffVid2-diffVid3));
        video3rep = repmat({video3(ind3).cdata},1,diffVid3);
    end

    video1rep = video1((val-(diff-1)):end);

elseif loc == 2
    diffVid1 = length(video2) - length(video1);
    diffVid3 = length(video2) - length(video3);
    [diff, loc] = max([diffVid1, diffVid3]);

    if loc == 1
        video1rep = repmat({video1(ind1).cdata},1,diffVid1);
        video3rep = repmat({video3(ind3).cdata},1,diffVid3+abs(diffVid1-diffVid3));
    else
        video1rep = repmat({video1(ind1).cdata},1,diffVid1+abs(diffVid1-diffVid3));
        video3rep = repmat({video3(ind3).cdata},1,diffVid3);
    end
    
    video2rep = video2((val-(diff-1)):end);

elseif loc == 3
    diffVid1 = length(video3) - length(video1);
    diffVid2 = length(video3) - length(video2);
    [diff, loc] = max([diffVid1, diffVid2]);

    if loc == 1
        video1rep = repmat({video1(ind1).cdata},1,diffVid1);
        video2rep = repmat({video2(ind2).cdata},1,diffVid2+abs(diffVid1-diffVid2));
    else
        video1rep = repmat({video1(ind1).cdata},1,diffVid1+abs(diffVid1-diffVid2));
        video2rep = repmat({video2(ind2).cdata},1,diffVid2);
    end
    
    video3rep = {video3((val-(diff-1)):end).cdata};
    
end

vid1 = [vid1, video1rep]';
vid2 = [vid2, video2rep]';
vid3 = [vid3, video3rep]';

end