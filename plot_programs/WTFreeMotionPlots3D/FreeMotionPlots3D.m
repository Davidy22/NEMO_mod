function FreeMotionPlots3D(WormNum,N,GelatineConcentration)

wn=WormNum;
fwin=3;

frames=size(N,1);
colwidth = numel(N(1,:));
segments = (colwidth-6)/3;
tau=N(2,2)-N(1,2);

fps=1/(N(2,2)-N(1,2));

X = zeros(frames,segments);
Y = zeros(frames,segments);
Z = zeros(frames,segments);

for j = 1:segments+1
    X(:,j) = N(:,(3*j)+1);
    Y(:,j) = N(:,(3*j)+2);
    Z(:,j) = N(:,(3*j)+3);
end

xci = X(:,1);
yci = Y(:,1);   
zci = Z(:,1);   
t = N(:,2); 

% x1=X(:,2);
% y1=Y(:,2);
% z1=Z(:,2);

R=zeros(frames,5);
yr=zeros(frames,segments);

rot=linspace(0,180,frames);
figure('units','pixels','outerposition',[0 0 816 892]);
aviobj = VideoWriter(['3Dfmw' num2str(wn) 'v1.avi']);
 open(aviobj);
for k = 1:frames
x=X(k,2:segments+1)';
y=Y(k,2:segments+1)';
z=Z(k,2:segments+1)';

xc = X(k,1);
yc = Y(k,1);   
zc = Z(k,1);

if z(1)>zc
        thetay = pi+atan((yc-y(1))/(zc-z(1)));
      
        else
        thetay = atan((yc-y(1))/(zc-z(1)));
       
end
      
    M1y = [z y x]*[cos(thetay),-sin(thetay),0;sin(thetay),cos(thetay),0;0,0,1];
    Mcy = [zc yc xc]*[cos(thetay),-sin(thetay),0;sin(thetay),cos(thetay),0;0,0,1];
    
    xe1 = M1y(:,3);
    ye1 = M1y(:,2);
    ze1 = M1y(:,1);
           
    xce1 = Mcy(:,3);
    yce1 = Mcy(:,2);
    zce1 = Mcy(:,1);
  
if ze1(1)>zce1
        
        thetax = pi+atan((xce1-xe1(1))/(zce1-ze1(1)));
        else
       
        thetax = atan((xce1-xe1(1))/(zce1-ze1(1)));
end
    
    M1x = [ze1 ye1 xe1]*[cos(thetax),0,-sin(thetax);0,1,0;sin(thetax),0,cos(thetax)];
    Mcx = [zce1 yce1 xce1]*[cos(thetax),0,-sin(thetax);0,1,0;sin(thetax),0,cos(thetax)];
    
    xf1 = M1x(:,3);
    yf1 = M1x(:,2);
    zf1 = M1x(:,1);
           
    xcf1 = Mcx(:,3);
    ycf1 = Mcx(:,2);
    zcf1 = Mcx(:,1);

    ox1=repmat(xcf1(1),1,length(xcf1))';
    oy1=repmat(ycf1(1),1,length(ycf1))';
    oz1=repmat(zf1(1),1,length(zf1))';
 
    oxc1=repmat(xcf1(1),1,length(xcf1))'; 
    oyc1=repmat(ycf1(1),1,length(ycf1))';
    ozc1=repmat(zf1(1),1,length(zcf1))';

    
    xf2 = xf1-ox1;
    yf2 = yf1-oy1;
    zf2 = zf1-oz1;
      

    
    xcf2 = xcf1-oxc1;
    ycf2 = ycf1-oyc1;
    zcf2 = zcf1-ozc1;
  
    
    F1y = @(a1y,zf2y)a1y(1)*zf2 + a1y(2);
    a1y0 = [1 0];
    a1y = lsqcurvefit(F1y,a1y0,zf2,yf2);
    
thetay2 = atan(a1y(1));
    
    
    M3y = [zf2 yf2 xf2]*[cos(thetay2),-sin(thetay2),0;sin(thetay2),cos(thetay2),0;0,0,1];
    Mc3y = [zcf2 ycf2 xcf2]*[cos(thetay2),-sin(thetay2),0;sin(thetay2),cos(thetay2),0;0,0,1];
      
    xe3 = M3y(:,3);
    ye3 = M3y(:,2);
    ze3 = M3y(:,1);
   
    xce3 = Mc3y(:,3);
    yce3 = Mc3y(:,2);
    zce3 = Mc3y(:,1);

    F1x = @(a1x,ze3)a1x(1)*ze3 + a1x(2);
    a1x0 = [1 0];
    a1x = lsqcurvefit(F1x,a1x0,ze3,xe3);
    
