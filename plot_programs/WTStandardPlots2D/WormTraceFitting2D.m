function WormTraceFitting2D(filename, fname, frames, fps, segments,AvgV,AvgVh,Vc,mm)
% [afile apath aindex] = uigetfile('*.xlsx');
% ListStr = {'2DFreeMotion';'3DFreeMotion';'Electrotaxis';'Phototaxis';'Reflex';'Thermotaxis'};
% [GSelect,okG] = listdlg('PromptString','Select a file:','SelectionMode','single','ListString',ListStr);
% 
% GFolder= ListStr(GSelect)

% tic
filex = 'wTfit_x.csv';
filey = 'wTfit_y.csv';
filex2 = 'wTfit_x2.csv';
filey2 = 'wTfit_y2.csv';
filexh = 'wTfit_x_h.csv';
fileyh = 'wTfit_y_h.csv';
filea = 'wTfit_R_1.csv';
filea2 = 'wTfit_R_2.csv';
filea3 = 'wTfit_R_3.csv';
filea4 = 'wTfit_R_4.csv';
% filef = 'wTfit_f.csv';
filef2 = 'wTfit_f_2.csv';
filefh2 = 'wTfit_f_h_2.csv';
fileres = 'wTfit_Res.csv';

D = xlsread(filename);

X = zeros(frames,segments);
Y = zeros(frames,segments);

for j = 1:segments+1
    X(:,j) = D(:,(2*j)+2);
    Y(:,j) = D(:,(2*j)+3);
end

xc = X(:,1);
yc = Y(:,1);   
t = D(:,2);
% x1=X(:,2);
% y1=Y(:,2);

for k = 1:frames
 
% subplot(3,2,1)
% plot(x1,y1);
% 
% hold on
% plot(xc,yc);
% hold off
% 
% hold on
% plot(xc(k),yc(k),'ro');
% hold off

x=X(k,2:segments+1)';
y=Y(k,2:segments+1)';

% hold on
% plot(x,y,'g-o');
% hold off


% axis([min(xc)-0.3 max(xc)+0.3 min(yc)-0.3 max(yc)+0.3]);
% 
% xlabel('X-position (mm)')
% ylabel('Y-position (mm)')
    
