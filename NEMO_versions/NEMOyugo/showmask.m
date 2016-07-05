function showmask(s,pxpmm)

%Displays mask image after NEMOstep 1 is completed.
%
%INPUTS:
%   S: frame of mask to be displayed


global NEMOstep

oldfolder=pwd;

if isempty(NEMOstep)==1
    disp('ERROR: NEMOstep is unassigned.')
end

if NEMOstep>1
    
    bowimage=imread(['DATA_MASTER/' int2str(s) '.png']); %black on white

    %Invert binary image
    wobimage=1-bowimage; %white on black

    %Remove small objects from binary image
    [labeledImage, numberOfBlobs] = bwlabel(wobimage);
    blobMeasurements = regionprops(labeledImage, 'area');
    allAreas = [blobMeasurements.Area];
    [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
    labeledBlob = ismember(labeledImage, sortIndexes(1));
    biggestBlob = labeledBlob > 0;
    binaryBlob=im2double(biggestBlob);   

    SE=strel('disk',2);
    erodedimage=imerode(binaryBlob,SE);
    dilatedimage=imdilate(erodedimage,SE);
    openedimage = bwmorph(dilatedimage,'open',Inf);
    binarymask=im2double(openedimage);
    
    cutmask=m2Dmask(binarymask,pxpmm,s);
    
    if ishandle(100000+s)
        close(100000+s)
    end
    figure(100000+s)
    
    imshow(cutmask)
else
    disp('ERROR: Have yet to extract mask. Please run NEMOanalysis further before attempting to display mask.')
    disp(['NEMOstep=' int2str(NEMOstep)])
end

