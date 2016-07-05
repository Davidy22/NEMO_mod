function WormTraceFitting3D(filename, fname, frames, fps, segments,AvgV,AvgVh,Vc)
% [afile apath aindex] = uigetfile('*.xlsx');
% ListStr = {'2DFreeMotion';'3DFreeMotion';'Electrotaxis';'Phototaxis';'Reflex';'Thermotaxis'};
% [GSelect,okG] = listdlg('PromptString','Select a file:','SelectionMode','single','ListString',ListStr);
% 
% GFolder= ListStr(GSelect)

 tic
filex = 'wTfit_x3.csv';
filey = 'wTfit_y3.csv';
filez = 'wTfit_z3.csv';
filear = 'wTfit_r3.csv';
filexh = 'wTfit_x_h3.csv';
fileyh = 'wTfit_y_h3.csv';
filezh = 'wTfit_y_h3.csv';
filearh = 'wTfit_r_h3.csv';
filea = 'wTfit_R_13.csv';
filea2 = 'wTfit_R_23.csv';
filea3 = 'wTfit_R_33.csv';
filea4 = 'wTfit_R_43.csv';
% filef = 'wTfit_f.csv';
filef2 = 'wTfit_f_23.csv';
filefh2 = 'wTfit_f_h_23.csv';

D = xlsread(filename);

X = zeros(frames,segments);
Y = zeros(frames,segments);
Z = zeros(frames,segments);

for j = 1:segments+1
    X(:,j) = D(:,(3*j)+1);
    Y(:,j) = D(:,(3*j)+2);
    Z(:,j) = D(:,(3*j)+3);
end

xc = X(:,1);
yc = Y(:,1);   
zc = Z(:,1);   
t = D(:,2);
x1=X(:,2);
y1=Y(:,2);
z1=Z(:,2);

for k = 1:frames
 
% subplot(1,2,1)
% plot3(x1,y1,z1);
% 
% hold on
% plot3(xc,yc,zc);
% hold off
% 
% hold on
% plot3(xc(k),yc(k),zc(k),'ro');
% hold off

x=X(k,2:segments+1)';
y=Y(k,2:segments+1)';
z=Z(k,2:segments+1)';

