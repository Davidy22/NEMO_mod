function main()

[baseFileName, folderName, FilterIndex]=uigetfile('*.xlsx','MultiSelect','on');

if iscellstr(baseFileName)
numfiles = size(baseFileName,2);
else
numfiles = 1; 
end


for m=1:numfiles
if numfiles==1
[pathstr, name, ext]=fileparts(baseFileName);
ExcelFileName=[folderName,'/',baseFileName];
[N,T,D]=xlsread(ExcelFileName, 'Sheet1');  
else
[pathstr, name, ext]=fileparts(char(baseFileName(m)));
ExcelFileName=[folderName,'/',char(baseFileName(m))];
[N,T,D]=xlsread(ExcelFileName, 'Sheet1');
end

numberofframes=size(N,1);
t=1/(N(2,2)-N(1,2));
time=N(1:end,2);
starttime=N(1,2);
xcm=N(1:end,4)-N(1,4);
ycm=N(1:end,5)-N(1,5);
xh=N(1:end,6);
xh(xh==0)=NaN;
xh=xh-N(1,4);
yh=N(1:end,7);
yh(yh==0)=NaN;
yh=yh-N(1,5);
phase=T(2:end,3);

colwidth = numel(N(1,:));
segs = (colwidth-5)/2;

%cd(oldfolder)

Vxcm=movingslope(xcm,31,1,1/t);
Vycm=movingslope(ycm,31,1,1/t);
Vxh=movingslope(xh,31,1,1/t);
Vyh=movingslope(yh,31,1,1/t);


AngCm = atan2(Vycm,Vxcm)*(180/pi);
AngH = atan2(Vyh,Vxh)*(180/pi);

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

Vcm=sqrt(Vxcm.^2+Vycm.^2);
Vh=sqrt(Vxh.^2+Vyh.^2);

Axcm=movingslope(Vxcm,31,1,1/t);
Aycm=movingslope(Vycm,31,1,1/t);
Axh=movingslope(Vxh,31,1,1/t);
Ayh=movingslope(Vyh,31,1,1/t);

