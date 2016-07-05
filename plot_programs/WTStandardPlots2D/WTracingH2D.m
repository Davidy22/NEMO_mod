function WTracingH2D()

[baseFileName, folderName, FilterIndex]=uigetfile('*.xlsx');
[pathstr, name, ext]=fileparts(baseFileName);
ExcelFileName=[folderName,'/',baseFileName];
[N,T,D]=xlsread(ExcelFileName, 'Sheet1');

frames=size(N,1);
colwidth = numel(N(1,:));
segments = (colwidth-5)/2;


filexh = 'wTs_xh.csv';
fileyh = 'wTs_yh.csv';
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

% aviobj = VideoWriter('wtvid131.avi');
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
    
     subplot(1,2,2)
   
    plot(xf2n,yf2n,'g-o');
   
%     hold on
%     plot(xcf2n,ycf2n,'ro');
%     hold off
    
    axis([-0.5 1 -0.5 0.5]);
    
xlabel('X-position (mm)');
ylabel('Y-position (mm)');


    
      


%writeVideo(aviobj,getframe(gcf));  
 % pause(1/30)
  drawnow
end
%   close(aviobj);