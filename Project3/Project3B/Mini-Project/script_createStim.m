%% Stimulus creation demo script
%
%   CIS 581
%   Project 3B
%   Oct/Nov 2017
%
%   Ariana Familiar
%
%       This shows how to generate novel object stimuli based on images of
%       real-world objects using the following operations:
%           1. edge & border detection
%           2. morphing
%           3. texture synthesis
%       A more detailed explanation of these operations can be found in
%       "createStim.m"
%
%       This implementation uses the images located in the directory 
%       "images/".
%
%       Assumes input images are of same size and objects are centered on 
%       a uniform background.
%
%       See user defined options below.
%

clear all; close all; clc;
presentDir = pwd;
addpath(genpath(presentDir));

% ============ user-defined options =================================

numStim = 2;  % number of stimuli to generate
numIm   = 3;  % number of original images to use per stimulus (min. 2)

saveResults = 1;  % (1 = yes; 0 = no)
showResults = 1;  % (1 = yes; 0 = no)
verbose     = 0;  % plot along the way, waits for user 
                  % to close each figure before continuing


% ============ create stimuli =================================

[stimuli, origImages] = createStim(numStim, numIm, verbose);

% save results if specified
if saveResults
    for i = 1:length(stimuli)
        imwrite(stimuli{i}, ['stimulus_' int2str(numIm) 'im_' int2str(numStim) 'stim_' int2str(i) '.jpg'])
    end
    save(['original_images_' int2str(numIm) 'im_' int2str(numStim) 'stim.mat'],'origImages');
end

% plot results if specified
if showResults
    plotResults(stimuli);
end
