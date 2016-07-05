function standardplots3D(varargin)


[baseFileName, folderName, FilterIndex]=uigetfile('*.xlsx');


[pathstr, name, ext]=fileparts(baseFileName);
ExcelFileName=[folderName,'/',baseFileName];
[N,T,D]=xlsread(ExcelFileName, 'Sheet1');

numberofframes=size(N,1);
t=1/(N(2,2)-N(1,2));
time=N(1:end,2);
starttime=N(1,2);
xcm=N(1:end,4)-N(1,4);
ycm=N(1:end,5)-N(1,5);
zcm=N(1:end,6)-N(1,6);
xh=N(1:end,7)-N(1,4);
yh=N(1:end,8)-N(1,5);
zh=N(1:end,9)-N(1,6);
phase=T(2:end,3);

colwidth = numel(N(1,:));
segs = (colwidth-6)/3;



Vxcm=movingslope(xcm,31,1,1/t);
Vycm=movingslope(ycm,31,1,1/t);
Vzcm=movingslope(zcm,31,1,1/t);
Vxh=movingslope(xh,31,1,1/t);
Vyh=movingslope(yh,31,1,1/t);
Vzh=movingslope(zh,31,1,1/t);


AngCm = atan2(Vzcm,(Vxcm+Vycm))*(180/pi);
AngH = atan2(Vzh,(Vxh+Vyh))*(180/pi);

% AngCm = zeros(length(time),1);
% AngH = zeros(length(time),1);
% 
% for i = 1:length(time)
%     
% if Vxcm(i)<0
% AngCm(i,1) = 180+ ( atan(Vycm(i)/Vxcm(i))*(180/pi) );
% else
%     if Vycm(i)<0
%         AngCm(i,1) = 360 + ( atan(Vycm(i)/Vxcm(i))*(180/pi) );
%     else
%     AngCm(i,1) = atan(Vycm(i)/Vxcm(i))*(180/pi);
%     end
% end
% 
% 
% if Vxh(i)<0
% AngH(i,1) = 180+( atan(Vyh(i)/Vxh(i))*(180/pi) );
% else
%     if Vyh(i)<0
%         AngH(i,1) = 360+( atan(Vyh(i)/Vxh(i))*(180/pi) );
%     else
%     AngH(i,1) = atan(Vyh(i)/Vxh(i))*(180/pi);
%     end
% end
% 
% end

minAngCm = min(AngCm);
maxAngCm = max(AngCm);
minAngH = min(AngH);
maxAngH = max(AngH);
Angaxis = [min([minAngCm,minAngH]),max([maxAngCm,maxAngH])];


Vcm=sqrt(Vxcm.^2+Vycm.^2+Vzcm.^2);
Vh=sqrt(Vxh.^2+Vyh.^2+Vzh.^2);

Axcm=movingslope(Vxcm,31,1,1/t);
Aycm=movingslope(Vycm,31,1,1/t);
Azcm=movingslope(Vzcm,31,1,1/t);
Axh=movingslope(Vxh,31,1,1/t);
Ayh=movingslope(Vyh,31,1,1/t);
Azh=movingslope(Vzh,31,1,1/t);

Acm=sqrt(Axcm.^2+Aycm.^2+Azcm.^2);
Ah=sqrt(Axh.^2+Ayh.^2+Azh.^2);


figure  %('Position',[100,100,1400,1050])
mt=annotation('textbox', [0 0.9 1 0.1],'String', [name ' Plots 1'],'EdgeColor', 'none','HorizontalAlignment', 'center');
mtfs = mt.FontSize;
mt.FontSize = 15;

%%%%
subplot(3,5,1)
hold on

axisminx=floor(min(min([xcm;xh])));
axismaxx=ceil(max(max([xcm;xh])));
axisminy=floor(min(min([ycm;yh])));
axismaxy=ceil(max(max([ycm;yh])));
axisminz=floor(min(min([zcm;zh])));
axismaxz=ceil(max(max([zcm;zh])));
absaxis=max([abs(axisminx),abs(axismaxx),abs(axisminy),abs(axismaxy),abs(axisminz),abs(axismaxz)]);
axis equal
axis([-absaxis,absaxis,-absaxis,absaxis,-absaxis,absaxis])

