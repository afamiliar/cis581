function plotResults(edges, borders, morph, stimuli)
%%

switch nargin
    case 1
        %% plot edges
        numIm = length(edges);
        h1 = figure; hold on; 
        for i = 1:length(edges)
            rows = ceil(numIm/3);
            if numIm >= 3
                subplot(rows,3,i); imagesc(edges{i}); colormap(gray);
                axis equal; axis off;
            else
                subplot(rows,numIm,i); imagesc(edges{i}); colormap(gray);
                axis equal; axis off;
            end
        end
        suptitle('Edge detection results')
        waitfor(h1)
        
    case 2
        %% plot borders
        h2 = figure; hold on; 
        for i = 1:length(borders)
            subplot(1,length(borders),i); imagesc(borders{i}); colormap(gray);
            axis equal; axis off;
        end
        suptitle('Border detection results')
        waitfor(h2)

    case 3
        %% plot morph
        h3 = figure; imshow(morph{1})
        title('Final morphing results')
        waitfor(h3)

    case 4
        figure; hold on;
        numStim = length(stimuli);
        for i = 1:numStim
            rows = ceil(numStim/3);
            if numStim >= 3
                subplot(rows,3,i); imshow(stimuli{i})
            else
                subplot(rows,numStim,i); imshow(stimuli{i})
            end
        end
        suptitle('Final result')
end

end