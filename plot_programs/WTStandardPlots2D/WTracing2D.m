function WTracing2D()

[baseFileName, folderName, FilterIndex]=uigetfile('*.xlsx');
[pathstr, name, ext]=fileparts(baseFileName);
ExcelFileName=[folderName,'/',baseFileName];
[N,T,D]=xlsread(ExcelFileName, 'Sheet1');

frames=size(N,1);
colwidth = numel(N(1,:));
segments = (colwidth-5)/2;


filex = 'wTs_x.csv';
filey = 'wTs_y.csv';
filex2 = 'wTs_x2.csv';
filey2 = 'wTs_y2.csv';
% filexh = 'wTfit_x_h.csv';
% fileyh = 'wTfit_y_h.csv';
% filea = 'wTfit_R_1.csv';
% filea2 = 'wTfit_R_2.csv';
% filea3 = 'wTfit_R_3.csv';
% filea4 = 'wTfit_R_4.csv';
% % filef = 'wTfit_f.csv';
% filef2 = 'wTfit_f_2.csv';
% filefh2 = 'wTfit_f_h_2.csv';
% fileres = 'wTfit_Res.csv';

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

figure;
% aviobj = VideoWriter('bUMMwtvid12b.avi');
% open(aviobj);

for k = 1:frames


subplot(1,2,1)
plot(x1,y1);

hold on
plot(xc,yc);
hold off

hold on
plot(xc(k),yc(k),'ro');
hold off

x=X(k,2:segments+1)';
y=Y(k,2:segments+1)';

hold on
plot(x,y,'g-o');
hold off


axis([min(xc)-0.3 max(xc)+0.3 min(yc)-0.3 max(yc)+0.3]);

xlabel('X-position (mm)')
ylabel('Y-position (mm)')
    
%       if xor(x(1)>xc(k), xc(k)>xe(k))
%         theta = pi+atan(0.5*(((yc(k)-y(1))/(xc(k)-x(1)))+((ye(k)-yc(k))/(xe(k)-xc(k)))));
%         else
%         theta = atan(0.5*(((yc(k)-y(1))/(xc(k)-x(1)))+((ye(k)-yc(k))/(xe(k)-xc(k)))));
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
    
%     subplot(1,2,2)
%     plot(xf2,yf2,'o');
%     
%     hold on
%     plot(xcf2,ycf2,'ro');
%     hold off
%     
%     
%     hold on
%     plot(xf2,F1(a1,xf2));
%     hold off
% 
%     axis([0 1 -0.25 0.25]);
%     
% xlabel('X-position (mm)');
% ylabel('Y-position (mm)');

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
    a2 = lsqcurvefit(F2,a20,xf4,yf4);
    
    subplot(1,2,2)
    plot(xf4,yf4,'o');
    
    hold on
    plot(xcf4,ycf4,'ro');
    hold off
    
    
    hold on
    plot(xf4,F2(a2,xf4));
    hold off

    axis([0 1 -0.25 0.25]);
    
xlabel('X-position (mm)');
ylabel('Y-position (mm)');    

% a01i=1;
% a02i=1;
% a03i=1;
% 
%     
%     F2 = @(a2,xf2)a2(1)*sin(2*pi*((a2(2)*xf2) + a2(3)));
%     a20 = [a01i a02i a03i];
%     a2 = lsqcurvefit(F2,a20,xf2,yf2);
%     
%     subplot(1,2,2)
%     plot(xf2,yf2,'o');
%     
%     hold on
%     plot(xcf2,ycf2,'ro');
%     hold off
%     
%     
%     hold on
%     plot(xf2,F2(a2,xf2));
%     hold off
% 
%     axis([0 1 -0.25 0.25]);
%     
% xlabel('X-position (mm)');
% ylabel('Y-position (mm)');


% writeVideo(aviobj,getframe(gcf));  
 % pause(1/30)
  drawnow;
end
  % close(aviobj);