plot3([0,0],[0,0],[-absaxis,absaxis],'-k','LineWidth',1);
plot3([0,0],[-absaxis,absaxis],[0,0],'-k','LineWidth',1);
plot3([-absaxis,absaxis],[0,0],[0,0],'-k','LineWidth',1);

plot3(xcm(end),ycm(end),zcm(end),'o','MarkerSize',5,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);       
plot3(xcm(1),ycm(1),zcm(end),'o','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);
plot3(xh(end),yh(end),zh(end),'o','MarkerSize',5,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);       
plot3(xh(1),yh(1),zh(end),'o','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);

plot3(xcm,ycm,zcm,'-r','LineWidth',2)
plot3(xh,yh,zcm,'-b','LineWidth',1)

for i=1:round(15*t):(numberofframes-round(3*t))
    plot3(xcm(i),ycm(i),zcm(i),'.k','MarkerSize',15);
    plot3(xcm(i+round(3*t)),ycm(i+round(3*t)),zcm(i+round(3*t)),'.k','MarkerSize',10);
    plot3(xh(i),yh(i),zh(i),'.k','MarkerSize',15);
    plot3(xh(i+round(3*t)),yh(i+round(3*t)),zh(i+round(3*t)),'.k','MarkerSize',10);
end

title(['Track'], 'FontSize', 13);
xlabel('x (mm)');   
ylabel('y (mm)');
zlabel('z (mm)');
view(3);
%%%%%
subplot(3,5,2)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,xcm,'-r','LineWidth',2)
plot(time,xh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['X-position vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('x (mm)');


%%%%%
subplot(3,5,3)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,ycm,'-r','LineWidth',2)
plot(time,yh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['Y-position vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('y (mm)');

%%%%%
subplot(3,5,4)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,zcm,'-r','LineWidth',2)
plot(time,zh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['Z-position vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('z (mm)');


%%%%%
subplot(3,5,5)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,unwrap(AngCm),'-r','LineWidth',2)
plot(time,unwrap(AngH),'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,Angaxis(1),Angaxis(2)])

title(['Orientation angle from XY-plane vs time'], 'FontSize',13);
xlabel('time (s)');   
ylabel(' Angle (^{\circ}) ');
%%%%%
subplot(3,5,6)
hold on

axisminx=floor(min(min([Vxcm;Vxh]))*10)/10;
axismaxx=ceil(max(max([Vxcm;Vxh]))*10)/10;
axisminy=floor(min(min([Vycm;Vyh]))*10)/10;
axismaxy=ceil(max(max([Vycm;Vyh]))*10)/10;
axisminz=floor(min(min([Vzcm;Vzh]))*10)/10;
axismaxz=ceil(max(max([Vzcm;Vzh]))*10)/10;
absaxis=max([abs(axisminx),abs(axismaxx),abs(axisminy),abs(axismaxy),abs(axisminz),abs(axismaxz)]);
axis equal
axis([-absaxis,absaxis,-absaxis,absaxis,-absaxis,absaxis])

plot3([0,0],[0,0],[-absaxis,absaxis],'-k','LineWidth',1);
plot3([0,0],[-absaxis,absaxis],[0,0],'-k','LineWidth',1);
plot3([-absaxis,absaxis],[0,0],[0,0],'-k','LineWidth',1);

plot3(Vxcm(end),Vycm(end),Vzcm(end),'o','MarkerSize',5,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);       
plot3(Vxcm(1),Vycm(1),Vzcm(1),'o','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);
plot3(Vxh(end),Vyh(end),Vzh(end),'o','MarkerSize',5,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);       
plot3(Vxh(1),Vyh(1),Vzh(1),'o','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);

plot3(Vxcm,Vycm,Vzcm,'-r','LineWidth',2)
plot3(Vxh,Vyh,Vzh,'-b','LineWidth',1)

title(['Velocity'], 'FontSize', 13);
xlabel('Vx (mm/s)');   
ylabel('Vy (mm/s)');
zlabel('Vz (mm/s)');
view(3);

%%%%%
subplot(3,5,7)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,Vxcm,'-r','LineWidth',2)
plot(time,Vxh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['X-velocity vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('Vx (mm/s)');


%%%%%
subplot(3,5,8)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,Vycm,'-r','LineWidth',2)
plot(time,Vyh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['Y-velocity vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('Vy (mm/s)');


%%%%%

subplot(3,5,9)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,Vzcm,'-r','LineWidth',2)
plot(time,Vzh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['Z-velocity vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('Vz (mm/s)');

%%%%%
subplot(3,5,10)
hold on

% plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,Vcm,'-r','LineWidth',2)
plot(time,Vh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,0,absaxis])

title(['Speed vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('Speed (mm/s)');


%%%%%
subplot(3,5,11)
hold on

axisminx=floor(min(min([Axcm;Axh]))*10)/10;
axismaxx=ceil(max(max([Axcm;Axh]))*10)/10;
axisminy=floor(min(min([Aycm;Ayh]))*10)/10;
axismaxy=ceil(max(max([Aycm;Ayh]))*10)/10;
axisminz=floor(min(min([Azcm;Azh]))*10)/10;
axismaxz=ceil(max(max([Azcm;Azh]))*10)/10;
absaxis=max([abs(axisminx),abs(axismaxx),abs(axisminy),abs(axismaxy),abs(axisminz),abs(axismaxz)]);
axis equal
axis([-absaxis,absaxis,-absaxis,absaxis,-absaxis,absaxis])

plot3([0,0],[0,0],[-absaxis,absaxis],'-k','LineWidth',1);
plot3([0,0],[-absaxis,absaxis],[0,0],'-k','LineWidth',1);
plot3([-absaxis,absaxis],[0,0],[0,0],'-k','LineWidth',1);

plot3(Axcm(end),Aycm(end),Azcm(end),'o','MarkerSize',5,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);       
plot3(Axcm(1),Aycm(1),Azcm(1),'o','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);
plot3(Axh(end),Ayh(end),Azh(end),'o','MarkerSize',5,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);       
plot3(Axh(1),Ayh(1),Azh(1),'o','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);

plot3(Axcm,Aycm,Azcm,'-r','LineWidth',2)
plot3(Axh,Ayh,Azh,'-b','LineWidth',1)

title(['Acceleration'], 'FontSize', 13);
xlabel('Ax (mm/s^{2})');   
ylabel('Ay (mm/s^{2})');
zlabel('Az (mm/s^{2})');
view(3);

%%%%%
subplot(3,5,12)
hold on

plot([0,length(time)],[0,0],'-k','LineWidth',1);

plot(time,Axcm,'-r','LineWidth',2)
plot(time,Axh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['X-acceleration vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('Ax (mm/s^{2})');


%%%%%
subplot(3,5,13)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,Aycm,'-r','LineWidth',2)
plot(time,Ayh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['Y-acceleration vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('Ay (mm/s^{2})');

%%%%%
subplot(3,5,14)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,Azcm,'-r','LineWidth',2)
plot(time,Azh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['Z-acceleration vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('Az (mm/s^{2})');

%%%%%
subplot(3,5,15)
hold on

% plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,Acm,'-r','LineWidth',2)
plot(time,Ah,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,0,absaxis])

title(['Acceleration magnitude vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('Acceleration (mm/s^2)');


% AvgVxcm= mean(abs(Vxcm));
% AvgVycm= mean(abs(Vycm));
 AvgVcm= mean(abs(Vcm));
% AvgVxh= mean(abs(Vxh));
% AvgVyh= mean(abs(Vxh));
 AvgVh= mean(abs(Vh));
 fpst=round(t);


%%%%%
% cd(folderName)
% cd ../
% mkdir('Standard Format')
% cd('Standard Format')
% set(gcf,'PaperUnits','points','PaperPosition',[0,0,1280,720])
% saveas(gcf,['StandardFormat_' name],'tiff')
% cd(oldfolder)
% 
 WormTraceFitting3D(ExcelFileName,name,numberofframes,fpst,segs,AvgVcm,AvgVh,Vcm)

