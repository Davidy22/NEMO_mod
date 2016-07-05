[baseFileName, folderName, FilterIndex]=uigetfile('*.xlsx','Select Skeletal Coordinates xlsx from NEMO');
[pathstr, name, ext]=fileparts(baseFileName);
ExcelFileName=[folderName,'/',baseFileName];
[N,T,D]=xlsread(ExcelFileName, 'Sheet1');


frames=size(N,1);
colwidth = numel(N(1,:));
segments = (colwidth-5)/2;
tau=N(2,2)-N(1,2);
fps=round(1/tau);


X = zeros(frames,segments);
Y = zeros(frames,segments);

for j = 1:segments+1
    X(:,j) = N(:,(2*j)+2);
    Y(:,j) = N(:,(2*j)+3);
end
degreesTable=zeros(frames,1);
for k=1:frames
    degreeSin=sin((Y(k,2)-Y(k,segments-2))/(X(k,2)-X(k,segments-2))); 
    degreesTable(k)=degreeSin*57.2958;
end
axis([1 frames -90 90]);
hold on
plot(1:frames,degreesTable)
disp(mean(degreesTable))
