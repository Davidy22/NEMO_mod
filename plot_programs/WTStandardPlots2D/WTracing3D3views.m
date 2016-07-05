function WTracing3D3views()


[baseFileName, folderName, FilterIndex]=uigetfile('*.xlsx');
[pathstr, name, ext]=fileparts(baseFileName);
ExcelFileName=[folderName,'/',baseFileName];
[N,T,D]=xlsread(ExcelFileName, 'Sheet1');

frames=size(N,1);
colwidth = numel(N(1,:));
segments = (colwidth-6)/3;

X = zeros(frames,segments);
Y = zeros(frames,segments);
Z = zeros(frames,segments);

for j = 1:segments+1
    X(:,j) = N(:,(3*j)+1);
    Y(:,j) = N(:,(3*j)+2);
    Z(:,j) = N(:,(3*j)+3);
end

xc = X(:,1);
yc = Y(:,1);   
zc = Z(:,1);   
t = N(:,2);
x1=X(:,2);
y1=Y(:,2);
z1=Z(:,2);
figure;
for k = 1:frames

subplot(1,3,1)    
plot3(xc,yc,zc);

% hold on
% plot3(x1,y1,z1);
% hold off

hold on
plot3(xc(k),yc(k),zc(k),'ro');
hold off

x=X(k,2:segments+1)';
y=Y(k,2:segments+1)';
z=Z(k,2:segments+1)';

hold on
plot3(x,y,z,'g-o');
hold off


axis([min(xc)-0.3 max(xc)+0.3 min(yc)-0.3 max(yc)+0.3 min(zc)-0.3 max(zc)+0.3]);
grid on
title(num2str(k))
view(0,0)
xlabel('X-position (mm)')
ylabel('Y-position (mm)')
zlabel('Z-position (mm)')

subplot(1,3,2)    
plot3(xc,yc,zc);

% hold on
% plot3(x1,y1,z1);
% hold off

hold on
plot3(xc(k),yc(k),zc(k),'ro');
hold off

x=X(k,2:segments+1)';
y=Y(k,2:segments+1)';
z=Z(k,2:segments+1)';

hold on
plot3(x,y,z,'g-o');
hold off


axis([min(xc)-0.3 max(xc)+0.3 min(yc)-0.3 max(yc)+0.3 min(zc)-0.3 max(zc)+0.3]);
grid on
title(num2str(k))
view(0,90)
xlabel('X-position (mm)')
ylabel('Y-position (mm)')
zlabel('Z-position (mm)')

subplot(1,3,3)    
plot3(xc,yc,zc);

% hold on
% plot3(x1,y1,z1);
% hold off

hold on
plot3(xc(k),yc(k),zc(k),'ro');
hold off

x=X(k,2:segments+1)';
y=Y(k,2:segments+1)';
z=Z(k,2:segments+1)';

hold on
plot3(x,y,z,'g-o');
hold off


axis([min(xc)-0.3 max(xc)+0.3 min(yc)-0.3 max(yc)+0.3 min(zc)-0.3 max(zc)+0.3]);
grid on
title(num2str(k))
view(90,0)
xlabel('X-position (mm)')
ylabel('Y-position (mm)')
zlabel('Z-position (mm)')
drawnow;
end
    