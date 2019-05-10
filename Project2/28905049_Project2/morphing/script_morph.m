%% Morphing demo script
%
%   CIS 581
%   Project 2
%   10-2017
%
%   Ariana Familiar
%
%       This shows how to implement morphing between 2 images using either
%       triangulation or thin-plate spline warping, for 4 pre-existing
%       pairs of images:
%           (1) myface.jpg / wonderwoman.jpg
%           (2) me.jpg / blackpanther.jpg
%           (3) lion.jpg / panther.jpg
%           (4) soccerball.jpg / football.jpg
%
%       Options and images must be defined by the user, after which the
%       morphing will run automatically.

clear all; close all; clc;

% ====== define options =======================================

verbose     = 1;      % (1 = plot; 0 = don't)
method      = 'tri';  % ('tri' = triangulation; 'tps' = thin-plate spline)
video       = 0;      % (1 = create AVI video of continuous morph; 0 = don't)
saveResult  = 1;      % save result (1 = yes; 0 = no)

if ~video
    warp_frac     = 0.5;
    dissolve_frac = 0.5;
else
	numFrames     = 60;
	warp_frac     = 0:(1/(numFrames-1)):1;
	dissolve_frac = 0:(1/(numFrames-1)):1;
end

% ====== define images =======================================

pair = 1; % desired pair of pre-existing images (1-4)

if pair == 1
    image1 = 'myface.jpg';            % name of first image
    image2 = 'wonderwoman.jpg';       % name of second image
    picName = 'me2wonderwoman';       % desired name of image output file
    vidName = 'me2wonderwoman';       % desired name of video output file
    load('points_me2wonderwoman.mat')

elseif pair == 2
    image1  = 'me.jpg';                % name of first image
    image2  = 'blackpanther.jpg';      % name of second image
    picName = 'me2blackpanther';       % desired name of image output file
    vidName = 'me2blackpanther';       % desired name of video output file
    load('points_me2blackpanther.mat')
    
elseif pair == 3
    image1  = 'lion.jpg';           % name of first image
    image2  = 'panther.jpg';        % name of second image
    picName = 'lion2panther';       % desired name of image output file
    vidName = 'lion2panther';       % desired name of video output file
    load('points_lion2panther.mat')
    
elseif pair == 4
    image1  = 'soccerball.jpg';          % name of first image
    image2  = 'football.jpg';            % name of second image
    picName = 'soccerball2football';     % desired name of image output file
    vidName = 'soccerball2football';     % desired name of video output file
    load('points_soccerball2football.mat')
    
end


% ====== load image files  =======================================
im1 = imread(image1);
im2 = imread(image2);

% pad images if not same size
[rowsim1, colsim1, ~] = size(im1);
[rowsim2, colsim2, ~] = size(im2);
if rowsim1 == rowsim2 && colsim1 == colsim2
    rows = rowsim1;
    cols = colsim1;
    im1_padded = im1;
    im2_padded = im2;
else
    rows = max(rowsim1, rowsim2); 
    cols = max(colsim1, colsim2);
    im1_padded = padarray(im1, [rows-rowsim1, cols-colsim1], 'replicate', 'post');
    im2_padded = padarray(im2, [rows-rowsim2, cols-colsim2], 'replicate', 'post');
end

% ====== find corresponding points ===============================
if ~exist('im1_pts','var') || ~exist('im2_pts','var')
    [im1_pts, im2_pts] = click_correspondences(im1_padded, im2_padded);
end

if verbose
    % plot corresponding points on original images
    figure;
    subplot(1,2,1); imshow(im1_padded); axis image;
    hold on; plot(im1_pts(:,1), im1_pts(:,2), 'r*');
    title('Corresponding points image 1')
    
    subplot(1,2,2);imshow(im2_padded); axis image;
    hold on; plot(im2_pts(:,1), im2_pts(:,2), 'g*')
    title('Corresponding points image 2')
end

% ====== morph =======================================================

if strcmp(method,'tri')
    
    % ====== run morphing function with triangulation         ============
    % ====== either once or iteratively to generate AVI movie ============

    if ~video
        
        [morphed_im]  = morph_tri(im1_padded, im2_padded, im1_pts, im2_pts, warp_frac, dissolve_frac);
        
        if saveResult
            for i = 1:length(morphed_im)
                if length(morphed_im) == 1
                    outName = [picName '_' method '.jpg'];
                else
                    outName = [picName '_' method '_' num2str(warp_frac(i)) '.jpg'];
                end
                imwrite(morphed_im{i}, outName)
            end
        end
        
        if verbose
            % plot original images and morphed image
            for i = 1:length(morphed_im)
                figure; subplot(1,3,1); imshow(im1);
                        subplot(1,3,2); imshow(morphed_im{i});
                title(['Warping fraction: ' num2str(warp_frac(i))])
                        subplot(1,3,3); imshow(im2);
            end
        end
        
    else
        
        vidName = [vidName '_' method '.avi'];
        genMorphVid(im1_padded, im2_padded, im1_pts, im2_pts, warp_frac, dissolve_frac, method, vidName, numFrames);
        
        if ~verbose
            close all;
        end
        
    end

elseif strcmp(method,'tps')
    
    % ====== run morphing function with TPS         ===============
    % ====== either once or iteratively to generate AVI movie ===============

    if ~video
        im1 = imread(image1);
        im2 = imread(image2);

        morphed_im    = morph_tps(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac);

        if saveResult
            for i = 1:length(morphed_im)
                if length(morphed_im) == 1
                    outName = [picName '_' method '.jpg'];
                else
                    outName = [picName '_' method '_' num2str(warp_frac(i)) '.jpg'];
                end
                imwrite(morphed_im{i}, outName)
            end
        end
        
        if verbose
            % plot original images and morphed image
            for i = 1:length(morphed_im)
                figure; subplot(1,3,1); imshow(im1);
                        subplot(1,3,2); imshow(morphed_im{i});
                title(['Warping fraction: ' num2str(warp_frac(i))])
                        subplot(1,3,3); imshow(im2);
            end
        end
        
    else
        
        vidName = [vidName '_' method '.avi'];
        genMorphVid(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac, method, vidName, numFrames);
    
        if ~verbose
            close all;
        end
        
    end
    
else
    
    error('ERROR: Please specify warping method (tri or tps).')
    
end