function extract_endpoints(start,finish)

%Reorients each skeleton such that the animal's head coordinate is first, and the animal's tail coordinate is last.
%
%INPUTS:
%   start: first frame number
%   finish: last frame number
%
%  -Skeleton pixel coordinates, all in order, saved in global variable PERXY.
%
%OUTPUTS:
%  -Skeleton pixel coordinates, all in correct order, saved in global variable PERXY.


global PERXY

oldfolder=pwd;
  
for image=start:finish
    
    strFrame=['frame' num2str(image)];
        
    if image==start
        
        figure('Name','Use this plot to help find the coordinates of the head.')
        scatter3(PERXY.(strFrame)(:,1),PERXY.(strFrame)(:,2),PERXY.(strFrame)(:,3))
        xlabel('x')
        ylabel('y')
        zlabel('z')
        axis equal
        view(0,90)
        
        clc
        Xhprev=input('Please input X-coordinate of the head: ');
        Yhprev=input('Please input Y-coordinate of the head: ');
        Zhprev=input('Please input Z-coordinate of the head: ');
        clc

        currentorientscore=(Xhprev-PERXY.(strFrame)(1,1))^2+(Yhprev-PERXY.(strFrame)(1,2))^2+(Zhprev-PERXY.(strFrame)(1,3))^2;
        reverseorientscore=(Xhprev-PERXY.(strFrame)(end,1))^2+(Yhprev-PERXY.(strFrame)(end,2))^2+(Zhprev-PERXY.(strFrame)(end,3))^2;
        
        if currentorientscore>reverseorientscore                            %head-tail dist: as-is vs. inverted
            PERXY.(strFrame)=flipud(PERXY.(strFrame));
        end
        
        Xhprev=PERXY.(strFrame)(1,1);
        Yhprev=PERXY.(strFrame)(1,2);
        Zhprev=PERXY.(strFrame)(1,3);
        
        Xtprev=PERXY.(strFrame)(end,1);
        Ytprev=PERXY.(strFrame)(end,2);
        Ztprev=PERXY.(strFrame)(end,3);
    else
        
        disp(['Orienting head and tail for ' strFrame])
        
        currentorientscore=sqrt((Xhprev-PERXY.(strFrame)(1,1))^2+(Yhprev-PERXY.(strFrame)(1,2))^2+(Zhprev-PERXY.(strFrame)(1,3))^2)+...
            sqrt((Xtprev-PERXY.(strFrame)(end,1))^2+(Ytprev-PERXY.(strFrame)(end,2))^2+(Ztprev-PERXY.(strFrame)(end,3))^2);
        reverseorientscore=sqrt((Xhprev-PERXY.(strFrame)(end,1))^2+(Yhprev-PERXY.(strFrame)(end,2))^2+(Zhprev-PERXY.(strFrame)(end,3))^2)+...
            sqrt((Xtprev-PERXY.(strFrame)(1,1))^2+(Ytprev-PERXY.(strFrame)(1,2))^2+(Ztprev-PERXY.(strFrame)(1,3))^2);
        
%         currentorientscoreh=(Xhprev-PERXY.(strFrame)(1,1))^2+(Yhprev-PERXY.(strFrame)(1,2))^2+(Zhprev-PERXY.(strFrame)(1,3))^2;
%         reverseorientscoreh=(Xhprev-PERXY.(strFrame)(end,1))^2+(Yhprev-PERXY.(strFrame)(end,2))^2+(Zhprev-PERXY.(strFrame)(end,3))^2;
%         currentorientscoret=(Xhprev-PERXY.(strFrame)(1,1))^2+(Yhprev-PERXY.(strFrame)(1,2))^2+(Zhprev-PERXY.(strFrame)(1,3))^2;
%         reverseorientscoret=(Xhprev-PERXY.(strFrame)(end,1))^2+(Yhprev-PERXY.(strFrame)(end,2))^2+(Zhprev-PERXY.(strFrame)(end,3))^2;
        
        if currentorientscore>reverseorientscore                            %head-tail dist: as-is vs. inverted
            PERXY.(strFrame)=flipud(PERXY.(strFrame));
        end
        
        Xhprev=PERXY.(strFrame)(1,1);
        Yhprev=PERXY.(strFrame)(1,2);
        Zhprev=PERXY.(strFrame)(1,3);
        
        Xtprev=PERXY.(strFrame)(end,1);
        Ytprev=PERXY.(strFrame)(end,2);
        Ztprev=PERXY.(strFrame)(end,3);
    end
    close all
end

cd (oldfolder)