% hold on
% plot3(x,y,z,'g-o');
% hold off
% 
% 
% axis([min(xc)-0.3 max(xc)+0.3 min(yc)-0.3 max(yc)+0.3 min(zc)-0.3 max(zc)+0.3]);
% 
% xlabel('X-position (mm)')
% ylabel('Y-position (mm)')
% zlabel('Z-position (mm)')
%     
      if z(1)>zc(k)
          thetax = pi+atan((yc(k)-y(1))/(zc(k)-z(1)));
          thetay = pi+atan((xc(k)-x(1))/(zc(k)-z(1)));
        else
        thetax = atan((yc(k)-y(1))/(zc(k)-z(1)));
        thetay = atan((xc(k)-x(1))/(zc(k)-z(1)));
      end
      
      
    M1 = [x y z]*[1,0,0;0,cos(thetax),sin(thetax);0,-sin(thetax),cos(thetax)]*[cos(thetay),0,sin(thetay);0,1,0;-sin(thetay),0,cos(thetay)];
    Mc = [xc(k) yc(k) zc(k)]*[1,0,0;0,cos(thetax),sin(thetax);0,-sin(thetax),cos(thetax)]*[cos(thetay),0,sin(thetay);0,1,0;-sin(thetay),0,cos(thetay)];
    
    
    xf1 = M1(:,1);
    yf1 = M1(:,2);
    zf1 = M1(:,3);
    
     
    xcf1 = Mc(:,1);
    ycf1 = Mc(:,2);
    zcf1 = Mc(:,3);
    
    ox1=repmat(xf1(1),1,length(xf1))';
    oy1=repmat(yf1(1),1,length(yf1))';
    oz1=repmat(zf1(1),1,length(zf1))';
    
    oxc1=repmat(xf1(1),1,length(xcf1))';
    oyc1=repmat(yf1(1),1,length(ycf1))';
    ozc1=repmat(zf1(1),1,length(zcf1))';
    
    
    xf2 = xf1-ox1;
    yf2 = yf1-oy1;
    zf2 = zf1-oz1;
    if xf2<0
        rf2 = -abs(sqrt(xf2.^2 + yf2.^2));
    else
        rf2 = abs(sqrt(xf2.^2 + yf2.^2));
    end
    
    if k==1
        dlmwrite(filex,xf2');
        dlmwrite(filey,yf2');
        dlmwrite(filez,zf2');
        dlmwrite(filear,rf2');
    else
        dlmwrite(filex,xf2','-append');
        dlmwrite(filey,yf2','-append');
        dlmwrite(filez,zf2','-append');
        dlmwrite(filear,rf2','-append');
    end
    
    xcf2 = xcf1-oxc1;
    ycf2 = ycf1-oyc1;
    zcf2 = zcf1-ozc1;
    
% subplot(1,2,2)
%     plot3(xf2,yf2,zf2,'o');
%     
%     hold on
%     plot3(xcf2,ycf2,zcf2,'ro');
%     hold off
    
    xf2p = xf2(2:length(xf2)-1)';
    yf2p = yf2(2:length(yf2)-1)';
    zf2p = zf2(2:length(zf2)-1)';
   
    
    F2y = @(a2y,zf2p)a2y(1)*sin(2*pi*((a2y(2)*zf2p) + a2y(3)));
    a2y0 = [1 1 1];
    [a2y,resnormy,residualy] = lsqcurvefit(F2y,a2y0,zf2p,yf2p);
    
    F2x = @(a2x,zf2p)a2x(1)*sin(2*pi*((a2y(2)*zf2p) + a2y(3)));
    a2x0 = [1];
    [a2x,resnormx,residualx] = lsqcurvefit(F2x,a2x0,zf2p,xf2p);
    
%     hold on
%     plot3(F2x(a2x,zf2p),F2y(a2y,zf2p),zf2p);
%     hold off
% 
%     axis([-0.25 0.25 -0.25 0.25 0 1]);
%     
% xlabel('X-position (mm)');
% ylabel('Y-position (mm)');
% zlabel('Z-position (mm)');


L=0;
  for i = 1:length(x)-1
  L = abs(sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2 + (z(i)-z(i+1))^2)) + L;
  end

    chisqr=0.5+(sum((residualy/std(yf2p)).^2)/(segments-6)+sum((residualx/std(xf2p)).^2)/(segments-4));

R=[abs(a2y(1)) abs(a2x(1)) abs(a2y(2)) abs(a2y(1)/L) abs(L*a2y(2)) L chisqr];
    
    if k==1
        dlmwrite(filea,R);
    else
        dlmwrite(filea,R,'-append');
    end

RL=[t(k) abs(1/a2y(2))];
%         if RL(2)>(0.5*L) && RL(2)<(5*L)
    if k==1
        dlmwrite(filea2,RL);
    else
        dlmwrite(filea2,RL,'-append');
    end
%         end
        
RA=[t(k) abs(sqrt(a2x(1).^2 + a2y(1).^2))];
%         if RA(2)<(0.5*L)
    if k==1
        dlmwrite(filea3,RA);
    else
        dlmwrite(filea3,RA,'-append');
    end
%         end        
        
RC=[t(k) chisqr];
%     if RC(2)<5  
    if k==1
        dlmwrite(filea4,RC);
    else
        dlmwrite(filea4,RC,'-append');
    end
%     end 
        
%  pause(1/fps)
%  drawnow
  end

Datam = csvread(filea);
Datam2 = csvread(filea2);
Datam3 = csvread(filea3);
Datam4 = csvread(filea4);
Datay = csvread(filey);
Datar = csvread(filear);


% for i = 2:segments-1
% L = frames;
% NFFT = 2^nextpow2(L); 
% d2w = fft(Datay(:,i),NFFT)/L;
% tinter = 1/fps;
% f = 1/tinter/2*linspace(0,1,NFFT/2+1);
% % figure
% % plot(f,2*abs(d2w(1:NFFT/2+1))) 
% % xlabel('Frequency (Hz)')
% % ylabel('|d2w(f)|')
% 
% [pks , locs] = findpeaks(2*abs(d2w(1:NFFT/2+1)),f);
% frq = 0;
% weight = 0;
% for k = 1 : length(pks)
% 
% 
%     if weight <= pks(k)
%         weight = pks(k);
%         frq = locs(k);
%     end
% end
% if i==2
%         dlmwrite(filef,frq);
%     else
%         dlmwrite(filef,frq,'-append');
%     end
% 
% end


% Dataf = csvread(filef);

offs=5*fps;
YF=zeros(offs+1,frames-offs);
RF=zeros(frames-offs,3);
mid = round(segments/2);
for i= mid-1:mid+1
for k=1:frames-offs

    YF(:,k) = Datar(k:k+offs,i);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for j= 1:frames-offs
% %    YFS= smooth(YF(:,j))-smooth(YF(1,j));
%    YFS= YF(:,j);
%    tf= t(j-1+round(offs/2)):1/fps:t(j-1+round(offs/2))+((length(YFS)-1)/fps);
%    tfp=tf'-tf(1);
% %    size(tfp)
% %    size(YFS)
% a1i=abs(max(YFS)-min(YFS))/2;
% a2i=1/abs(max(tfp)-min(tfp));
% a3i=0;
% a4i=mean(YFS);
% 
%    F3 = @(a3,tfp)a3(1)*sin(2*pi*((a3(2)*tfp) + a3(3)))+a3(4);
%     a30 = [a1i a2i a3i a4i];
%     a3 = lsqcurvefit(F3,a30,tfp,YFS);
%     
% %     subplot(3,2,2);
% %     plot(tfp,YFS,'o');
% %      hold on
% %     plot(tfp,F3(a3,tfp));
% %     hold off
% %     
% %     axis([0 ((length(YFS)-1)/fps) -0.25 0.25]);
% %     
% % xlabel('t (s)')
% % ylabel('Y-position (mm)')
%     
%     RF(j,2+i-mid)= abs(a3(2)); 
%    
% %      drawnow;
% end
% 
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for j= 1:frames-offs
L = frames-offs;
NFFT = 2^nextpow2(L); 
d2w = fft(YF(:,j),NFFT)/L;
tinter = 1/fps;
f = 1/tinter/2*linspace(0,1,NFFT/2+1);
% figure
% plot(f,2*abs(d2w(1:NFFT/2+1))) 
% xlabel('Frequency (Hz)')
% ylabel('|d2w(f)|')

[pks , locs] = findpeaks(2*abs(d2w(1:NFFT/2+1)),f);
frq = 0;
weight = 0;
for k = 1 : length(pks)


    if weight <= pks(k)
        weight = pks(k);
        frq = locs(k);
    end
end

RF(j,2+i-mid)= abs(frq); 

end


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RFA= mean(RF,2);
dlmwrite(filef2,RFA);
Dataf2 = csvread(filef2);


for k=1:frames
x=X(k,2:segments+1)';
y=Y(k,2:segments+1)';
z=Z(k,2:segments+1)';

 if z(3)>z(4)
          thetax = pi+atan((y(4)-y(3))/(z(4)-z(3)));
          thetay = pi+atan((x(4)-x(3))/(z(4)-z(3)));
 else
          thetax = atan((y(4)-y(3))/(z(4)-z(3)));
          thetay = atan((x(4)-x(3))/(z(4)-z(3)));
      end
      
      
    M1h = [x y z]*[1,0,0;0,cos(thetax),sin(thetax);0,-sin(thetax),cos(thetax)]*[cos(thetay),0,sin(thetay);0,1,0;-sin(thetay),0,cos(thetay)];
    Mch = [x(4) y(4) z(4)]*[1,0,0;0,cos(thetax),sin(thetax);0,-sin(thetax),cos(thetax)]*[cos(thetay),0,sin(thetay);0,1,0;-sin(thetay),0,cos(thetay)];
    
    
    xf1h = M1h(:,1);
    yf1h = M1h(:,2);
    zf1h = M1h(:,3);
    
     
    xcf1h = Mch(:,1);
    ycf1h = Mch(:,2);
    zcf1h = Mch(:,3);
    
    ox1h=repmat(xf1h(3),1,length(xf1h))';
    oy1h=repmat(yf1h(3),1,length(yf1h))';
    oz1h=repmat(zf1h(3),1,length(zf1h))';
    
    oxc1h=repmat(xf1h(3),1,length(xcf1h))';
    oyc1h=repmat(yf1h(3),1,length(ycf1h))';
    ozc1h=repmat(zf1h(3),1,length(zcf1h))';
    
    
    xf2h = xf1h-ox1h;
    yf2h = yf1h-oy1h;
    zf2h = zf1h-oz1h;
    
    if xf2<0
        rf2h = -abs(sqrt(xf2h.^2 + yf2h.^2));
    else
        rf2h = abs(sqrt(xf2h.^2 + yf2h.^2));
    end
    
    if k==1
        dlmwrite(filexh,xf2h');
        dlmwrite(fileyh,yf2h');
        dlmwrite(filezh,zf2h');
        dlmwrite(filearh,rf2h');
    else
        dlmwrite(filexh,xf2h','-append');
        dlmwrite(fileyh,yf2h','-append');
        dlmwrite(filezh,zf2h','-append');
        dlmwrite(filearh,rf2h','-append');
    end
    
    xcf2h = xcf1h-oxc1h;
    ycf2h = ycf1h-oyc1h;
    zcf2h = zcf1h-ozc1h;    
 
%     plot(xf2n,yf2n,'o');
%     
%     hold on
%     plot(xcf2n,ycf2n,'ro');
%     hold off
%     
%     axis([-0.5 1 -0.25 0.25]);
%     
% xlabel('X-position (mm)');
% ylabel('Y-position (mm)');
% 
% drawnow;
end

Datayh=csvread(fileyh);
Datarh=csvread(filearh);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% % Lh = frames;
% % NFFTh = 2^nextpow2(Lh); 
% % d2wh = fft(Datayh(:,1),NFFTh)/Lh;
% % tinterh = 1/fps;
% % fh = 1/tinterh/2*linspace(0,1,NFFTh/2+1);
% % % figure
% % % plot(f,2*abs(d2w(1:NFFT/2+1))) 
% % % xlabel('Frequency (Hz)')
% % % ylabel('|d2w(f)|')
% % 
% % [pksh , locsh] = findpeaks(2*abs(d2wh(1:NFFTh/2+1)),fh);
% % frqh = 0;
% % weighth = 0;
% % for k = 1 : length(pksh)
% % 
% % 
% %     if weighth <= pksh(k)
% %         weighth = pksh(k);
% %         frqh = locsh(k);
% %     end
% % end

YFh=zeros(offs+1,1);

for j=1:frames-offs

    YFh(:,j) = Datarh(j:j+offs,1);
    
end

for j= 1:frames-offs
% %    YFS= smooth(YF(:,j))-smooth(YF(1,j));
%    YFSh= YFh(:,j);
%    tfh= t(j-1+round(offs/2)):1/fps:t(j-1+round(offs/2))+((length(YFSh)-1)/fps);
%    tfph=tfh'-tfh(1);
% %    size(tfp)
% %    size(YFS)
% a1ih=abs(max(YFSh)-min(YFSh))/2;
% a2ih=1/abs(max(tfph)-min(tfph));
% a3ih=0;
% a4ih=mean(YFSh);
% 
%    F4 = @(a4,tfph)a4(1)*sin(2*pi*((a4(2)*tfph) + a3(3)))+a4(4);
%     a40 = [a1ih a2ih a3ih a4ih];
%     a4 = lsqcurvefit(F4,a40,tfph,YFSh);
%     
%     
%     
%     
%     plot(tfph,YFSh,'o');
%     
%     hold on
%     plot(tfph,F4(a4,tfph));
%     hold off
%     
% %     axis([t(j-1+round(offs/2)) t(j-1+round(offs/2))+((length(YFSh)-1)/fps)  -0.25 0.25]);
%     
% xlabel('t (s)')
% ylabel('Y-position (mm)')
% 
% drawnow;
%     
%     rhf=[abs(a4(1)) abs(a4(2))];
%     if j==1
%          dlmwrite(filefh2,rhf);
%      else
%          dlmwrite(filefh2,rhf,'-append');
%     end
%    
% 
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Lh = frames-offs;
NFFTh = 2^nextpow2(Lh); 
d2wh = fft(YFh(:,j),NFFTh)/Lh;
tinterh = 1/fps;
fh = 1/tinterh/2*linspace(0,1,NFFTh/2+1);
% figure
% plot(f,2*abs(d2w(1:NFFT/2+1))) 
% xlabel('Frequency (Hz)')
% ylabel('|d2w(f)|')

[pksh , locsh] = findpeaks(2*abs(d2wh(1:NFFTh/2+1)),fh);
frqh = 0;
weighth = 0;
for k = 1 : length(pksh)


    if weighth <= pksh(k)
        weighth = pksh(k);
        frqh = locsh(k);
    end
end

     rhf=abs(frqh);     

     if j==1
         dlmwrite(filefh2,rhf);
     else
         dlmwrite(filefh2,rhf,'-append');
     end
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Datafh2=csvread(filefh2);

if rem(offs,2)==0
    ws=Dataf2./Datam(round(offs/2):end-round(offs/2)-1,3);
else
    ws=Dataf2./Datam(round(offs/2):end-round(offs/2),3);
end


figure;
mt1=annotation('textbox', [0 0.9 1 0.1],'String', [fname ' Plots 2'],'EdgeColor', 'none','HorizontalAlignment', 'center');
mtfs1 = mt1.FontSize;
mt1.FontSize = 15;

subplot(3,2,2)
SW = abs(smooth(Datam2(:,2),'rlowess'));
plot(Datam2(:,1),SW,'-r','LineWidth',2);

axis([t(1) t(length(t)) min(SW) max(SW)]);
title('WaveLength vs time', 'FontSize', 12);    
xlabel('t (s)')
ylabel('\lambda (mm)')  
  
subplot(3,2,3)

plot(t,Datarh(:,1),'-b','LineWidth',1);
hold on
plot(t,Datar(:,round(segments/2)),'-r','LineWidth',2);
hold off

axis([t(1) t(length(t)) min([min(Datar(:,round(segments/2))),min(Datarh(:,1))]) max([max(Datar(:,round(segments/2))),max(Datarh(:,1))])]);
title('Local XY-position vs time', 'FontSize', 12);    
xlabel('t (s)')
ylabel('Y (mm)')  

subplot(3,2,4)
SFH = abs(smooth(Datafh2,'rlowess'));
SF = abs(smooth(Dataf2,'rlowess'));
plot(t(round(offs/2)):1/fps:t(round(offs/2))+((length(Datafh2)-1)/fps),SFH,'-b','LineWidth',1);

hold on
plot(t(round(offs/2)):1/fps:t(round(offs/2))+((length(Dataf2)-1)/fps),SF,'-r','LineWidth',2);
hold off

axis([t(1) t(length(t)) min([min(SF),min(SFH)]) max([max(SF),max(SFH)])]);
title('Frequency vs time', 'FontSize', 12);    
xlabel('t (s)')
ylabel('f (Hz)')  

subplot(3,2,1)
SA = abs(smooth(Datam3(:,2),'rlowess'));
 plot(Datam3(:,1),SA,'-r','LineWidth',2);

axis([t(1) t(length(t)) min(SA) max(SA)]);
title('Amplitude vs time', 'FontSize', 13);    
xlabel('t (s)')
ylabel('A (mm)')  

if rem(offs,2)==0
VC= Vc(round(offs/2):end-round(offs/2)-1);
else
VC= Vc(round(offs/2):end-round(offs/2));    
end

subplot(3,2,5)
SWS = abs(smooth(ws,'rlowess'));
SVC = abs(smooth(VC,'rlowess'));
plot(t(round(offs/2)):1/fps:t(round(offs/2))+((length(ws)-1)/fps),SWS,'-r','LineWidth',2);

% hold on
% plot(t(round(offs/2)):1/fps:t(round(offs/2))+((length(ws)-1)/fps),SVC,'-g','LineWidth',1);
% hold off

axis([t(1) t(length(t)) min(SWS) max(SWS)]);
title('Wave Speed vs time', 'FontSize', 12);    
xlabel('t (s)')
ylabel('v_w (mm/s)')  

G = VC./ws;

subplot(3,2,6)
SG = abs(smooth(G,'rlowess'));
plot(t(round(offs/2)):1/fps:t(round(offs/2))+((length(G)-1)/fps),SG,'-r','LineWidth',2);

axis([t(1) t(length(t)) min(SG) max(SG)]);
title('Efficiency Coeff. vs time', 'FontSize', 12);    
xlabel('t (s)')
ylabel('\gamma')  

% SC = smooth(Datam4(:,2),'rlowess');
%  plot(Datam4(:,1),SC,'-r','LineWidth',2);
% 
% axis([t(1) t(length(t)) min(SC) max(SC)]);
% title('Reduced Chi-Squared vs time', 'FontSize', 12);    
% xlabel('time (s)')
% ylabel('\chi_r^2')  



%  Amplitude = mean(Datam(:,1));
%  AmplitudePerLength = mean(Datam(:,4));
%  WaveLength= 1/mean(Datam(:,2));
%  WavelengthPerLength = 1/mean(Datam(:,5));
%  LengthOfWorm = mean(Datam(:,6));
 

  Amplitude = mean(SA);
 AmplitudePerLength = mean(abs(smooth(Datam(:,4),'rlowess')));
 WaveLength= mean(SW);
 WavelengthPerLength = 1/mean(abs(smooth(Datam(:,5),'rlowess')));
 LengthOfWorm = mean(abs(smooth(Datam(:,6),'rlowess')));
 
%  Frequency = mean(Dataf(:,1));
%  FrequencyH = frqh;
%  VelocityX = sum(vf(:,2))/abs(t(1)-t(length(t)));
%  VelocityY = sum(vf(:,3))/abs(t(1)-t(length(t)));
%  VelocityCM = sum(vf(:,1))/abs(t(1)-t(length(t)));
% VelocityWave = WaveLength*Frequency;
% gamma= AvgV/VelocityWave;



% ReduceChiSquare = mean(Datam4(:,2)); 
% AvgFreq = mean(abs(Dataf2));
% AvgFreqH = mean(abs(Datafh2));
% AvgWaveSpeed = mean(abs(ws));
% AvgGamma= mean(abs(G));

ReduceChiSquare = mean(abs(smooth(Datam4(:,2),'rlowess'))); 
AvgFreq = mean(SF);
AvgFreqH = mean(SFH);
AvgWaveSpeed = mean(SWS);
AvgGamma= mean(SG);

FreqRatio = AvgFreqH/AvgFreq;
SpeedRatio = AvgVh/AvgV;

% HSS=Datafh2(:,1).*Datafh2(:,2);
% 
% HeadSwingSpeed = mean(abs(HSS));

% cd ../
% cd('DataAnalysisResults')
% cd(GFolder)
% set(gcf,'PaperUnits','points','PaperPosition',[0,0,1280,720])
% saveas(gcf,['ResultPlots_' name],'tiff')
% cd ../
% cd ../
% cd(oldfolder)


figure;
mt2=annotation('textbox', [0 0.9 1 0.1],'String', [fname ' Results'],'EdgeColor', 'none','HorizontalAlignment', 'center');
mtfs2 = mt2.FontSize;
mt2.FontSize = 15;

ta=uitable('Position',[0 0 400 500],'FontSize',12,'Data', [LengthOfWorm;Amplitude;AmplitudePerLength;...
    WaveLength;WavelengthPerLength;AvgFreq;AvgWaveSpeed;AvgV;AvgFreqH;AvgVh;FreqRatio;SpeedRatio;AvgGamma;ReduceChiSquare],...
    'ColumnName', {'Average Values'},'RowName', {'Length Of Worm, L (mm)','Amplitude, A (mm)','A/L','WaveLength (mm)',...
    'WaveLength/L','Frequency, f (Hz)','Wave Speed, Vw (mm/s)','CM Speed, Vcm (mm/s)','Head Frequency, f_h (Hz)','Head Speed, Vh (mm/s)',...
    'Frequency Ratio, f_h/f','Speed Ratio, Vh/Vcm','Efficiency Coeff.','Reduced Chi-Square'},'FontSize',12); 
ta.Position(3) = ta.Extent(3);
ta.Position(4) = ta.Extent(4);

  dr = {'LengthOfWorm','Amplitude','Amp/L','WaveLength','WaveLen/L','Frequency','WaveSpeed',...
      'CM Speed','Head Frequency','Head Speed','HeadFreq/Freq','HeadSpeed/CMSpeed','EfficiencyCoeff','ReducedChiSquare';...
      LengthOfWorm,Amplitude,AmplitudePerLength,WaveLength,WavelengthPerLength,AvgFreq,AvgWaveSpeed,...
      AvgV,AvgFreqH,AvgVh,FreqRatio,SpeedRatio,AvgGamma,ReduceChiSquare};
  
  [rpath, rfile, rext] = fileparts(filename);
  newfile= strcat(rpath,rfile,'_Results',rext);
  xlswrite(newfile,dr);
  
% cd(folderName)
% cd ../
% mkdir('Standard Format')
% cd('Standard Format')
% set(gcf,'PaperUnits','points','PaperPosition',[0,0,1280,720])
% saveas(gcf,['StandardFormat_' name],'tiff')
% cd(oldfolder)
toc
 