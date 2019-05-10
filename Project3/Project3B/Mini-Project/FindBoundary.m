function [pixelsToSynthesize,validMask] = FindBoundary(synthImDilated)
    ht = size(synthImDilated,1);
    wt = size(synthImDilated,2);
    
    pixelsToSynthesize=zeros(ht,wt);
    %Approach generated portion from top, bottom, left and right and mark
    %pixels on the boundary
    for direction=[1,-1]
        currentX=round(wt/2);
        startDilateX=currentX;
        currentY=1;
        if direction==-1
            currentY=ht;
        end
        while synthImDilated(currentY,currentX)==0
            currentY=currentY+direction;
        end
        if direction==1
            cornerY1=currentY;
        end
        cornerY2=currentY;
        pixelsToSynthesize(currentY,currentX)=1;

        while currentX<wt+1
            if synthImDilated(currentY,currentX)==0
                break
            end
            pixelsToSynthesize(currentY,currentX)=1;
            currentX=currentX+1;
        end
        currentX=startDilateX;
        while currentX>0
            if synthImDilated(currentY,currentX)==0
                break
            end
            pixelsToSynthesize(currentY,currentX)=1;
            currentX=currentX-1;
        end
    end
    
    for direction=[1,-1]
        currentY=round(ht/2);
        startDilateY=currentY;
        currentX=1;
        if direction==-1
            currentX=wt;
        end
        while synthImDilated(currentY,currentX)==0
            currentX=currentX+direction;
        end
        if direction==1
            cornerX1=currentX;
        end
        cornerX2=currentX;
        pixelsToSynthesize(currentY,currentX)=1;

        while currentY<wt+1
            if synthImDilated(currentY,currentX)==0
                break
            end
            pixelsToSynthesize(currentY,currentX)=1;
            currentY=currentY+1;
        end
        currentY=startDilateY;
        while currentY>0
            if synthImDilated(currentY,currentX)==0
                break
            end
            pixelsToSynthesize(currentY,currentX)=1;
            currentY=currentY-1;
        end
    end
    %mark pixels within boundary with 1, since they have already been
    %matched
    validMask=zeros(ht,wt);
    validMask(cornerY1+1:cornerY2-1,cornerX1+1:cornerX2-1)=1;
    imshow(validMask);
end

