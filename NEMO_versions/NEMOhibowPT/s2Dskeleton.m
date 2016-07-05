function s2Dskeleton(cutmask,framenum)

%Extracts the skeleton, and prunes the skeleton of spurious branches.
%
%INPUTS:
%   cutmask: binary mask array, cut if an omega-turn detected
%   framenum: frame number
%
%  -Full binarized frames saved in the /DATA_MASTER folder.
%
%OUTPUTS:
%  -Skeleton pixel coordinates, all in order, saved in global variable PERXY.


global PERXY
global vidHeight

skel2dxy=bwmorph(cutmask,'skel','thin');
[skel2dy,skel2dx] = ind2sub(size(skel2dxy),find(skel2dxy));

%%%%longest shortest path algorithm to remove spurious branches
endpts=[];
for i=1:length(skel2dy)                                                     %find endpoints of skeleton

    adjacentcount=0;
    for j=skel2dx(i)-1:skel2dx(i)+1                                         %by checking number of skeleton pixels
        for k=skel2dy(i)-1:skel2dy(i)+1                                     %in 8-connected neighborhood
            if skel2dxy(k,j)==1
                adjacentcount=adjacentcount+1;
            end
        end
    end
    
    if adjacentcount<3                                                  
            
        endpts=[endpts;skel2dx(i),skel2dy(i)];                              %save endpoints in list
    end
end

preNODES1=1:length(skel2dx);
preNODES1=preNODES1';
preNODES2=[skel2dx,skel2dy];                                                %save pixel coords in variable
NODES=[preNODES1,preNODES2];                                                %NODES has form [nodeindex x y]

SEGMENTS=[];
ID=1;
for j1=1:length(skel2dx)-1
    for j2=j1+1:length(skel2dx)
        if abs(skel2dx(j1)-skel2dx(j2))<=1 ...
            && abs(skel2dy(j1)-skel2dy(j2))<=1                              %save adjacent voxels in variable

            SEGMENTS=[SEGMENTS;ID,j1,j2];                                   %SEGMENTS has form [segindex nodeindex1 nodeindex2]
            ID=ID+1;
        end                                                             
    end
end

numnodes=size(endpts,1);
szDtotal=round(factorial(numnodes)/2/factorial(numnodes-2));
Dtotal=zeros(szDtotal,2);
Dindex=1;
listofshortlines=struct;

disp('finding spurious branch..........................')

for i1=1:numnodes-1

    [ID1,unused]=find(ismember(preNODES2,endpts(i1,:),'rows'));

    for i2=i1+1:numnodes                                                    %for each pair of endpoints

        [ID2,unused]=find(ismember(preNODES2,endpts(i2,:),'rows'));         %find their nodeindices

        [dist,path]=dijkstra(NODES,SEGMENTS,ID1,ID2);                       %find shortest path using Djikstra
                                                                            %path is list of nodeindices
        if ~isnan(path)                                                     %dist is Euclidean path length

            fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b')
            fprintf('removed %3d%% branch',round(100*Dindex/szDtotal))

            pathcoord=zeros(length(path),2);
            strDindex=['line' num2str(Dindex)];
            for n1=1:length(path)
                pathcoord(n1,:)=preNODES2(path(n1),:);                      %pathcoord is list of coordinates
            end
            listofshortlines.(strDindex)=pathcoord;                         %save shortest path in variable
            Dtotal(Dindex,1)=Dindex;
            Dtotal(Dindex,2)=dist;                                          %save path length in variable
            Dindex=Dindex+1;
        end
    end
end

fprintf('\n')

Dtotal=Dtotal(~any(isinf(Dtotal),2),:);                                     %sort path lengths to find longest
[unused,d4] = sort(Dtotal(:,2));
Dtotal=flipud(Dtotal(d4,:));

strIndex=['line' num2str(Dtotal(1,1))];
strFrame=['frame' num2str(framenum)];
listofshortlines.(strIndex)(:,2)=vidHeight-listofshortlines.(strIndex)(:,2);
PERXY.(strFrame)=listofshortlines.(strIndex);                               %save longest path coords for export
    