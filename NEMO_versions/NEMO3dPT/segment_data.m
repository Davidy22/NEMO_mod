function segment_data(start,finish,segnum,fps,pxpmm)

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
%  -Pixel offsets, saved in global variables COMlistxz, COMlistyz, COMlistxy.
%  -Excel sheet containing stage offsets, in format [frame x y z], with first
%   line corresponding to input variable 'start'.
%
%OUTPUTS:
%  -Excel file containing [frame, time, phase, XYZ_CoM, XYZ_segments].
%   XYZ_segments are in order from head to tail.


global COMlistxz
global COMlistyz
global COMlistxy
global vidsz
global folderName
global univFileName
global PERXY
global CoM

oldfolder=pwd;

a=start;
b=finish;

titles=cell(1,2*segnum+5);

for s=1:segnum
    titles(1,3*s+4)=cellstr(strcat('x',num2str(s),'[mm]'));                 %Setting up Excel sheet titles
    titles(1,3*s+5)=cellstr(strcat('y',num2str(s),'[mm]'));
    titles(1,3*s+6)=cellstr(strcat('z',num2str(s),'[mm]'));
end

titles(1,3*segnum+7)=cellstr(strcat('x',num2str(segnum+1),'[mm]'));
titles(1,3*segnum+8)=cellstr(strcat('y',num2str(segnum+1),'[mm]'));
titles(1,3*segnum+9)=cellstr(strcat('z',num2str(segnum+1),'[mm]'));
titles(1,1)=cellstr('frame');
titles(1,2)=cellstr('time[sec]');
titles(1,3)=cellstr('stage');
titles(1,4)=cellstr('x_CM[mm]');
titles(1,5)=cellstr('y_CM[mm]');
titles(1,6)=cellstr('z_CM[mm]');

% stage=cell(b-a+1,1);
pointvalue=zeros(b-a+1,3*segnum+6);                                         %Preallocating table of values
pixelcoord=zeros(b-a+1,7);
prepointvalue=zeros(b-a+1,3*segnum+6);

ROIoffsetX=mean([COMlistxz(:,2)';COMlistxy(:,2)'])-round(.5*vidsz);         %Importing pixel offsets
% ROIoffsetY=vidsz-COMlistxy(:,1)';
ROIoffsetY=mean([COMlistyz(:,2)';vidsz-COMlistxy(:,1)'])-round(.5*vidsz);
% ROIoffsetZ=vidsz-COMlistxz(:,1)';
ROIoffsetZ=mean([vidsz-COMlistxz(:,1)';vidsz-COMlistyz(:,1)'])-round(.5*vidsz);
% ROIoffsetX=zeros(b-a+1);
% ROIoffsetY=zeros(b-a+1);
% ROIoffsetZ=zeros(b-a+1);

cd(folderName)
[poffsetfile,PathName]=uigetfile({'*.xls';'*.xlsx'},'Select .xlsx file containing position offset data');
poffset=xlsread(strcat(PathName,poffsetfile));
STAGEoffsetX=poffset(:,2);                                                  %Importing stage offsets
STAGEoffsetY=poffset(:,3);
STAGEoffsetZ=poffset(:,4);
   
