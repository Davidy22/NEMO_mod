function recon_voxels(start,finish)

%Constructs a 3-D voxel image from three 2-D images, extracts the skeleton, and prunes the skeleton of spurious branches.
%
%INPUTS:
%   start: first frame number
%   finish: last frame number
%
%  -Individual cropped frames saved in in their respective subfolders under
%   the /DATA folder.
%
%OUTPUTS:
%  -Skeleton pixel coordinates, all in order, saved in global variable PERXY.
%  -Center of mass pixel coordinates, saved in global variable CoM.


global COORDS
global CoM
%%%%%%%%%%%%%%%%%avwrmmass=

oldfolder=pwd;

for s=start:finish
     
    strFrame=['frame' num2str(s)];
    disp(strFrame)
    
    
    %%%%constructing the voxel image and extracting the skeleton
    imxy = imread(['DATA_MASTER/top/3_' int2str(s) '.png']);   %load images
    imxz = imread(['DATA_MASTER/side1/1_' int2str(s) '.png']);
    imyz = imread(['DATA_MASTER/side2/2_' int2str(s) '.png']);
    
    imxy = flipud(imxy);                                                    %invert up and down orientation
    imxz = flipud(imxz);
    imyz = flipud(imyz);
    imyz= fliplr(imyz);
    imxy = 1 - im2bw(imxy,graythresh(imxy));                                %invert black with white
    imxz = 1 - im2bw(imxz,graythresh(imxz));
    imyz = 1 - im2bw(imyz,graythresh(imyz));
    imxy=bwareaopen(imxy,round(0.5*pxpmm^1.2));
    imxz=bwareaopen(imxz,round(0.5*pxpmm^1.2));
    imyz=bwareaopen(imyz,round(0.5*pxpmm^1.2));
    imxy3dproj = repmat(imxy,1,1,length(imxz(:,1)));                        %form xy block
    imxy3dproj = permute(imxz3dproj,[2,1,3]); 
    imxz3dproj = repmat(imxz,1,1,length(imyz(1,:)));                        %form xz block
    imxz3dproj = permute(imxz3dproj,[2,3,1]);                               %orient xz block
    imyz3dproj = repmat(imyz,1,1,length(imxz(1,:)));                        %form yz block
    imyz3dproj = permute(imyz3dproj,[3,2,1]);                               %orient yz block
    im3dxyz = imxy3dproj & imxz3dproj & imyz3dproj;                         %intersect blocks for voxel image
    
    [I, J, K]=ind2sub(size(im3dxyz), find(im3dxyz));
    plot3(I, J, K, 'k.', 'MarkerSize',30, 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'r')
    
    CC=bwconncomp(im3dxyz);
    volumemeasurements=regionprops(CC,'Area')
    
    if(%%condition for joined worm volumes)
    else
    COORDS.(strFrame)=regionprops(CC,'Centroid');
    end
     
     [im3dy,im3dx,im3dz] = ind2sub(size(im3dxyz),find(im3dxyz));
%     CoM.(strFrame)=[mean(im3dx),mean(im3dy),mean(im3dz)];                   %save centroids of voxel image for export
%     
%     skel3dxyz=s3Dskeleton(im3dxyz);                              
%     [skel3dy,skel3dx,skel3dz] = ind2sub(size(skel3dxyz),find(skel3dxyz));   %26-connected
%     
%     
%     %%%%longest shortest path algorithm to remove spurious branches
%     endpts=[];
%     for i=1:length(skel3dy)                                                 %find endpoints of skeleton
%                                                                             
%         adjacentcount=0;
%         for j=skel3dx(i)-1:skel3dx(i)+1                                     %by checking number of skeleton voxels
%             for k=skel3dy(i)-1:skel3dy(i)+1                                 %in 26-connected neighborhood
%                 for l=skel3dz(i)-1:skel3dz(i)+1
%                     if skel3dxyz(k,j,l)==1
%                         adjacentcount=adjacentcount+1;
%                     end
%                 end
%             end
%         end
%         
%         if adjacentcount<3                                                  
%             
%             endpts=[endpts;skel3dx(i),skel3dy(i),skel3dz(i)];               %save endpoints in list
%         end
%     end
%     
%     preNODES1=1:length(skel3dx);
%     preNODES1=preNODES1';
%     preNODES2=[skel3dx,skel3dy,skel3dz];                                    %save voxel coords in variable
%     NODES=[preNODES1,preNODES2];                                            %NODES has form [nodeindex x y z]
%     
%     SEGMENTS=[];
%     ID=1;
%     for j1=1:length(skel3dx)-1
%         for j2=j1+1:length(skel3dx)
%             if abs(skel3dx(j1)-skel3dx(j2))<=1 ...
%                 && abs(skel3dy(j1)-skel3dy(j2))<=1 ...
%                 && abs(skel3dz(j1)-skel3dz(j2))<=1                          %save adjacent voxels in variable
%             
%                 SEGMENTS=[SEGMENTS;ID,j1,j2];                               %SEGMENTS has form [segindex nodeindex1 nodeindex2]
%                 ID=ID+1;
%             end                                                             
%         end
%     end
%     
%     numnodes=size(endpts,1);
%     szDtotal=round(factorial(numnodes)/2/factorial(numnodes-2));
%     Dtotal=zeros(szDtotal,2);
%     Dindex=1;
%     listofshortlines=struct;
%     
%     disp('finding spurious branch..........................')
%     
%     for i1=1:numnodes-1
%         
%         [ID1,unused]=find(ismember(preNODES2,endpts(i1,:),'rows'));
%         
%         for i2=i1+1:numnodes                                                %for each pair of endpoints
%             
%             [ID2,unused]=find(ismember(preNODES2,endpts(i2,:),'rows'));     %find their nodeindices
%             
%             [dist,path]=dijkstra(NODES,SEGMENTS,ID1,ID2);                   %find shortest path using Djikstra
%                                                                             %path is list of nodeindices
%             if ~isnan(path)                                                 %dist is Euclidean path length
%                 
%                 fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b')
%                 fprintf('removed %3d%% branch',round(100*Dindex/szDtotal))
%                 
%                 pathcoord=zeros(length(path),3);
%                 strDindex=['line' num2str(Dindex)];
%                 for n1=1:length(path)
%                     pathcoord(n1,:)=preNODES2(path(n1),:);                  %pathcoord is list of coordinates
%                 end
%                 listofshortlines.(strDindex)=pathcoord;                     %save shortest path in variable
%                 Dtotal(Dindex,1)=Dindex;
%                 Dtotal(Dindex,2)=dist;                                      %save path length in variable
%                 Dindex=Dindex+1;
%             end
%         end
%     end
%     
%     fprintf('\n')
%     
%     Dtotal=Dtotal(~any(isinf(Dtotal),2),:);                                 %sort path lengths to find longest
%     [unused,d4] = sort(Dtotal(:,2));
%     Dtotal=flipud(Dtotal(d4,:));
%     
%     strIndex=['line' num2str(Dtotal(1,1))];
%     PERXY.(strFrame)=listofshortlines.(strIndex);                           %save longest path coords for export
%     
end

cd(oldfolder)