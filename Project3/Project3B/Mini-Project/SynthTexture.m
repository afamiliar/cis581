function synthIm = SynthTexture(sample, w, s)
ht=s(1);
wt=s(2);
G=fspecial('gaussian', w, (w/6.4)^(1/2));
if size(sample,3)==1
    sample(:,:,2)=sample;
    sample(:,:,3)=sample(:,:,1);
end
% size(sample)
randX=round(rand(1)*(size(sample,2)-3)+1);
randY=round(rand(1)*(size(sample,1)-3)+1);
% synthIm=zeros(ht,wt,3,'uint8');
synthIm=zeros(ht,wt,3);
%place sample patch in the middle of synthIm
startY=round((ht-1)/2);
startX=round((wt-1)/2);
%synthIm(startY:startY+2,startX:startX+2,:)=sample(randY:randY+2,randX:randX+2,:);
synthIm(startY:startY+2,startX:startX+2,:)=sample(31:33,3:5,:);
subplot(1,2,1);
imshow(synthIm);
subplot(1,2,2);
height=3;
width=3;
while height<ht&&width<wt
%     height
    height=height+2;
    width=width+2;
    synthImPadded=padarray(synthIm,[(w-1)/2 (w-1)/2]);
    %Find the difference between synthImPadded and dilated synthImPadded
    %to show which pixels are on boundaries
    synthImDilatedPadded=imdilate(rgb2gray(synthImPadded),strel('square',3 ))-rgb2gray(synthImPadded);
    subplot(1,3,1)
    imshow(synthImDilatedPadded);
    subplot(1,3,2)
    %Mark ungenerated pixels on outside of generated synthIm boundary with a 1 in the array 
    [pixelsToSynthesizePadded,validMaskPadded]=FindBoundary(synthImDilatedPadded);
    
    for pixelX = 1:wt
        for pixelY = 1:ht
            %if pixel is ungenerated and on boundary of generated portion,
            %find a match
            if pixelsToSynthesizePadded(pixelY+(w-1)/2,pixelX+(w-1)/2)==1
                padX=pixelX+(w-1)/2;
                padY=pixelY+(w-1)/2;
                %mask = 1 for pixels that have been generated in template
                %portion
                mask=validMaskPadded(pixelY:pixelY+w-1,pixelX:pixelX+w-1);
                %crop template with pixelX, pixelY center
                template=synthImPadded(pixelY:pixelY+w-1,pixelX:pixelX+w-1,:);
                mask=mask.*G;
                maskSum=sum(sum(sum(mask)));
                mask=mask./maskSum;
                %find matches for pixel at pixelX pixelY
                [matches,errors]=FindMatches(template,sample,mask);
                %randomly pick a match from best matches
                match=round(rand(1)*(size(matches,1)-1)+1);     
                matchX=matches(match,2);
                matchY=matches(match,1);
                %assign synthIm pixel to matched pixel from sample
                synthIm(pixelY,pixelX,:)=sample(matchY,matchX,:);
                synthImPadded(padY,padX,:)=sample(matchY,matchX,:);
                validMaskPadded(padY,padX)=1;
            end
        end
    end
end
close all;
end
