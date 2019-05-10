%% INITIALIZE
do_trig = 1;
img = (imread('project2_testimg.png'));

% Control points
p1 = [1 1; 257 1; 1 257; 257 257; 129 129];
p2(1) = {[1 1; 257 1; 1 257; 257 257; 129 33]};
p2(2) = {[1 1; 257 1; 1 257; 257 257; 33 129]};
p2(3) = {[1 1; 257 1; 1 257; 257 257; 129 223]};
p2(4) = {[1 1; 257 1; 1 257; 257 257; 223 129]};
p2(5) = {cell2mat(p2(1))};

% Figure 
h = figure(2); clf;
whitebg(h,[0 0 0]);


%% EVAL
if do_trig
    fname = 'Project2_eval_trig.avi';
else
    fname = 'Project2_eval_tps.avi';
end
try
    % VideoWriter based video creation
    h_avi = VideoWriter(fname, 'Uncompressed AVI');
    h_avi.FrameRate = 10;
    h_avi.open();
catch
    % Fallback deprecated avifile based video creation
    h_avi = avifile(fname,'fps',10);
end

% Warp reference images
img_ref = {};
if (do_trig)
    img_ref = [img_ref, morph_tri(img, img, p1, cell2mat(p2(1)), 1, 0)];
    img_ref = [img_ref, morph_tri(img, img, p1, cell2mat(p2(2)), 1, 0)];
    img_ref = [img_ref, morph_tri(img, img, p1, cell2mat(p2(3)), 1, 0)];
    img_ref = [img_ref, morph_tri(img, img, p1, cell2mat(p2(4)), 1, 0)];
    img_ref = [img_ref, img_ref(1)];
else
    img_ref = [img_ref, morph_tps(img, img, p1, cell2mat(p2(1)), 1, 0)];
    img_ref = [img_ref, morph_tps(img, img, p1, cell2mat(p2(2)), 1, 0)];
    img_ref = [img_ref, morph_tps(img, img, p1, cell2mat(p2(3)), 1, 0)];
    img_ref = [img_ref, morph_tps(img, img, p1, cell2mat(p2(4)), 1, 0)];
    img_ref = [img_ref, img_ref(1)];
end  

% Morph iteration
for j=1:4
    img_source = img_ref{j};
    p_source = p2{j};
    img_dest = img_ref{j+1};
    p_dest = p2{j+1};
    
    w=0:0.1:1;
    if (do_trig)
        img_morphed = morph_tri(img_source, img_dest, p_source, p_dest, w, w);
    else
        img_morphed = morph_tps(img_source, img_dest, p_source, p_dest, w, w);
    end
    
    % if image type is double, modify the following line accordingly if necessary
    for i=1:11
        imagesc(img_morphed{i});
        axis image; axis off;drawnow;
        try
            % VideoWriter based video creation
            h_avi.writeVideo(getframe(gcf));
        catch
            % Fallback deprecated avifile based video creation
            h_avi = addframe(h_avi, getframe(gcf));
        end
    end
end
try
    % VideoWriter based video creation
    h_avi.close();
catch
    % Fallback deprecated avifile based video creation
    h_avi = close(h_avi);
end
clear h_avi;