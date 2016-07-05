function main(WormID,ONframe,OFFframe,Current)

global mainOutFolder
global outPlotsFolder

outPlotsFolder = fullfile(mainOutFolder,'plots');

if ~exist(outPlotsFolder,'dir')
    mkdir(outPlotsFolder);
end

% [baseFileName, folderName, FilterIndex]=uigetfile('*.xlsx','Select PixelCoordinates xlsx from NEMO');
% [pathstr, name, ext]=fileparts(baseFileName);
% ExcelFileName=[folderName,'/',baseFileName];
ExcelFileName1 = fullfile(mainOutFolder,'NEMO','NEMO_excelpixelcoord.xlsx');
[N,T,D]=xlsread(ExcelFileName, 'Sheet1');


asjLocation2D(WormID,N);

SkeletonTrace2D(WormID,N);

frames=size(N,1);

x=N(:,6);
y=400-N(:,7);

[Gm,Ia]=LaserIntensity2D(WormID,frames,ONframe,OFFframe,Current);

Im=zeros(1,frames);

for k=1:frames
    Im(k)=Gm(y(k), x(k), k);
end
    

PhototaxisPlots2D(WormID,Im,Ia);



 end