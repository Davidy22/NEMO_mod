function segment_data_auto(a,b,segNum,fps,pxpmm)
%%   COPYRIGHT:  George D. Tsibidis(1) and Nektarios Tavernarakis(2)
%               (1) Institute of Electronic Structure and Laser 
%               (2) Institute of Molecular Biology and Biotechnology 
%               Foundation for Research and Technology-Hellas (FORTH)
%               January 2007
%
%
%segmentation of the animal
% a: starting value for image
% b: last value for image
% segnum: every segment contains segnum points odd number
%
% every segment contains segnum points

global mainOutFolder
global vidHeight
global vidWidth
global PERXY
global CoM
%global folderName
global baseFileName
global pointvalue

baseFileName = 'NEMO_excel';

oldfolder=pwd;

titles=cell(1,2*segNum+5);

for s=1:segNum
    
    titles(1,2*s+4)=cellstr(strcat('x',num2str(s),'[mm]'));
    titles(1,2*s+5)=cellstr(strcat('y',num2str(s),'[mm]'));
end

titles(1,2*segNum+6)=cellstr(strcat('x',num2str(segNum+1),'[mm]'));
titles(1,2* segNum+7)=cellstr(strcat('y',num2str(segNum+1),'[mm]'));
titles(1,1)=cellstr('frame');
titles(1,2)=cellstr('time[sec]');
titles(1,3)=cellstr('stage');
titles(1,4)=cellstr('x_CM[mm]');
titles(1,5)=cellstr('y_CM[mm]');

pointvalue=zeros(b-a+1,2*segNum+5);
pixelcoord=zeros(b-a+1, 5);
%[poffsetfile,PathName]=uigetfile({'*.xls';'*.xlsx'},'Select .xlsx file containing position offset data');
pOffsetfile = 'pOffsetData_interp.xls';
PathName = fullfile(mainOutFolder,'\pOffsetData\');
poffset=xlsread(strcat(PathName,pOffsetfile));
   
for s=a:b;
    
    disp(['Exporting segment data for ' int2str(s)])
    pixelcoord(s,1)=s;    
    pointvalue(s-a+1,1)=round(s);
    pointvalue(s-a+1,2)=s/fps;

    strFrame=['frame' int2str(s)];

    pointvalue(s-a+1,4)=(CoM.(strFrame)(1)-.5*vidWidth)/pxpmm-(poffset(s-a+1,3))/1000;
    pointvalue(s-a+1,5)=(.5*vidHeight-CoM.(strFrame)(2))/pxpmm-(poffset(s-a+1,2))/1000;
        
    cd(oldfolder)
    
    n1=rem(length(PERXY.(strFrame)(:,1)),segNum);
    n2=(length(PERXY.(strFrame)(:,1))-n1)/segNum;

    A=n2*ones(segNum,1);
    
    for i=segNum-n1+1:segNum
        A(i)=A(i)+1;    %%%%%%%%%%decides how to distribute the remainder pixels in PERXY
    end

    F=1;
    pixelcoord(s,2)=round(CoM.(strFrame)(1));
    pixelcoord(s,3)=round(CoM.(strFrame)(2));
    for t=2:segNum;
        if t==2
            O1=PERXY.(strFrame)(1,1);
            O2=PERXY.(strFrame)(1,2);
            pixelcoord(s,4)=O1;
            pixelcoord(s,5)=O2;
            pointvalue(s-a+1,6)=(O1-.5*vidWidth)/pxpmm-(poffset(s-a+1,3))/1000;
            pointvalue(s-a+1,7)=(O2-.5*vidHeight)/pxpmm-(poffset(s-a+1,2))/1000;
        end


        F=F+A(t-1);

        P1=PERXY.(strFrame)(F,1);
        P2=PERXY.(strFrame)(F,2);

        pointvalue(s-a+1,2*t+4)=(P1-.5*vidWidth)/pxpmm-(poffset(s-a+1,3))/1000;
        pointvalue(s-a+1,2*t+5)=(P2-.5*vidHeight)/pxpmm-(poffset(s-a+1,2))/1000;
        pixelcoord(s,2*t+2)=P1;
        pixelcoord(s,2*t+3)=P2;
       
        if t==segNum
            
            Q1=PERXY.(strFrame)(end,1);
            Q2=PERXY.(strFrame)(end,2);

            pointvalue(s-a+1,2*segNum+6)=(Q1-.5*vidWidth)/pxpmm-(poffset(s-a+1,3))/1000;
            pointvalue(s-a+1,2*segNum+7)=(Q2-.5*vidHeight)/pxpmm-(poffset(s-a+1,2))/1000;
            pixelcoord(s,2*segNum+2)=Q1;
            pixelcoord(s,2*segNum+3)=Q2;
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
xlswrite([baseFileName 'pixelcoord.xlsx'], pixelcoord,'Sheet1','A1'); 

cd(oldfolder)
