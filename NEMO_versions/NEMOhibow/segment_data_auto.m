function segment_data_auto(a,b,segnum,fps,pxpmm)

%Splits the skeleton into a universal number of segments, and converts from pixels to millimeter units.
%
%INPUTS:
%   start: first frame number
%   finish: last frame number
%   segnum: number of segments, number of nodes will be segments+1
%   fps: frames per second
%   pxpmm: pixels per millimeter
%
%  -Skeleton pixel coordinates, all in correct order, saved in global variable PERXY.
%  -Center of mass pixel coordinates, saved in global variable CoM.
%  - sheet containing stage offsets, in format [frame x y], with first
%   line corresponding to input variable 'start'.
%
%OUTPUTS:
%  -Excel file containing [frame, time, phase, XY_CoM, XY_segments].
%   XY_segments are in order from head to tail. Phase is empty.

global mainOutFolder            % ADDED
global vidHeight
global vidWidth
global PERXY
global CoM
% global folderName
global baseFileName
global pointvalue

baseFileName = 'NEMO_excel';    % ADDED

oldfolder=pwd;

titles=cell(1,2*segnum+5);

for s=1:segnum
    
    titles(1,2*s+4)=cellstr(strcat('x',num2str(s),'[mm]'));
    titles(1,2*s+5)=cellstr(strcat('y',num2str(s),'[mm]'));
end

titles(1,2*segnum+6)=cellstr(strcat('x',num2str(segnum+1),'[mm]'));
titles(1,2*segnum+7)=cellstr(strcat('y',num2str(segnum+1),'[mm]'));
titles(1,1)=cellstr('frame');
titles(1,2)=cellstr('time[sec]');
titles(1,3)=cellstr('stage');
titles(1,4)=cellstr('x_CM[mm]');
titles(1,5)=cellstr('y_CM[mm]');

pointvalue=zeros(b-a+1,2*segnum+5);
                                %%%%%%%% give it the created interped excel
%[poffsetfile,PathName]=uigetfile({'*.xls';'*.xlsx'},'Select .xlsx file containing position offset data');
pOffsetfile = 'pOffsetData_interp.xls';
PathName = fullfile(mainOutFolder,'\pOffsetData\');
poffset=xlsread(strcat(PathName,pOffsetfile));
   
for s=a:b;
    
    disp(['Exporting segment data for ' int2str(s)])
        
    pointvalue(s-a+1,1)=round(s);
    pointvalue(s-a+1,2)=s/fps;

    strFrame=['frame' int2str(s)];

    pointvalue(s-a+1,4)=(CoM.(strFrame)(1)-.5*vidWidth)/pxpmm-(poffset(s-a+1,3))/1000;
    pointvalue(s-a+1,5)=(.5*vidHeight-CoM.(strFrame)(2))/pxpmm-(poffset(s-a+1,2))/1000;
        
    cd(oldfolder)
    
    n1=rem(length(PERXY.(strFrame)),segnum);
    n2=(length(PERXY.(strFrame))-n1)/segnum;

    A=n2*ones(segnum,1);
    
    for i=segnum-n1+1:segnum
        A(i)=A(i)+1;    %%%%%%%%%%decides how to distribute the remainder pixels in PERXY
    end

    F=1;

    for t=2:segnum
        if t==2
            O1=PERXY.(strFrame)(1,1);
            O2=PERXY.(strFrame)(1,2);

            pointvalue(s-a+1,6)=(O1-.5*vidWidth)/pxpmm-(poffset(s-a+1,3))/1000;
            pointvalue(s-a+1,7)=(O2-.5*vidHeight)/pxpmm-(poffset(s-a+1,2))/1000;
        end

        F=F+A(t-1);

        P1=PERXY.(strFrame)(F,1);
        P2=PERXY.(strFrame)(F,2);
            
        pointvalue(s-a+1,2*t+4)=(P1-.5*vidWidth)/pxpmm-(poffset(s-a+1,3))/1000;
        pointvalue(s-a+1,2*t+5)=(P2-.5*vidHeight)/pxpmm-(poffset(s-a+1,2))/1000;

        if t==segnum
            
            Q1=PERXY.(strFrame)(end,1);
            Q2=PERXY.(strFrame)(end,2);

            pointvalue(s-a+1,2*segnum+6)=(Q1-.5*vidWidth)/pxpmm-(poffset(s-a+1,3))/1000;
            pointvalue(s-a+1,2*segnum+7)=(Q2-.5*vidHeight)/pxpmm-(poffset(s-a+1,2))/1000;
        end
    end
end

cd(mainOutFolder)
if ~exist('NEMO','dir')
    mkdir('NEMO')
end
cd('NEMO') 

xlswrite([baseFileName '.xlsx'],titles,'Sheet1','A1')
xlswrite([baseFileName '.xlsx'],pointvalue,'Sheet1','A2')

cd(oldfolder)
