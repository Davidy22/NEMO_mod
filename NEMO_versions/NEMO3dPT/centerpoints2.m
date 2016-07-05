function [COM2]=centerpoints2(s,COM2,pxpmm)

%Crops the YZ frame, based on the center point of the previous YZ frame.
%
%INPUTS:
%   s: frame number
%   COM2: coordinate of center point of previous YZ frame.
%   pxpmm: pixels per millimeter
%
%OUTPUTS:
%   COM2: coordinate of center point of current YZ frame.


oldfolder=pwd;
    
cd ('DATA_MASTER/side2')

fileName=['2_' int2str(s) '.png'];

disp(['Calculating centroids for frame ' int2str(s) ' for side2'])

sk2=imread(fileName);
sk=1-sk2;
sk=bwareaopen(sk,round(0.5*pxpmm^1.2));

sk3=bwlabel(sk);
rp=regionprops(sk3,'boundingbox');
centroids=cat(1,rp.BoundingBox);

centerlist=[];
c=ceil(centroids(:,1)+.5*centroids(:,3));
r=floor(centroids(:,2)+.5*centroids(:,4));

size1=length(r(:));
for t=1:size1
    centerlist=[centerlist;[t,r(t),c(t)]];
end

centerbydist=[];

for t=1:size1
   centerbydist=[centerbydist;[centerlist(t,1) centerlist(t,2) centerlist(t,3) ((centerlist(t,2)-COM2(1))^2+(centerlist(t,3)-COM2(2))^2)]];
end

k=find(centerbydist(:,end)==min(centerbydist(:,end)));
center_value=[centerlist(k(1),2), centerlist(k(1),3)];

cd(oldfolder)
outputFolder='DATA/side2';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end
cd(outputFolder)
boxsize=pxpmm;
ROI=imcrop(sk2,[center_value(2)-round(.5*boxsize),center_value(1)-round(.5*boxsize),round(boxsize),round(boxsize)]);

ROI2=1-ROI;
[labeledImage, numberOfBlobs] = bwlabel(ROI2);
blobMeasurements = regionprops(labeledImage, 'area');
allAreas = [blobMeasurements.Area];
[sortedAreas, sortIndexes] = sort(allAreas, 'descend');
biggestBlob = ismember(labeledImage, sortIndexes(1));
ROI = biggestBlob > 0;
ROI2=1-ROI;

imwrite(ROI2,fileName)

COM2=center_value;

cd ..
