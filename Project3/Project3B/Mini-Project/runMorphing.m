function [morph, permInd] = runMorphing(images, borders, verbose)
%% iteratively run moprhing 

numIm = length(images);

% generate random order of images
permInd = randperm(numIm,numIm);

for i = 1:numIm-1

    % set images for this iteration
    if i == 1   % morph between two images
        im1  = im2double(borders{permInd(1)});
        im2  = im2double(borders{permInd(2)});
        
        img1 = ~imbinarize(rgb2gray(images{permInd(1)}),.9);
        img2 = ~imbinarize(rgb2gray(images{permInd(2)}),.9);

    else        % morph between current morph & new image
        im1  = findBorder(cannyEdge(morph{1}), morph{1});
        im2  = im2double(borders{permInd(i+1)});
        
        img1 = morph{1}; % ~imbinarize(rgb2gray(morph{1}),.9);
        img2 = ~imbinarize(rgb2gray(images{permInd(i+1)}),.9);

    end
    numPoints = 50; % # of correspnding points per half of image

    % find corresponding points using border results
    [im1_pts, im2_pts] = findPts(im1, im2, numPoints);

    if verbose
        h = figure;
        subplot(1,2,1); imshow(img1); axis image;
        hold on; plot(im1_pts(:,1), im1_pts(:,2), 'r*');
        title('Image 1')
        subplot(1,2,2);imshow(img2); axis image;
        hold on; plot(im2_pts(:,1), im2_pts(:,2), 'g*')
        title('Image 2')
        suptitle('Corresponding points for morphing')

        waitfor(h)
    end

    % morph images
    if sum(img1(:)) > sum(img2(:))
        [morph]  = morph_tps(img1, img2, im1_pts, im2_pts, .5, 0);
    else
        [morph]  = morph_tps(img1, img2, im1_pts, im2_pts, .5, 1);
    end
    
    if verbose
        h = figure;
            subplot(1,3,1); imshow(img1);
            subplot(1,3,2); imshow(morph{1}); title('morph');
            subplot(1,3,3); imshow(img2);
        suptitle(['Morphing results iteration ' int2str(i)])
        
        waitfor(h)
    end
end

end