%       if x(1)>xc(k)
%           theta = pi+atan((yc(k)-y(1))/(xc(k)-x(1)));
%         else
%         theta = atan((yc(k)-y(1))/(xc(k)-x(1)));
%       end
%     M1 = [x y]*[cos(theta),-sin(theta);sin(theta),cos(theta)];
%     Mc = [xc(k) yc(k)]*[cos(theta),-sin(theta);sin(theta),cos(theta)];
%     
%     xf1 = M1(:,1);
%     yf1 = M1(:,2);
%      
%     xcf1 = Mc(:,1);
%     ycf1 = Mc(:,2);
%     
%     ox1=repmat(xf1(1),1,length(xf1))';
%     oy1=repmat(yf1(1),1,length(yf1))';
%     
%     oxc1=repmat(xf1(1),1,length(xcf1))';
%     oyc1=repmat(yf1(1),1,length(ycf1))';
%     
%     xf2 = xf1-ox1;
%     yf2 = yf1-oy1;
%     
%     if k==1
%         dlmwrite(filex,xf2');
%         dlmwrite(filey,yf2');
%     else
%         dlmwrite(filex,xf2','-append');
%         dlmwrite(filey,yf2','-append');
%     end
%     
%     xcf2 = xcf1-oxc1;
%     ycf2 = ycf1-oyc1;
%     
% % subplot(3,2,1)
% %     plot(xf2,yf2,'o');
% %     
% %     hold on
% %     plot(xcf2,ycf2,'ro');
% %     hold off
%     
%     xf2p = xf2(2:length(xf2)-1)';
%     yf2p = yf2(2:length(yf2)-1)';
%    
% % a01i=abs(max(yf2p)-min(yf2p))/2;
% % a02i=1/abs(max(xf2p)-min(xf2p));
% % a03i=0;
% 
% a01i=1;
% a02i=1;
% a03i=1;
% 
%     
%     F2 = @(a2,xf2p)a2(1)*sin(2*pi*((a2(2)*xf2p) + a2(3)));
%     a20 = [a01i a02i a03i];
%     [a2,resnorm,residual] = lsqcurvefit(F2,a20,xf2p,yf2p);
    
%     hold on
%     plot(xf2p,F2(a2,xf2p));
%     hold off

%     axis([0 1 -0.25 0.25]);
%     
% xlabel('X-position (mm)');
% ylabel('Y-position (mm)');

% xx = linspace(xf2(1),xf2(end),2*segments);
% pp = spline(xf2,yf2);
% yy = ppval(pp,xx);

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
    
    if k==1
        dlmwrite(filex,xf2');
        dlmwrite(filey,yf2');
    else
        dlmwrite(filex,xf2','-append');
        dlmwrite(filey,yf2','-append');
    end
    
    xcf2 = xcf1-oxc1;
    ycf2 = ycf1-oyc1;
    
    
%     xf2p = xf2(2:length(xf2)-1)';
%     yf2p = yf2(2:length(yf2)-1)';
   
    F1 = @(a1,xf2)a1(1)*xf2 + a1(2);
    a10 = [1 1];
    a1 = lsqcurvefit(F1,a10,xf2,yf2);
    

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
    
    if k==1
        dlmwrite(filex2,xf4');
        dlmwrite(filey2,yf4');
    else
        dlmwrite(filex2,xf4','-append');
        dlmwrite(filey2,yf4','-append');
    end
    
    xcf4 = xcf3-oxc2;
    ycf4 = ycf3-oyc2;
    
    

a01i=1;
a02i=1;
a03i=1;

    
    F2 = @(a2,xf4)a2(1)*sin(2*pi*((a2(2)*xf4) + a2(3)));
    a20 = [a01i a02i a03i];
    [a2,resnorm,residual] = lsqcurvefit(F2,a20,xf4,yf4);

L=0;
  for i = 1:length(x)-1
  L = sqrt((x(i)-x(i+1))^2 + (y(i)-y(i+1))^2) + L;
  end

  
  
   chisqr=sum((residual/std(yf4)).^2)/(segments-6);

R=[abs(a2(1)) abs(a2(2)) abs(a2(3)) abs(a2(1)/L) abs(L*a2(2)) L chisqr];
    
    if k==1
        dlmwrite(filea,R);
    else
        dlmwrite(filea,R,'-append');
    end

RL=[t(k) abs(1/a2(2))];
 %        if RL(2)>(0.5*L) && RL(2)<(5*L)
    if k==1
        dlmwrite(filea2,RL);
    else
        dlmwrite(filea2,RL,'-append');
    end
 %        end
        
RA=[t(k) abs(a2(1))];
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

offs=4*fps;
YF=zeros(offs+1,frames-offs);
RF=zeros(frames-offs,segments-2);
mid = round(segments/2);
for i= 2:segments-1
for k=1:frames-offs

    YF(:,k) = Datay(k:k+offs,i);
    
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

RF(j,i-1)= abs(frq); 

end


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RFA= mean(RF,2);
dlmwrite(filef2,RFA);
Dataf2 = csvread(filef2);

for k=1:frames
x=X(k,2:segments+1)';
y=Y(k,2:segments+1)';
if x(3)>x(4)
          theta2 = pi+atan((y(4)-y(3))/(x(4)-x(3)));
        else
        theta2 = atan((y(4)-y(3))/(x(4)-x(3)));
        end
    M1n = [x y]*[cos(theta2),-sin(theta2);sin(theta2),cos(theta2)];
    Mcn = [x(4) y(4)]*[cos(theta2),-sin(theta2);sin(theta2),cos(theta2)];
    
    xf1n = M1n(:,1);
    yf1n = M1n(:,2);
     
    xcf1n = Mcn(:,1);
    ycf1n = Mcn(:,2);
    
    ox1n=repmat(xf1n(3),1,length(xf1n))';
    oy1n=repmat(yf1n(3),1,length(yf1n))';
    
    oxc1n=repmat(xf1n(3),1,length(xcf1n))';
    oyc1n=repmat(yf1n(3),1,length(ycf1n))';
    
    xf2n = xf1n-ox1n;
    yf2n = yf1n-oy1n;
    
    if k==1
        dlmwrite(filexh,xf2n');
        dlmwrite(fileyh,yf2n');
    else
        dlmwrite(filexh,xf2n','-append');
        dlmwrite(fileyh,yf2n','-append');
    end
    
    xcf2n = xcf1n-oxc1n;
    ycf2n = ycf1n-oyc1n;
    
 
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

    YFh(:,j) = Datayh(j:j+offs,1);
    
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
    ws=Dataf2.*Datam2(round(offs/2):end-round(offs/2)-1,2);
else
    ws=Dataf2.*Datam2(round(offs/2):end-round(offs/2),2);
end    


figure;
mt1=annotation('textbox', [0 0.9 1 0.1],'String', [fname ' Plots 2'],'EdgeColor', 'none','HorizontalAlignment', 'center');
mtfs1 = mt1.FontSize;
mt1.FontSize = 15;

subplot(3,2,2)
SW = abs(smooth(Datam2(:,2),'rlowess'));
%  SW=filter((1/offs)*ones(1,offs),1,Datam2(:,2));
plot(Datam2(:,1),SW,'-r','LineWidth',2);


% axis([t(1) t(length(t)) min(SW) max(SW)]);
axis([t(1) t(length(t)) 0 1]);
title('WaveLength vs time', 'FontSize', 12);    
xlabel('t (s)')
ylabel('\lambda (mm)')  
  
subplot(3,2,3)

plot(t,Datayh(:,1),'-b','LineWidth',1);
hold on
plot(t,Datay(:,round(segments/2)),'-r','LineWidth',2);
hold off

axis([t(1) t(length(t)) min([min(Datay(:,round(segments/2))),min(Datayh(:,1))]) max([max(Datay(:,round(segments/2))),max(Datayh(:,1))])]);
title('Local Y-position vs time', 'FontSize', 12);    
xlabel('t (s)')
ylabel('Y (mm)')  

subplot(3,2,4)
SFH = abs(smooth(Datafh2,'rlowess'));
SF = abs(smooth(Dataf2,'rlowess'));
plot(t(round(offs/2)):1/fps:t(round(offs/2))+((length(Datafh2)-1)/fps),SFH,'-b','LineWidth',1);

hold on
plot(t(round(offs/2)):1/fps:t(round(offs/2))+((length(Dataf2)-1)/fps),SF,'-r','LineWidth',2);
hold off

axis([t(1) t(length(t)) 0 1]);
title('Frequency vs time', 'FontSize', 12);    
xlabel('t (s)')
ylabel('f (Hz)')  

subplot(3,2,1)
SA = abs(smooth(Datam3(:,2),'rlowess'));
 plot(Datam3(:,1),SA,'-r','LineWidth',2);

% axis([t(1) t(length(t)) min(SA) max(SA)]);
axis([t(1) t(length(t)) 0 0.5]);
title('Amplitude vs time', 'FontSize', 13);    
xlabel('t (s)')
ylabel('A (mm)')  

if rem(offs,2)==0
    VC= abs(Vc(round(offs/2):end-round(offs/2)-1));
else
    VC= abs(Vc(round(offs/2):end-round(offs/2)));
end    

subplot(3,2,5)
SWS = abs(smooth(ws,'rlowess'));
SVC = abs(smooth(VC,'rlowess'));
plot(t(round(offs/2)):1/fps:t(round(offs/2))+((length(ws)-1)/fps),SWS,'-r','LineWidth',2);

hold on
plot(t(round(offs/2)):1/fps:t(round(offs/2))+((length(ws)-1)/fps),SVC,'-g','LineWidth',1);
hold off

% axis([t(1) t(length(t)) min(SWS) max(SWS)]);
axis([t(1) t(length(t)) 0 1]);
title('Wave Speed vs time', 'FontSize', 12);    
xlabel('t (s)')
ylabel('v_w (mm/s)')  

G = VC./ws;

subplot(3,2,6)
SG = abs(smooth(G,'rlowess'));
plot(t(round(offs/2)):1/fps:t(round(offs/2))+((length(G)-1)/fps),SG,'-r','LineWidth',2);

% axis([t(1) t(length(t)) min(SG) max(SG)]);
axis([t(1) t(length(t)) 0 2]);
title('Efficiency Coeff. vs time', 'FontSize', 12);    
xlabel('t (s)')
ylabel('\gamma')  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% mt1=annotation('textbox', [0 0.9 1 0.1],'String', [fname ' Plots 2'],'EdgeColor', 'none','HorizontalAlignment', 'center');
% mtfs1 = mt1.FontSize;
% mt1.FontSize = 15;
% 
% subplot(2,2,2)
% SW = abs(smooth(Datam2(:,2),'rlowess'));
% plot(Datam2(:,1),SW,'-r','LineWidth',2);
% 
% 
% axis([t(1) t(length(t)) 0 2]);
% title('WaveLength vs time', 'FontSize', 12);    
% xlabel('t (s)')
% ylabel('\lambda (mm)')  
%   
% subplot(2,2,3)
% % SFH = abs(smooth(Datafh2,'rlowess'));
% % SF = abs(smooth(Dataf2,'rlowess'));
% SFH = Datafh2;
% SF = Dataf2;
% plot(t(round(offs/2)):1/fps:t(round(offs/2))+((length(Datafh2)-1)/fps),SFH,'-b','LineWidth',1);
% 
% hold on
% plot(t(round(offs/2)):1/fps:t(round(offs/2))+((length(Dataf2)-1)/fps),SF,'-r','LineWidth',2);
% hold off
% 
% axis([t(1) t(length(t)) 0 1]);
% title('Frequency vs time', 'FontSize', 12);    
% xlabel('t (s)')
% ylabel('f (Hz)')  
% 
% subplot(2,2,1)
% SA = abs(smooth(Datam3(:,2),'rlowess'));
%  plot(Datam3(:,1),SA,'-r','LineWidth',2);
% 
% axis([t(1) t(length(t)) 0 0.3]);
% title('Amplitude vs time', 'FontSize', 13);    
% xlabel('t (s)')
% ylabel('A (mm)')  
% 
% subplot(2,2,4)
% SWS = abs(smooth(ws,'rlowess'));
% SVC = abs(smooth(VC,'rlowess'));
% plot(t(round(offs/2)):1/fps:t(round(offs/2))+((length(ws)-1)/fps),SWS,'-r','LineWidth',2);
% 
% hold on
% plot(t(round(offs/2)):1/fps:t(round(offs/2))+((length(ws)-1)/fps),SVC,'-g','LineWidth',1);
% hold off
% 
% axis([t(1) t(length(t)) 0 2]);
% title('Wave Speed vs time', 'FontSize', 12);    
% xlabel('t (s)')
% ylabel('v_w (mm/s)')  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SC = smooth(Datam4(:,2),'rlowess');
%  plot(Datam4(:,1),SC,'-r','LineWidth',2);
% 
% axis([t(1) t(length(t)) min(SC) max(SC)]);
% title('Reduced Chi-Squared vs time', 'FontSize', 12);    
% xlabel('time (s)')
% ylabel('\chi_r^2')  


LengthOfWorm = mean(Datam(:,6));
 Amplitude = mean(Datam(:,1));
   AmplitudePerLength = mean(Datam(:,4));
 % AmplitudePerLength =  Amplitude/LengthOfWorm ;
 WaveLength= 1/mean(Datam(:,2));
    WavelengthPerLength = 1/mean(Datam(:,5));
%  WavelengthPerLength = WaveLength/LengthOfWorm ;
 

%  Amplitude = mean(abs(smooth(Datam(:,1),'rlowess')));
%  AmplitudePerLength = mean(abs(smooth(Datam(:,4),'rlowess')));
%  WaveLength= 1/mean(abs(smooth(Datam(:,2),'rlowess')));
%  WavelengthPerLength = 1/mean(abs(smooth(Datam(:,5),'rlowess')));
%  LengthOfWorm = mean(abs(smooth(Datam(:,6),'rlowess')));
 
%  Frequency = mean(Dataf(:,1));
%  FrequencyH = frqh;
%  VelocityX = sum(vf(:,2))/abs(t(1)-t(length(t)));
%  VelocityY = sum(vf(:,3))/abs(t(1)-t(length(t)));
%  VelocityCM = sum(vf(:,1))/abs(t(1)-t(length(t)));
% VelocityWave = WaveLength*Frequency;
% gamma= AvgV/VelocityWave;


 
ReduceChiSquare = mean(Datam4(:,2)); 
AvgFreq = mean(Dataf2);
AvgFreqH = mean(Datafh2);
AvgWaveSpeed = mean(ws);
AvgGamma= mean(G);

% ReduceChiSquare = mean(abs(smooth(Datam4(:,2),'rlowess'))); 
% AvgFreq = mean(SF);
% AvgFreqH = mean(SFH);
% AvgWaveSpeed = mean(SWS);
% AvgGamma= mean(SG);

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
if mm==1   
   drf = [LengthOfWorm,Amplitude,AmplitudePerLength,WaveLength,WavelengthPerLength,AvgFreq,AvgWaveSpeed,...
      AvgV,AvgFreqH,AvgVh,FreqRatio,SpeedRatio,AvgGamma,ReduceChiSquare];
  
   dlmwrite(fileres,drf);
  
else
    drf = [LengthOfWorm,Amplitude,AmplitudePerLength,WaveLength,WavelengthPerLength,AvgFreq,AvgWaveSpeed,...
      AvgV,AvgFreqH,AvgVh,FreqRatio,SpeedRatio,AvgGamma,ReduceChiSquare];
  
   dlmwrite(fileres,drf,'-append');
  
end    
  
% cd(folderName)
% cd ../
% mkdir('Standard Format')
% cd('Standard Format')
% set(gcf,'PaperUnits','points','PaperPosition',[0,0,1280,720])
% saveas(gcf,['StandardFormat_' name],'tiff')
% cd(oldfolder)
% toc
 

 