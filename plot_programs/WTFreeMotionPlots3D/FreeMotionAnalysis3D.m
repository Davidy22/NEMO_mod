function FreeMotionAnalysis3D(WormID,GelatinConcentration)

[baseFileName, folderName, FilterIndex]=uigetfile('*.xlsx','Select PixelCoordinates xlsx from NEMO');
[pathstr, name, ext]=fileparts(baseFileName);
ExcelFileName=[folderName,'/',baseFileName];
[N,T,D]=xlsread(ExcelFileName, 'Sheet1');

[baseFileName1, folderName1, FilterIndex1]=uigetfile('*.xlsx','Select Skeletal Coordinates xlsx from NEMO');
[pathstr1, name1, ext1]=fileparts(baseFileName1);
ExcelFileName1=[folderName1,'/',baseFileName1];
[N1,T1,D1]=xlsread(ExcelFileName1, 'Sheet1');

asjLocation3D(WormID,N);

PhototaxisPlots3D(WormID,N1,GelatinConcentration);

end