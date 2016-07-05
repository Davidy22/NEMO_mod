function ElectrotaxisPlots2DA(WormNum,N,T)

global outPlotsFolder   % added

oldfolder = pwd;        % added
cd(outPlotsFolder)      % added

options = optimset('Display','off');    % added

wn=WormNum;
fwin=3;



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

xc = X(:,1);
yc = Y(:,1);   
t = N(:,2);
x1=X(:,2);
y1=Y(:,2);
xe = X(:,end);
ye = Y(:,end);

a=zeros(2,length(t));
co=zeros(length(t),3);


for k=1:length(t)
    
    a(1,k)=tau; 
    
   state=char(T(k+1,3)); 
   switch state
       case 'forward'
            co(k,1)=0;
            co(k,2)=1; 
            co(k,3)=0;    
       case 'reversal'
            co(k,1)=1;
            co(k,2)=0; 
            co(k,3)=0;  
       case 'omega turn'
            co(k,1)=0;
            co(k,2)=0; 
            co(k,3)=1;     
       case 'pause'
            co(k,1)=0;
            co(k,2)=0; 
            co(k,3)=0; 
   end

end

otf=15;

ktf=zeros(1,frames);

for i=1:frames
if i>=otf+1 && i<=frames-otf
if co(i,3)==1
ktf(i-otf:i+otf)=ones(1,(2*otf)+1);    
else
ktf(i)=0;
end
else
ktf(i)=0;
end    
end

RLr=zeros(frames,5);
yLr=zeros(frames,segments);

figure('units','pixels','outerposition',[0 0 512+16 512+92]);
aviobj = VideoWriter(['2Detw' num2str(wn) 'v1a.avi']);
open(aviobj);

for k = 1:frames
 
x=X(k,2:segments+1)';
y=Y(k,2:segments+1)';
    
      if x(1)>xc(k)
        theta = pi+atan((yc(k)-y(1))/(xc(k)-x(1)));
      else
        theta = atan((yc(k)-y(1))/(xc(k)-x(1)));

      end
    M1 = [x y]*[cos(theta),-sin(theta);sin(theta),cos(theta)];
    Mc = [xc(k) yc(k)]*[cos(theta),-sin(theta);sin(theta),cos(theta)];
    
    xf1 = M1(:,1);
    yf1 = M1(:,2);
     
    xcf1 = Mc(:,1);
    ycf1 = Mc(:,2);
    
    ox1=repmat(xf1(1),1,length(xf1))';
    oy1=repmat(ycf1(1),1,length(yf1))';
    
    oxc1=repmat(xf1(1),1,length(xcf1))';
    oyc1=repmat(ycf1(1),1,length(ycf1))';
    
    xf2 = xf1-ox1;
    yf2 = yf1-oy1;
     
    xcf2 = xcf1-oxc1;
    ycf2 = ycf1-oyc1;
       
    F1 = @(a1,xf2)a1(1)*xf2 + a1(2);
    a10 = [1 1];
    a1 = lsqcurvefit(F1,a10,xf2,yf2,[],[],options);     % added last 3 inputs
    
    theta2 = atan(a1(1));
   
    M2 = [xf2 yf2]*[cos(theta2),-sin(theta2);sin(theta2),cos(theta2)];
    Mc2 = [xcf2 ycf2]*[cos(theta2),-sin(theta2);sin(theta2),cos(theta2)];
    
    xf3 = M2(:,1);
    yf3 = M2(:,2);
     
    xcf3 = Mc2(:,1);
    ycf3 = Mc2(:,2);
    
    ox2=repmat(xf3(1),1,length(xf3))';
    oy2=repmat(ycf3(1),1,length(yf3))';
    
    oxc2=repmat(xf3(1),1,length(xcf3))';
    oyc2=repmat(ycf3(1),1,length(ycf3))';
    
    xf4 = xf3-ox2;
    yf4 = yf3-oy2;
    
    yLr(k,:)=yf4'; 
    
    xf4p = xf4(2:end-1);
    yf4p = yf4(2:end-1);
    
    xcf4 = xcf3-oxc2;
    ycf4 = ycf3-oyc2;
    
