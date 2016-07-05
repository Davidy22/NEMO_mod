function main(WormID)

global mainOutFolder
global outPlotsFolder

outPlotsFolder = fullfile(mainOutFolder,'plots');

if ~exist(outPlotsFolder,'dir')
    mkdir(outPlotsFolder);
end

% [baseFileName1, folderName1, FilterIndex1]=uigetfile('*.xlsx','Select PixelCoordinates xlsx from NEMO');
% [pathstr1, name1, ext1]=fileparts(baseFileName1);
% ExcelFileName1=[folderName1,'/',baseFileName1];
ExcelFileName1 = fullfile(mainOutFolder,'NEMO','NEMO_excelpixelcoord.xlsx');
[N1,T1,D1]=xlsread(ExcelFileName1, 'Sheet1');

% [baseFileName, folderName, FilterIndex]=uigetfile('*.xlsx','Select Skeletal Coordinates xlsx from NEMO');
% [pathstr, name, ext]=fileparts(baseFileName);
% ExcelFileName=[folderName,'/',baseFileName];
ExcelFileName = fullfile(mainOutFolder,'NEMO','NEMO_excel.xlsx');
[N,T,D]=xlsread(ExcelFileName, 'Sheet1');


hLocation2D(WormID,N1);

SkeletonTrace2D(WormID,N1);

FreeMotionPlots2D(WormID,N,T);



 end