Acm=sqrt(Axcm.^2+Aycm.^2);
Ah=sqrt(Axh.^2+Ayh.^2);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% mt=annotation('textbox', [0 0.9 1 0.1],'String', [name ' Plots 1'],'EdgeColor', 'none','HorizontalAlignment', 'center');
% mtfs = mt.FontSize;
% mt.FontSize = 15;
% 
% subplot(2,2,1);
% hold on
% axisminx=floor(min(min([xcm;xh])));
% axismaxx=ceil(max(max([xcm;xh])));
% axisminy=floor(min(min([ycm;yh])));
% axismaxy=ceil(max(max([ycm;yh])));
% absaxis=max([abs(axisminx),abs(axismaxx),abs(axisminy),abs(axismaxy)]);
% axis equal
% axis([-absaxis,absaxis,-absaxis,absaxis])
% 
% plot([0,0],[-absaxis,absaxis],'-k','LineWidth',1);
% plot([-absaxis,absaxis],[0,0],'-k','LineWidth',1);
% 
% plot(xcm(end),ycm(end),'o','MarkerSize',5,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);       
% plot(xcm(1),ycm(1),'o','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);
% plot(xh(end),yh(end),'o','MarkerSize',5,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);       
% plot(xh(1),yh(1),'o','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);
% 
% plot(xcm,ycm,'-r','LineWidth',2)
% plot(xh,yh,'-b','LineWidth',1)
% 
% title(['Track'], 'FontSize', 13);
% xlabel('x (mm)');   
% ylabel('y (mm)');
% 
% subplot(2,2,3)
% hold on
% 
% plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);
% 
% plot(time,xcm,'-r','LineWidth',2)
% plot(time,xh,'-b','LineWidth',1)
% 
% axis([starttime,length(time)/t+starttime,-absaxis,absaxis])
% 
% title(['X-position vs time'], 'FontSize', 13);
% xlabel('time (s)');   
% ylabel('x (mm)');
% 
% 
% %%%%%
% subplot(2,2,4)
% hold on
% 
% plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);
% 
% plot(time,ycm,'-r','LineWidth',2)
% plot(time,yh,'-b','LineWidth',1)
% 
% axis([starttime,length(time)/t+starttime,-absaxis,absaxis])
% 
% title(['Y-position vs time'], 'FontSize', 13);
% xlabel('time (s)');   
% ylabel('y (mm)');
% 
% figure;
% mt=annotation('textbox', [0 0.9 1 0.1],'String', [name ' Plots 1'],'EdgeColor', 'none','HorizontalAlignment', 'center');
% mtfs = mt.FontSize;
% mt.FontSize = 15;
% 
% subplot(2,2,3)
% hold on
% 
% axisminx=floor(min(min([Vxcm;Vxh]))*10)/10;
% axismaxx=ceil(max(max([Vxcm;Vxh]))*10)/10;
% axisminy=floor(min(min([Vycm;Vyh]))*10)/10;
% axismaxy=ceil(max(max([Vycm;Vyh]))*10)/10;
% absaxis=max([abs(axisminx),abs(axismaxx),abs(axisminy),abs(axismaxy)]);
% axis equal
% axis([-absaxis,absaxis,-absaxis,absaxis])
% 
% plot([0,0],[-absaxis,absaxis],'-k','LineWidth',1);
% plot([-absaxis,absaxis],[0,0],'-k','LineWidth',1);
% 
% plot(Vxcm(end),Vycm(end),'o','MarkerSize',5,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);       
% plot(Vxcm(1),Vycm(1),'o','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);
% plot(Vxh(end),Vyh(end),'o','MarkerSize',5,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);       
% plot(Vxh(1),Vyh(1),'o','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);
% 
% plot(Vxcm,Vycm,'-r','LineWidth',2)
% plot(Vxh,Vyh,'-b','LineWidth',1)
% 
% title(['Velocity'], 'FontSize', 13);
% xlabel('Vx (mm/s)');   
% ylabel('Vy (mm/s)');
% 
% 
% %%%%%
% subplot(2,2,1)
% hold on
% 
% plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);
% 
% plot(time,Vxcm,'-r','LineWidth',2)
% plot(time,Vxh,'-b','LineWidth',1)
% 
% axis([starttime,length(time)/t+starttime,-absaxis,absaxis])
% 
% title(['X-velocity vs time'], 'FontSize', 13);
% xlabel('time (s)');   
% ylabel('Vx (mm/s)');
% 
% 
% %%%%%
% subplot(2,2,2)
% hold on
% 
% plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);
% 
% plot(time,Vycm,'-r','LineWidth',2)
% plot(time,Vyh,'-b','LineWidth',1)
% 
% axis([starttime,length(time)/t+starttime,-absaxis,absaxis])
% 
% title(['Y-velocity vs time'], 'FontSize', 13);
% xlabel('time (s)');   
% ylabel('Vy (mm/s)');
% 
% 
% %%%%%
% subplot(2,2,4)
% hold on
% 
% % plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);
% 
% plot(time,Vcm,'-r','LineWidth',2)
% plot(time,Vh,'-b','LineWidth',1)
% 
% axis([starttime,length(time)/t+starttime,0,absaxis])
% 
% title(['Speed vs time'], 'FontSize', 13);
% xlabel('time (s)');   
% ylabel('Speed (mm/s)');
% 
% figure;
% mt=annotation('textbox', [0 0.9 1 0.1],'String', [name ' Plots 1'],'EdgeColor', 'none','HorizontalAlignment', 'center');
% mtfs = mt.FontSize;
% mt.FontSize = 15;
% 
% subplot(2,2,3)
% hold on
% 
% axisminx=floor(min(min([Axcm;Axh]))*10)/10;
% axismaxx=ceil(max(max([Axcm;Axh]))*10)/10;
% axisminy=floor(min(min([Aycm;Ayh]))*10)/10;
% axismaxy=ceil(max(max([Aycm;Ayh]))*10)/10;
% absaxis=max([abs(axisminx),abs(axismaxx),abs(axisminy),abs(axismaxy)]);
% axis equal
% axis([-absaxis,absaxis,-absaxis,absaxis])
% 
% plot([0,0],[-absaxis,absaxis],'-k','LineWidth',1);
% plot([-absaxis,absaxis],[0,0],'-k','LineWidth',1);
% 
% plot(Axcm(end),Aycm(end),'o','MarkerSize',5,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);       
% plot(Axcm(1),Aycm(1),'o','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);
% plot(Axh(end),Ayh(end),'o','MarkerSize',5,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);       
% plot(Axh(1),Ayh(1),'o','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);
% 
% plot(Axcm,Aycm,'-r','LineWidth',2)
% plot(Axh,Ayh,'-b','LineWidth',1)
% 
% title(['Acceleration'], 'FontSize', 13);
% xlabel('Ax (mm/s^{2})');   
% ylabel('Ay (mm/s^{2})');
% 
% 
% %%%%%
% subplot(2,2,1)
% hold on
% 
% plot([0,length(time)],[0,0],'-k','LineWidth',1);
% 
% plot(time,Axcm,'-r','LineWidth',2)
% plot(time,Axh,'-b','LineWidth',1)
% 
% axis([starttime,length(time)/t+starttime,-absaxis,absaxis])
% 
% title(['X-acceleration vs time'], 'FontSize', 13);
% xlabel('time (s)');   
% ylabel('Ax (mm/s^{2})');
% 
% 
% %%%%%
% subplot(2,2,2)
% hold on
% 
% plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);
% 
% plot(time,Aycm,'-r','LineWidth',2)
% plot(time,Ayh,'-b','LineWidth',1)
% 
% axis([starttime,length(time)/t+starttime,-absaxis,absaxis])
% 
% title(['Y-acceleration vs time'], 'FontSize', 13);
% xlabel('time (s)');   
% ylabel('Ay (mm/s^{2})');
% 
% 
% %%%%%
% subplot(2,2,4)
% hold on
% 
% % plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);
% 
% plot(time,Acm,'-r','LineWidth',2)
% plot(time,Ah,'-b','LineWidth',1)
% 
% axis([starttime,length(time)/t+starttime,0,absaxis])
% 
% title(['Acceleration magnitude vs time'], 'FontSize', 13);
% xlabel('time (s)');   
% ylabel('Acceleration (mm/s^2)');
% 
% figure;
% mt=annotation('textbox', [0 0.9 1 0.1],'String', [name ' Plots 1'],'EdgeColor', 'none','HorizontalAlignment', 'center');
% mtfs = mt.FontSize;
% mt.FontSize = 15;
% 
% hold on
% 
% plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);
% 
% plot(time,AngCm,'-r','LineWidth',2)
% plot(time,AngH,'-b','LineWidth',1)
% 
% axis([starttime,length(time)/t+starttime,Angaxis(1),Angaxis(2)])
% 
% title(['Orientation angle from x-axis vs time'], 'FontSize',13);
% xlabel('time (s)');   
% ylabel(' Angle (^{\circ}) ');
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure  %('Position',[100,100,1400,1050])
mt=annotation('textbox', [0 0.9 1 0.1],'String', [name ' Plots 1'],'EdgeColor', 'none','HorizontalAlignment', 'center');
mtfs = mt.FontSize;
mt.FontSize = 15;