thetax2 = atan(a1x(1));
    
    M3x = [ze3 ye3 xe3]*[cos(thetax2),0,-sin(thetax2);0,1,0;sin(thetax2),0,cos(thetax2)];
    Mc3x = [zce3 yce3 xce3]*[cos(thetax2),0,-sin(thetax2);0,1,0;sin(thetax2),0,cos(thetax2)];
    
    xf3 = M3x(:,3);
    yf3 = M3x(:,2);
    zf3 = M3x(:,1);
  
    xcf3 = Mc3x(:,3);
    ycf3 = Mc3x(:,2);
    zcf3 = Mc3x(:,1);
    
    
    
    ox3=repmat(xcf3(1),1,length(xcf1))';
    oy3=repmat(ycf3(1),1,length(ycf1))';
    oz3=repmat(zf3(1),1,length(zf1))';
    
    oxc3=repmat(xcf3(1),1,length(xcf1))';
    oyc3=repmat(ycf3(1),1,length(ycf1))';
    ozc3=repmat(zf3(1),1,length(zcf1))';
   
    xf4 = xf3-ox3;
    yf4 = yf3-oy3;
    zf4 = zf3-oz3;
 
    yr(k,:)=yf4;
     
    xcf4 = xcf3-oxc3;
    ycf4 = ycf3-oyc3;
    zcf4 = zcf3-ozc3;
  
    
    xf4p = xf4(3:length(xf2)-2)';
    yf4p = yf4(3:length(yf2)-2)';
    zf4p = zf4(3:length(zf2)-2)';
   
     
    F2y = @(a2y,zf4p)a2y(1)*sin(2*pi*((a2y(2)*zf4p) + a2y(3)));
    a2y0 = [1 1 1];
    [a2y,resnormy,residualy] = lsqcurvefit(F2y,a2y0,zf4p,yf4p);
    
    F2x = @(a2x,zf4p)a2x(1)*sin(2*pi*((a2y(2)*zf4p) + a2x(2)));
    a2x0 = [1 1];
    [a2x,resnormx,residualx] = lsqcurvefit(F2x,a2x0,zf4p,xf4p);
    
    
    plot3(xf4,yf4,zf4,'o','LineWidth',2);

    hold on
    plot3(xcf4,ycf4,zcf4,'ro','LineWidth',2);
    hold off
    
    hold on
    plot3(F2x(a2x,zf4p),F2y(a2y,zf4p),zf4p,'LineWidth',2);
    hold off

    zz=linspace(-1,1);
    hold on
    plot3(zeros(1,length(zz)),zeros(1,length(zz)),zz,'--k');
    hold off
    
    hold on
    plot3(xf4(1),yf4(1),zf4(1),'go','LineWidth',2);
    hold off
    
    hold on   
    plot3(F2x(a2x,zf4p),F2y(a2y,zf4p),-0.2*ones(1,length(F2x(a2x,zf4p)))','-','Color',[0.75 0.75 0.75],'LineWidth',2);
    hold off
    
    Fx =F2x(a2x,zf4p);
    Fy=F2y(a2y,zf4p);
    
    
    hold on   
    plot3(Fx(1),Fy(1),-0.2,'o','Color',[0.75 0.75 0.75],'LineWidth',4);
    hold off
        
axis([-0.2 0.2 -0.2 0.2 -0.2 1]);
view(rot(k),30);
view(45,30);
grid on
title('Localized Fitting', 'FontSize', 13);
xlabel('X-position (mm)');
ylabel('Y-position (mm)');
zlabel('Z-position (mm)');
set(gca,'fontsize',13)

  R(k,:)=[a2y(3) a2x(2) abs(a2y(1)) abs(a2x(1)) abs(a2y(2))];
        
    writeVideo(aviobj,getframe(gcf));  
     drawnow;
end

      close(aviobj);

DataR = R;
Datay = yr;

offs=round(fwin*fps);
YF=zeros(offs+1,frames-offs);
RF=zeros(frames-offs,3);
mid = round(segments/2);
for i= mid-8:mid+8
for k=1:frames-offs

    YF(:,k) = Datay(k:k+offs,i);
    
end

for j= 1:frames-offs
L = frames-offs;
NFFT = 2^nextpow2(L); 
d2w = fft(YF(:,j),NFFT)/L;
tinter = 1/fps;
f = 1/tinter/2*linspace(0,1,NFFT/2+1);

[pks , locs] = findpeaks(2*abs(d2w(1:NFFT/2+1)),f);
frq = 0;
weight = 0;
for k = 1 : length(pks)


    if weight <= pks(k)
        weight = pks(k);
        frq = locs(k);
    end
end

RF(j,9+i-mid)= abs(frq); 

end


end

RFA= mean(RF,2);
FRQ = mean(RFA)*ones(1,frames)';
for m=1:length(RFA)
FRQ(m) = RFA(m);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t=t-t(1);

dphi=2*pi*abs(DataR(:,1)-DataR(:,2));
fphi=abs(sawtooth (dphi + pi/2, 0.5));

sfphi=abs(smooth(fphi,'rlowess'));

Vxcm=zeros(1,length(t));
Vycm=zeros(1,length(t));
Vzcm=zeros(1,length(t));

sxcm=smooth(xci,31,'sgolay',1);
sycm=smooth(yci,31,'sgolay',1);
szcm=smooth(zci,31,'sgolay',1);

for f=2:length(t)-1
    
    Vxcm(f)=(sxcm(f-1,1)-sxcm(f+1,1))/(2*tau);
    Vycm(f)=(sycm(f-1,1)-sycm(f+1,1))/(2*tau);
    Vzcm(f)=(szcm(f-1,1)-szcm(f+1,1))/(2*tau);
    
end
SVC=abs(smooth(sqrt(Vxcm.^2+Vycm.^2+Vzcm.^2),'rlowess'));

 SWS = abs(smooth(FRQ./DataR(:,5),'rlowess'));
 SA = abs(smooth(sqrt(DataR(:,3).^2 + DataR(:,4).^2),'rlowess'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
figure('units','pixels','outerposition',[0 0 800+16 800+92]);
aviobj = VideoWriter(['3Dfmw' num2str(wn) 'v2.avi']);
open(aviobj);
for j = 1:frames-1
subplot(2,1,1)
hold on
plot(t(j:j+1),SVC(j:j+1),'c','LineWidth',3);
plot(t(j:j+1),SWS(j:j+1),'g','LineWidth',3);


axis([t(1) t(end) 0 1]);
title('Speed', 'FontSize', 13)
xlabel('time(s)')
ylabel('V (mm/s)') 
set(gca,'fontsize',13)
legend('CM Speed','Wave Speed')

subplot(2,1,2)
plot(t(j:j+1),sfphi(j:j+1),'o-','Color',[1-sfphi(j) 0 sfphi(j)],'MarkerFaceColor',[1-sfphi(j) 0 sfphi(j)],'MarkerSize',4,'LineWidth',1);
axis([t(1) t(end) 0 1]);
title('Phase Difference', 'FontSize', 13)
xlabel('time(s)')
ylabel('|\Delta \phi|') 
set(gca,'fontsize',13)
writeVideo(aviobj,getframe(gcf));  
   drawnow;
end
    close(aviobj);

figure('units','pixels','outerposition',[0 0 800+16 800+92]);
aviobj = VideoWriter(['3Dfmw' num2str(wn) 'v3.avi']);
open(aviobj);    
polar(fphi,1.5*ones(length(fphi),1),'w')
for j = 1:frames-1

hold on

p = polar((pi/2)*fphi(j:j+1),SF(j:j+1),'o-');

set(p,'Color',[1-fphi(j) 0 fphi(j)]);
set(p,'MarkerFaceColor',[1-fphi(j) 0 fphi(j)]);
set(p,'MarkerSize',3);
set(p,'LineWidth',1);

tha = findall(gcf,'Type','text');
for i = 1:length(tha),
      set(tha(i),'FontSize',15)
end

title('Frequency and Phase', 'FontSize', 13);

axis([0 1.5 0 1.5])

xlabel('Radius = Frequency (Hz), Angle = Phase (deg)')

set(gca,'fontsize',13)
writeVideo(aviobj,getframe(gcf));  
   drawnow;
end
    close(aviobj);    


end