for s=a:b;
    
    fieldname=['frame' int2str(s)];
    
    disp(['Exporting segment data for ' int2str(s)])
    pixelcoord(s,1)=s;    
    pointvalue(s-a+1,1)=round(s);
    pointvalue(s-a+1,2)=s/fps;

    CoMcalib.(fieldname)(1)=(CoM.(fieldname)(1)+ROIoffsetX(s-a+1))/pxpmm+(STAGEoffsetX(s-a+1))/10000;
    CoMcalib.(fieldname)(2)=(CoM.(fieldname)(2)+ROIoffsetY(s-a+1))/pxpmm+(STAGEoffsetY(s-a+1))/10000;
    CoMcalib.(fieldname)(3)=(CoM.(fieldname)(3)+ROIoffsetZ(s-a+1))/pxpmm+(STAGEoffsetZ(s-a+1))/10000;

    prepointvalue(s-a+1,4)=CoMcalib.(fieldname)(1);
    prepointvalue(s-a+1,5)=CoMcalib.(fieldname)(2);
    prepointvalue(s-a+1,6)=CoMcalib.(fieldname)(3);
    
    n1=rem(length(PERXY.(fieldname)(:,1)),segnum);
    n2=(length(PERXY.(fieldname)(:,1))-n1)/segnum;

    A=n2*ones(segnum,1);
    for i=segnum-n1+1:segnum
        A(i)=A(i)+1;
    end

    F=1;
    for t=2:segnum;
        
        if t==2

            O1=PERXY.(fieldname)(1,1);
            O2=PERXY.(fieldname)(1,2);
            O3=PERXY.(fieldname)(1,3);

            prepointvalue(s-a+1,7)=(O1+ROIoffsetX(s-a+1))/pxpmm+(STAGEoffsetX(s-a+1))/10000;
            prepointvalue(s-a+1,8)=(O2+ROIoffsetY(s-a+1))/pxpmm+(STAGEoffsetY(s-a+1))/10000;
            prepointvalue(s-a+1,9)=(O3+ROIoffsetZ(s-a+1))/pxpmm+(STAGEoffsetZ(s-a+1))/10000;
        end

        F=F+A(t-1);
       
            
        P1=PERXY.(fieldname)(F,1);
        P2=PERXY.(fieldname)(F,2);
        P3=PERXY.(fieldname)(F,3);
        if t==3
            pixelcoord(s,2)=P1;
            pixelcoord(s,3)=P2;
            pixelcoord(s,4)=P3;
        end
        if t==4
            pixelcoord(s,5)=P1;
            pixelcoord(s,6)=P2;
            pixelcoord(s,7)=P3;
        end
        prepointvalue(s-a+1,3*t+4)=(P1+ROIoffsetX(s-a+1))/pxpmm+(STAGEoffsetX(s-a+1))/10000;
        prepointvalue(s-a+1,3*t+5)=(P2+ROIoffsetY(s-a+1))/pxpmm+(STAGEoffsetY(s-a+1))/10000;
        prepointvalue(s-a+1,3*t+6)=(P3+ROIoffsetZ(s-a+1))/pxpmm+(STAGEoffsetZ(s-a+1))/10000;

        if t==segnum
            
            Q1=PERXY.(fieldname)(end,1);
            Q2=PERXY.(fieldname)(end,2);
            Q3=PERXY.(fieldname)(end,3);

            prepointvalue(s-a+1,3*segnum+7)=(Q1+ROIoffsetX(s-a+1))/pxpmm+(STAGEoffsetX(s-a+1))/10000;
            prepointvalue(s-a+1,3*segnum+8)=(Q2+ROIoffsetY(s-a+1))/pxpmm+(STAGEoffsetY(s-a+1))/10000;
            prepointvalue(s-a+1,3*segnum+9)=(Q3+ROIoffsetZ(s-a+1))/pxpmm+(STAGEoffsetZ(s-a+1))/10000;
        end
    end
end

for j=4:3*segnum+9
    pointvalue(:,j)=smooth(prepointvalue(:,j),5,'sgolay',1);                %Savitzky-Golay fit, order 1, windowsize 5
%     pointvalue(:,j)=prepointvalue(:,j);
end

if ~exist('NEMO','dir')
    mkdir('NEMO')
end
cd('NEMO')

try
    xlswrite([univFileName '.xlsx'],titles,'Sheet1','A1');
    xlswrite([univFileName '.xlsx'],pointvalue,'Sheet1','A2');
    xlswrite([univFileName 'pixelcoord.xlsx'], pixelcoord,'Sheet1','A1');
catch
    fprintf('\a')
    uiwait(msgbox('ERROR: Please close the Excel sheet before attempting to write to it.'))
    xlswrite([univFileName '.xlsx'],titles,'Sheet1','A1');
    xlswrite([univFileName '.xlsx'],pointvalue,'Sheet1','A2');
end

cd (oldfolder)

save('done.txt')