a01i=0.5;
a02i=1;
a03i=0.5;

    
    F2 = @(a2,xf4p)a2(1)*sin(2*pi*((a2(2)*xf4p) + a2(3)));
    a20 = [a01i a02i a03i];
    [a2,resnorm,residual] = lsqcurvefit(F2,a20,xf4p,yf4p,[],[],options);    % added last 3 inputs
    
chisqr=sum((residual/std(yf4p)).^2)/(3);    

RLr(k,:)=[t(k) abs(1/a2(2)) abs(a2(2)) abs(a2(1)) chisqr];      
    
    
if ktf(k)==1

    plot(xcf4,ycf4,'ko','LineWidth',2);

else
    plot(xf4,yf4,'ro','LineWidth',2);
    
    hold on
    plot(xcf4,ycf4,'ko','LineWidth',2);
    hold off
        
    hold on
    plot(xf4,F2(a2,xf4),'b-','LineWidth',1);
    hold off    
end    
 axis([0 1.2 -0.2 0.2]);    
 title('Sine Fitting')
xlabel('X-position (mm)');
ylabel('Y-position (mm)');    
set(gca,'fontsize',13)
 writeVideo(aviobj,getframe(gcf));  

  drawnow;
end
  close(aviobj);

Datarr2 = RLr;
Datay = yLr;

offs=round(fwin*fps);
YF=zeros(offs+1,frames-offs);
RF=zeros(frames-offs,segments-2);

for i= 2:segments-1
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

RF(j,i-1)= abs(frq); 

end


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RFA= mean(RF,2);
FRQ = mean(RFA)*ones(1,frames)';
for m=1:length(RFA)
FRQ(round(offs/2)+m) = RFA(m);
end

Datarf2 = FRQ;

t=t-t(1);

amp=Datarr2(:,4);

ws=Datarf2./Datarr2(:,3);


Vxcm=zeros(1,length(t));
Vycm=zeros(1,length(t));

sxcm=smooth(xc,31,'sgolay',1);
sycm=smooth(yc,31,'sgolay',1);

for f=2:length(t)-1
    
    Vxcm(f)=(sxcm(f+1,1)-sxcm(f-1,1))/(2*tau);
    Vycm(f)=(sycm(f+1,1)-sycm(f-1,1))/(2*tau);
    
end

 Vc=sqrt(Vxcm.^2+Vycm.^2);

 SVC = abs(smooth(Vc,'rlowess'));
 SWS = abs(smooth(ws,'rlowess'));
 SA = abs(smooth(amp,'rlowess'));

chi=mean(Datarr2(:,5));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
degreesTable=zeros(frames,1);
for k=1:frames
    degreeSin=sin((Y(k,2)-Y(k,segments-2))/(X(k,2)-X(k,segments-2))); 
    degreesTable(k)=degreeSin*57.2958;
end




figure('units','pixels','outerposition',[0 0 512+16 512+92]);
aviobj = VideoWriter(['2Detw' num2str(wn) 'v4a.avi']);
open(aviobj);
for j = 1:frames-1


plot(t,degreesTable,'r-','LineWidth',3);
   
axis([t(1) t(end) -90 90]);

title(['Bearing Angle' num2str(mean(degreesTable))])
xlabel('time(s)')
ylabel('Degrees') 
set(gca,'fontsize',13)


writeVideo(aviobj,getframe(gcf));  
   drawnow;
end
    close(aviobj);


figure('units','pixels','outerposition',[0 0 512+16 512+92]);
aviobj = VideoWriter(['2Detw' num2str(wn) 'v2a.avi']);
open(aviobj);
for j = 1:frames-1


plot(t,SWS,'r-','LineWidth',3);
   
axis([t(1) t(end) 0 1]);

