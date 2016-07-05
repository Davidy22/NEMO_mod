function main(WormID,ONframe,OFFframe,Current,GelatineConcentration)

global mainOutFolder
global outPlotsFolder

outPlotsFolder = fullfile(mainOutFolder,'plots');

if ~exist(outPlotsFolder,'dir')
    mkdir(outPlotsFolder);
end

oldfolder = pwd;            % added
addpath(pwd);               % added
addpath(outPlotsFolder);    % added

% [baseFileName, folderName, FilterIndex]=uigetfile('*.xlsx','Select PixelCoordinates xlsx from NEMO');
% [pathstr, name, ext]=fileparts(baseFileName);
% ExcelFileName=[folderName,'/',baseFileName];
ExcelFileName = fullfile(mainOutFolder,'NEMO','NEMO_excelpixelcoord.xlsx');
[N,T,D]=xlsread(ExcelFileName, 'Sheet1');


asjLocation2D(WormID,N);

SkeletonTrace2D(WormID,N);

frames=size(N,1);

x=N(:,6);
y=1024-N(:,7);

[Gm,Ia]=LaserIntensity2D(WormID,frames,ONframe,OFFframe,Current);

Im=zeros(1,frames);

for k=1:frames
    Im(k)=Gm(y(k), x(k), k);
end
    

[SVC,co,t]=PhototaxisPlots2D(WormID,Im,Ia,ExcelFileName,ONframe);

speed=SVC;
color=co;
time=t;

[meanPre] = meanPreReversal(ONframe,speed,color);
[speedAt] = speedAtReversal(ONframe,speed,color);
[omega] = timeOmega(ONframe,time,color);
[PostOmega] = speedPostOmega(ONframe,time,speed,color);
[timeRev] = timeReversal(ONframe,time,color);
[totalAvoid] = timeAvoidance(ONframe,time,color);
[delay] = delayTime(ONframe,time, color);
[teta] = OmegaAngle(ONframe,color, ExcelFileName);
% teta = 22222;

 
% meanPre = round(meanPre1,2,'significant');
% speedAt = round(speedAt1,2,'significant');
% omega = round(omega1,2,'significant');
% PostOmega = round(PostOmega1,2,'significant');
% timeRev = round(timeRev1,2,'significant');
% totalAvoid = round(totalAvoid1,2,'significant');
% delay = round(delay1,2,'significant');
% teta = round(teta1,2,'significant');

filename = 'FinalOutput.xlsx';

a = exist(filename,'file');

cd(outPlotsFolder)

if a == 0 

ValuesArray = {'Mean speed before reversal','Max speed during reversal','Delay between light and reversal','Time of reversal','Time of omega turn','Total avoidance time(omega and reversal)','Speed after omega turn','OmegaTurn Angle','Gelatine Concentration'; meanPre speedAt delay timeRev omega totalAvoid PostOmega teta GelatineConcentration };

xlswrite(filename,ValuesArray,'Data','A1');

else 

[data,text] = xlsread(filename,'Data');

addData = [meanPre speedAt delay timeRev omega totalAvoid PostOmega teta GelatineConcentration];

 newData = [data;addData];
 
  xlswrite(filename,text,'Data','A1');
  xlswrite(filename,newData,'Data','A2');

end

cd(oldfolder)

% generate the plot of the parameters in function of gelatine concentration

file = xlsread(filename,'Data');

gelC = file(:,9);

c05 = find(gelC==0.5);
c1 = find(gelC==1);
c15 = find(gelC==1.5);
c2 = find(gelC==2);

avgMeanSpeedPre = [];
avgMaxSpeedPre = [];
avgDelay = [];
avgtimeOfRev = [];
avgtimeOmega = [];
avgtotalAvoidance = [];
avgspeedAftOmega = [];
avgomegaAng = [];
concentrations = [];

if (isempty(c05) == 0)
avgMeanSpeedPre = [avgMeanSpeedPre mean(file(c05,1))];
avgMaxSpeedPre = [avgMaxSpeedPre mean(file(c05,2))];
avgDelay = [avgDelay mean(file(c05,3))];
avgtimeOfRev = [avgtimeOfRev mean(file(c05,4))];
avgtimeOmega = [avgtimeOmega mean(file(c05,5))];
avgtotalAvoidance = [avgtotalAvoidance mean(file(c05,6))];
avgspeedAftOmega = [avgspeedAftOmega mean(file(c05,7))];
avgomegaAng = [avgomegaAng mean(file(c05,8))];

concentrations = [concentrations 0.5];
end

if (isempty(c1)==0)
avgMeanSpeedPre = [avgMeanSpeedPre mean(file(c1,1))];
avgMaxSpeedPre = [avgMaxSpeedPre mean(file(c1,2))];
avgDelay = [avgDelay mean(file(c1,3))];
avgtimeOfRev = [avgtimeOfRev mean(file(c1,4))];
avgtimeOmega = [avgtimeOmega mean(file(c1,5))];
avgtotalAvoidance = [avgtotalAvoidance mean(file(c1,6))];
avgspeedAftOmega = [avgspeedAftOmega mean(file(c1,7))];
avgomegaAng = [avgomegaAng mean(file(c1,8))];

concentrations = [concentrations 1];

end

if (isempty(c15)==0)
avgMeanSpeedPre = [avgMeanSpeedPre mean(file(c15,1))];
avgMaxSpeedPre = [avgMaxSpeedPre mean(file(c15,2))];
avgDelay = [avgDelay mean(file(c15,3))];
avgtimeOfRev = [avgtimeOfRev mean(file(c15,4))];
avgtimeOmega = [avgtimeOmega mean(file(c15,5))];
avgtotalAvoidance = [avgtotalAvoidance mean(file(c15,6))];
avgspeedAftOmega = [avgspeedAftOmega mean(file(c15,7))];
avgomegaAng = [avgomegaAng mean(file(c15,8))];

concentrations = [concentrations 1.5];
end

if (isempty(c2)==0)
avgMeanSpeedPre = [avgMeanSpeedPre mean(file(c2,1))];
avgMaxSpeedPre = [avgMaxSpeedPre mean(file(c2,2))];
avgDelay = [avgDelay mean(file(c2,3))];
avgtimeOfRev = [avgtimeOfRev mean(file(c2,4))];
avgtimeOmega = [avgtimeOmega mean(file(c2,5))];
avgtotalAvoidance = [avgtotalAvoidance mean(file(c2,6))];
avgspeedAftOmega = [avgspeedAftOmega mean(file(c2,7))];
avgomegaAng = [avgomegaAng mean(file(c2,8))];

concentrations = [concentrations 2];
end

figure
plot(concentrations,avgMeanSpeedPre,'g',concentrations,avgMaxSpeedPre,'b',concentrations,avgDelay,'k',concentrations,avgtimeOfRev,'y',concentrations,avgtimeOmega,'m',concentrations,avgtotalAvoidance,'r',concentrations,avgspeedAftOmega,'c',concentrations,avgomegaAng,'-ro');
legend('Mean speed pre reversal','Max speed during reversal','Delay until reversal','Duration of reversal','Duration of omega turn','Total avoidance time','Speed after omega','Omega angle');




 end