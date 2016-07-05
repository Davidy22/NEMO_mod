function COM=centerpoints(a,b,COM,calibration)
%
%   COPYRIGHT:  George D. Tsibidis(1) and Nektarios Tavernarakis(2)
%               (1) Institute of Electronic Structure and Laser 
%               (2) Institute of Molecular Biology and Biotechnology 
%               Foundation for Research and Technology-Hellas (FORTH)
%               January 2007
%
%
% a: starting s
% b: ending s
% A: coordinates of head  76 139    
% B: coordinates of tail  170 195    
%A-->A+1
%B-->B+1

global COMlist

premo;
for s=a:b
    
    cd ('DATA_MASTER')
 
    disp(['Calculating centroids for frame ' int2str(s)])

    sk2=imread([int2str(s) '.png']);
    sk=1-sk2;
    sk=bwareaopen(sk,round(0.8*calibration^1.01));
    
%     imshow(sk)
%     uiwait

    numb=[s;length(find(sk==1))];

    sk3=bwlabel(sk);
    rp=regionprops(sk3,'centroid');
    centroids=cat(1,rp.Centroid);
    centroids=round(centroids);
    
    M=[];
    c=centroids(:,1);
    r=centroids(:,2);
    
    size1=length(r(:));
    for t=1:length(r(:))
      M=[M;[t,r(t),c(t)]];   
    end
    
   START=[];
   
   for t=1:size1
   
       START=[START;[M(t,1) M(t,2) M(t,3) ((M(t,2)-COM(1))^2+(M(t,3)-COM(2))^2)]];
   end
   
   k=find(START(:,end)==min(START(:,end)));
   START_value=[M(k(1),2), M(k(1),3)];
   
   cd(oldfolder)
   cd('DATA')
   boxsize=calibration;
   ROI=imcrop(sk2,[START_value(2)-round(.75*boxsize),START_value(1)-round(.75*boxsize),round(boxsize*1.5),round(boxsize*1.5)]);
   filename=[int2str(s) '.png'];
   
        ROI2=1-ROI;
        [labeledImage, numberOfBlobs] = bwlabel(ROI2);
        blobMeasurements = regionprops(labeledImage, 'area');
        allAreas = [blobMeasurements.Area];
        [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
        biggestBlob = ismember(labeledImage, sortIndexes(1));
        ROI = biggestBlob > 0;
        ROI2=1-ROI;
   
   imwrite(ROI2,filename)
   
   COMlist=[COMlist;START_value];

   M(k(1),:)=[];     %%%%% the points which are the ends of tails that should be removed
   COM=[];
   COM=START_value;

 cd ..
end
