function [bestMatches, errors] = FindMatches(template, sample, G)
    error=0.1;
    errorThreshold=0.3;
    w=size(template,1);
    hs=size(sample,1);
    ws=size(sample,2);
    G(:,:,2)=G;
    G(:,:,3)=G(:,:,1);
    Mask=G;
    MaskTotal=sum(sum(sum(Mask)));
    fits=zeros((ws-w)*(hs-w),4);
    %sslide window over sample by xShift and yShift
    for xShift = 1:ws-w+1
        for yShift = 1:hs-w+1
            %MatchQuality is the sum of the differences between the sample
            %patch and template squared times the mask
            shiftFit=sum(sum(sum((Mask.*(double(sample(yShift:yShift+w-1,xShift:xShift+w-1,:))-double(template)).^2))))/MaskTotal;
            sampleCrop=[yShift+(w-1)/2 xShift+(w-1)/2];
            fits(xShift+(yShift-1)*(ws-w+1),1)=shiftFit;
            fits(xShift+(yShift-1)*(ws-w+1),2:3)=sampleCrop;
        end
    end
    %sort matches by quality
    fits=sortrows(fits);
    bestMatches=[];
    errors=[];
    while size(bestMatches,1)==0
        %bestMatches are those that have an error less than the min error
        %times 1+error variable and less than the threshold. If no match
        %qualities are less than the threshold, raise the threshold.
        bestMatches=fits(fits(:,1) <= min([(1+error)*fits(1,1) errorThreshold]), 2:3);
        errors=fits(fits(:,1) <= min([(1+error)*fits(1,1) errorThreshold]), 1);
        errorThreshold=1.1*errorThreshold;
    end
end