title(['Sine Fit - Reduced Chi Squared = ' num2str(chi)])
xlabel('time(s)')
ylabel('Wave Speed (mm/s)') 
set(gca,'fontsize',13)


writeVideo(aviobj,getframe(gcf));  
   drawnow;
end
    close(aviobj);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xc=xc-xc(1);
yc=yc-yc(1);
ff=frames-1;


mm=max([max(abs(xc(1:ff))) max(abs(yc(1:ff)))])+0.1;

figure('units','pixels','outerposition',[0 0 512+16 512+92]);
aviobj = VideoWriter(['2Detw' num2str(wn) 'v3a.avi']);
open(aviobj);
for j = 1:ff
hold on
plot([-mm mm],[0 0],'k--','LineWidth',1);
plot([0 0],[-mm mm],'k--','LineWidth',1);
hold off
    
hold on   

plot(xc(j:j+1),yc(j:j+1),'-','Color',co(j,:),'LineWidth',2);

axis([-mm mm -mm mm]);
title('Position')
xlabel('X (mm)')
ylabel('Y (mm)') 
set(gca,'fontsize',12)


writeVideo(aviobj,getframe(gcf));  
   drawnow;
end
    close(aviobj);    
    
Vxc=zeros(1,length(t));
Vyc=zeros(1,length(t));

sxc=smooth(xc,31,'sgolay',1);
syc=smooth(yc,31,'sgolay',1);


for f=2:length(t)-1
    
    Vxc(f)=(sxc(f+1,1)-sxc(f-1,1))/(2*tau);
    Vyc(f)=(syc(f+1,1)-syc(f-1,1))/(2*tau);
    
end
    
mmv=max([max(abs(Vxc(1:ff))) max(abs(Vyc(1:ff)))])+0.1;

figure('units','pixels','outerposition',[0 0 512+16 512+92]);
aviobj = VideoWriter(['2Detw' num2str(wn) 'v4.avi']);
open(aviobj);
for j = 1:ff
hold on
plot([-mmv mmv],[0 0],'k--','LineWidth',1);
plot([0 0],[-mmv mmv],'k--','LineWidth',1);
hold off
    
hold on    

plot(Vxc(j:j+1),Vyc(j:j+1),'-','Color',co(j,:),'LineWidth',2);

axis([-mmv mmv -mmv mmv]);
title('Velocity')
xlabel('V_X (mm/s)')
ylabel('V_Y (mm/s)') 
set(gca,'fontsize',12)



writeVideo(aviobj,getframe(gcf));  
   drawnow;
end
    close(aviobj);    

Axc=zeros(1,length(t));
Ayc=zeros(1,length(t));

sVxc=smooth(Vxc,31,'sgolay',1);
sVyc=smooth(Vyc,31,'sgolay',1);


for f=2:length(t)-1
    
    Axc(f)=(sVxc(f+1,1)-sVxc(f-1,1))/(2*tau);
    Ayc(f)=(sVyc(f+1,1)-sVyc(f-1,1))/(2*tau);
    
end
    
mmva=max([max(abs(Axc(1:ff))) max(abs(Ayc(1:ff)))])+0.1;

    
figure('units','pixels','outerposition',[0 0 512+16 512+92]);
aviobj = VideoWriter(['2Detw' num2str(wn) 'v5.avi']);
open(aviobj);
for j = 1:ff
hold on
plot([-mmva mmva],[0 0],'k--','LineWidth',1);
plot([0 0],[-mmva mmva],'k--','LineWidth',1);
hold off
    
hold on    

plot(Axc(j:j+1),Ayc(j:j+1),'-','Color',co(j,:),'LineWidth',2);




axis([-mmva mmva -mmva mmva]);
title('Acceleration')
xlabel('A_X (mm/s)')
ylabel('A_Y (mm/s)') 
set(gca,'fontsize',12)


writeVideo(aviobj,getframe(gcf));  
   drawnow;
end
    close(aviobj);   
    cd(oldfolder)   % added

 end