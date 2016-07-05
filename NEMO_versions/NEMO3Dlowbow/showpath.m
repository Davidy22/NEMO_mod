function showpath(varargin)

%Displays the path after NEMOstep 6 is completed.
%
%INPUTS:
%  -Possibly the global variables, 'folderName' and 'univFileName'. 
%   'folderName' must come before 'univFileName'.
%  -Enter 'save' as an input, with or without 'folderName' and 'univFileName'.
%   'save' must come after the global variables.


oldfolder=pwd;

if nargin==0
    message = 'Choose Excel file containing relevant segment information:';
    [filename,pathname,~] = uigetfile('*.xlsx',message);
    saveflag=0;
    
elseif nargin==1
    message = 'Choose Excel file containing relevant segment information:';
    [filename,pathname,~] = uigetfile('*.xlsx',message);
    if strcmpi(varargin{1},'save')==1
        saveflag=1;
    end
    
elseif nargin==2
    pathname=char(strcat(cellstr(varargin{1}),'NEMO\'));
    filename=char(cellstr(varargin{2}));
    saveflag=0;

elseif nargin==3
    pathname=char(strcat(cellstr(varargin{1}),'NEMO\'));
    filename=char(cellstr(varargin{2}));
    if strcmpi(varargin{3},'save')==1
        saveflag=1;
    end
end

if isempty(filename)||isempty(pathname)
    disp('Program aborted. No file chosen.')
else

    cd(pathname)
    
    [info,T,D] = xlsread(strcat([pathname,filename]));                      %loads Excel data

    fps = 1/(info(3,2)-info(2,2));
    frames = size(info,1);
    segs = (size(info,2)-6)/3;
    tstep = 1/fps;
%     phase=T(:,3);

    X = zeros(frames,segs);                                                 %preallocate arrays
    Y = zeros(frames,segs);
    Z = zeros(frames,segs);

    Xcm = info(:,4);
    Ycm = info(:,5);
    Zcm = info(:,6);

    for j = 1:segs
        %sort the columns containing x_j(time) information (including CoM)
        %from Excel file into adjacent columns
        X(:,j) = info(:,(3*j)+4);
        %sort the columns containing y_j(time) information (including CoM)
        %from Excel file into adjacent columns
        Y(:,j) = info(:,(3*j)+5);
        %sort the columns containing y_j(time) information (including CoM)
        %from Excel file into adjacent columns
        Z(:,j) = info(:,(3*j)+6);
    end
    
    
    %%%%%%%%Plotting preparation
    figure(300000)
    delete(300000)
    figure(300000)

    axisminx=floor(2*min(min(X(:,:))))/2;
    axismaxx=ceil(2*max(max(X(:,:))))/2;
    axisminy=floor(2*min(min(Y(:,:))))/2;
    axismaxy=ceil(2*max(max(Y(:,:))))/2;
    axisminz=floor(2*min(min(Z(:,:))))/2;
    axismaxz=ceil(2*max(max(Z(:,:))))/2;

    xrange = [axisminx,axismaxx];
    yrange = [axisminy,axismaxy];
    zrange = [axisminz,axismaxz];

    xlim(xrange); %xlim manual;
    ylim(yrange); %ylim manual;
    zlim(zrange); %zlim manual;
    xlabel('x')
    ylabel('y')
    zlabel('z')
    pause(tstep)

    h1=plot3(X(1,1:segs),Y(1,1:segs),Z(1,1:segs),'-og');
    h2=plot3(Xcm(1),Ycm(1),Zcm(1),'ok');
    h3=plot3(Xcm(1),Ycm(1),Zcm(1),'.k');
    h4=plot3(X(1,1),Y(1,1),Z(1,1),'.c');
    
    if saveflag==1
        if ~exist('EXHIBIT','dir')
            mkdir('EXHIBIT')
        end
        cd('EXHIBIT')
    end

    for i = 1:frames-1
        delete(h1)
        delete(h2)
        h1=plot3(X(i,1:segs),Y(i,1:segs),Z(i,1:segs),'-og');
        hold on
        h2=plot3(Xcm(i),Ycm(i),Zcm(i),'ok');
        h3=plot3(Xcm(i),Ycm(i),Zcm(i),'.k');
        h4=plot3(X(i,1),Y(i,1),Z(i,1),'.c');
        title(int2str(i))
        xlim(xrange)
        ylim(yrange)
        zlim(zrange)
        xlabel('x')
        ylabel('y')
        zlabel('z')
        pause(tstep)

        if saveflag==1
            F=getframe(gca);
            im=F.cdata;
            imwrite(im,['exhibit_' int2str(i-1) '.tif'])
        end
    end
end

cd(oldfolder)