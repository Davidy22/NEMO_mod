function EigenPlots()
[baseFileName, folderName, FilterIndex]=uigetfile('*.xlsx');
[pathstr, name, ext]=fileparts(baseFileName);
ExcelFileName=[folderName,'/',baseFileName];
[N,T,D]=xlsread(ExcelFileName, 'Sheet1');

frames=size(N,1);
colwidth = numel(N(1,:));
segments = (colwidth-5)/2;

X = zeros(frames,segments);
Y = zeros(frames,segments);

for j = 1:segments+1
    X(:,j) = N(:,(2*j)+2);
    Y(:,j) = N(:,(2*j)+3);
end
 for i = 1:frames
x=X(i,2:segments+1)';
y=Y(i,2:segments+1)';

s = zeros(segments-1,1);
theta = zeros(segments-1,1);

for k=2:segments 
s(k-1,1) = (k-2)/(segments-2);
theta(k-1,1) = atan((y(k-1)-y(k))/(x(k-1)-x(k)));
end

plot(s,theta);

axis([0,1,-pi/2,pi/2])
title('Eigen Plots', 'FontSize', 12);
xlabel('s');   
ylabel('\theta (rad)');

 drawnow;
 
 end