%%%%
subplot(3,4,1)
hold on

axisminx=floor(min(min([xcm;xh])));
axismaxx=ceil(max(max([xcm;xh])));
axisminy=floor(min(min([ycm;yh])));
axismaxy=ceil(max(max([ycm;yh])));
absaxis=max([abs(axisminx),abs(axismaxx),abs(axisminy),abs(axismaxy)]);
axis equal
axis([-absaxis,absaxis,-absaxis,absaxis])

plot([0,0],[-absaxis,absaxis],'-k','LineWidth',1);
plot([-absaxis,absaxis],[0,0],'-k','LineWidth',1);

plot(xcm(end),ycm(end),'o','MarkerSize',5,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);       
plot(xcm(1),ycm(1),'o','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);
plot(xh(end),yh(end),'o','MarkerSize',5,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);       
plot(xh(1),yh(1),'o','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);

plot(xcm,ycm,'-r','LineWidth',2)
plot(xh,yh,'-b','LineWidth',1)

% for i=1:round(15*t):(numberofframes-round(3*t))
%     plot(xcm(i),ycm(i),'.k','MarkerSize',15);
%     plot(xcm(i+round(3*t)),ycm(i+round(3*t)),'.k','MarkerSize',10);
%     plot(xh(i),yh(i),'.k','MarkerSize',15);
%     plot(xh(i+round(3*t)),yh(i+round(3*t)),'.k','MarkerSize',10);
% end

title(['Track'], 'FontSize', 13);
xlabel('x (mm)');   
ylabel('y (mm)');


%%%%%
subplot(3,4,2)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,xcm,'-r','LineWidth',2)
plot(time,xh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['X-position vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('x (mm)');


%%%%%
subplot(3,4,3)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,ycm,'-r','LineWidth',2)
plot(time,yh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['Y-position vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('y (mm)');

%%%%%
subplot(3,4,4)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,AngCm,'-r','LineWidth',2)
plot(time,AngH,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,Angaxis(1),Angaxis(2)])

title(['Orientation angle from x-axis vs time'], 'FontSize',13);
xlabel('time (s)');   
ylabel(' Angle (^{\circ}) ');
%%%%%
subplot(3,4,5)
hold on

axisminx=floor(min(min([Vxcm;Vxh]))*10)/10;
axismaxx=ceil(max(max([Vxcm;Vxh]))*10)/10;
axisminy=floor(min(min([Vycm;Vyh]))*10)/10;
axismaxy=ceil(max(max([Vycm;Vyh]))*10)/10;
absaxis=max([abs(axisminx),abs(axismaxx),abs(axisminy),abs(axismaxy)]);
axis equal
axis([-absaxis,absaxis,-absaxis,absaxis])

plot([0,0],[-absaxis,absaxis],'-k','LineWidth',1);
plot([-absaxis,absaxis],[0,0],'-k','LineWidth',1);

plot(Vxcm(end),Vycm(end),'o','MarkerSize',5,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);       
plot(Vxcm(1),Vycm(1),'o','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);
plot(Vxh(end),Vyh(end),'o','MarkerSize',5,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);       
plot(Vxh(1),Vyh(1),'o','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);

plot(Vxcm,Vycm,'-r','LineWidth',2)
plot(Vxh,Vyh,'-b','LineWidth',1)

title(['Velocity'], 'FontSize', 13);
xlabel('Vx (mm/s)');   
ylabel('Vy (mm/s)');


%%%%%
subplot(3,4,6)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,Vxcm,'-r','LineWidth',2)
plot(time,Vxh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['X-velocity vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('Vx (mm/s)');


%%%%%
subplot(3,4,7)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,Vycm,'-r','LineWidth',2)
plot(time,Vyh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['Y-velocity vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('Vy (mm/s)');


%%%%%
subplot(3,4,8)
hold on

% plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,Vcm,'-r','LineWidth',2)
plot(time,Vh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,0,absaxis])

title(['Speed vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('Speed (mm/s)');


%%%%%
subplot(3,4,9)
hold on

axisminx=floor(min(min([Axcm;Axh]))*10)/10;
axismaxx=ceil(max(max([Axcm;Axh]))*10)/10;
axisminy=floor(min(min([Aycm;Ayh]))*10)/10;
axismaxy=ceil(max(max([Aycm;Ayh]))*10)/10;
absaxis=max([abs(axisminx),abs(axismaxx),abs(axisminy),abs(axismaxy)]);
axis equal
axis([-absaxis,absaxis,-absaxis,absaxis])

plot([0,0],[-absaxis,absaxis],'-k','LineWidth',1);
plot([-absaxis,absaxis],[0,0],'-k','LineWidth',1);

plot(Axcm(end),Aycm(end),'o','MarkerSize',5,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);       
plot(Axcm(1),Aycm(1),'o','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor',[1,0.5,0.5]);
plot(Axh(end),Ayh(end),'o','MarkerSize',5,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);       
plot(Axh(1),Ayh(1),'o','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.5,0.5,1]);

plot(Axcm,Aycm,'-r','LineWidth',2)
plot(Axh,Ayh,'-b','LineWidth',1)

title(['Acceleration'], 'FontSize', 13);
xlabel('Ax (mm/s^{2})');   
ylabel('Ay (mm/s^{2})');


%%%%%
subplot(3,4,10)
hold on

plot([0,length(time)],[0,0],'-k','LineWidth',1);

plot(time,Axcm,'-r','LineWidth',2)
plot(time,Axh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['X-acceleration vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('Ax (mm/s^{2})');


%%%%%
subplot(3,4,11)
hold on

plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,Aycm,'-r','LineWidth',2)
plot(time,Ayh,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,-absaxis,absaxis])

title(['Y-acceleration vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('Ay (mm/s^{2})');


%%%%%
subplot(3,4,12)
hold on

% plot([starttime,length(time)/t+starttime],[0,0],'-k','LineWidth',1);

plot(time,Acm,'-r','LineWidth',2)
plot(time,Ah,'-b','LineWidth',1)

axis([starttime,length(time)/t+starttime,0,absaxis])

title(['Acceleration magnitude vs time'], 'FontSize', 13);
xlabel('time (s)');   
ylabel('Acceleration (mm/s^2)');

AvgVxcm= mean(abs(Vxcm));
AvgVycm= mean(abs(Vycm));
AvgVcm= mean(abs(Vcm));
AvgVxh= mean(abs(Vxh));
AvgVyh= mean(abs(Vxh));
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

 WormTraceFitting2D(ExcelFileName,name,numberofframes,fpst,segs,AvgVcm,AvgVh,Vcm,m)

end

fileres = 'wTfit_Res.csv';

Datares = csvread(fileres);

GammaPlots(Datares,name)
