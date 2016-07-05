function PhasePlots()

[baseFileName, folderName, FilterIndex]=uigetfile('*.xlsx');
[pathstr, name, ext]=fileparts(baseFileName);
ExcelFileName=[folderName,'/',baseFileName];
[N,T,D]=xlsread(ExcelFileName, 'Sheet1');

t=N(:,2);
frames=size(N,1);
colwidth = numel(N(1,:));
segments = (colwidth-5)/2;

X = zeros(frames,segments);
Y = zeros(frames,segments);
data2plot =zeros(frames,segments);

for i = 1 : frames
    for j = 1 : segments
        X(i,j) = N(i,6+2*j-2);
        Y(i,j) = N(i,7+2*j-2);
    end
    X(i,:) = X(i,:) - ones(1,segments)*mean(X(i,:));
    Y(i,:) = Y(i,:) - ones(1,segments)*mean(Y(i,:));
    fitting = fit(X(i,:)',Y(i,:)','poly1');
    d = (fitting.p1*X(i,:) - Y(i,:) + fitting.p2)/sqrt((fitting.p1)^2+1);
    data2plot(i,:) = d;
end

figure()
contour(t,linspace(1,length(d),length(d))',data2plot',1000)