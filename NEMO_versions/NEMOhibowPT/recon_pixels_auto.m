function recon_pixelsmod(start,finish,pxpmm)

%Constructs a 2-D pixel image, extracts the skeleton, and prunes the skeleton of spurious branches.
%
%INPUTS:
%   start: first frame number
%   finish: last frame number
%   pxpmm: pixels per millimeter
%
%  -Full binarized frames saved in the mainOutFolder/binarized_frames folder.
%
%OUTPUTS:
%  -Skeleton pixel coordinates, all in order, saved in global variable PERXY.
%  -Center of mass pixel coordinates, saved in global variable CoM.

global mainOutFolder    % ADDED
global CoM
global vidHeight        % NECESSARY HERE
global vidWidth

testFrame = imread(fullfile(mainOutFolder,'\binarized_frames\frame1.tif')); % ADDED
[vidHeight, vidWidth, ~] = size(testFrame);           % ADDED

oldfolder=pwd;


for s=start:finish
    
    strFrame=['frame' int2str(s)];  % do not change
    fprintf(['Extracting skeleton for ' strFrame '.\n'])

    img=imread(fullfile(mainOutFolder,['\binarized_frames\' strFrame '.tif']));   % changed
    %img=im2double(rgb2ycbcr(img));     %% only for .png files
    img=im2double(img);                 %% ADDED
    img=img(:,:,1);
    img_mean=mean(mean(img));
    img_std=std2(img);
    bowimage=im2bw(img,img_mean-1*img_std);

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
    
    [ycm,xcm]=find(binarymask==1);
    CoM.(strFrame)=[mean(xcm), mean(ycm)];
    
    cutmask=m2Dmask(binarymask,pxpmm,s);
    s2Dskeleton(cutmask,s)
end

