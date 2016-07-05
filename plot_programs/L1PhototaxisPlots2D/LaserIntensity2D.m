function [G,Ir]=LaserIntensity2D(WormN,fr,f1,f2,current)

global outPlotsFolder   % added

oldfolder = pwd;        % added
cd(outPlotsFolder)      % added

N=400;
mmpx=1/320;

% xo=543; 
% yo=527;
% sx=101; 
% sy=100;

xo=200; 
yo=200;
sx=83; 
sy=83;

sxc=sx*mmpx; 
syc=sy*mmpx;

% pow = 0.1388*current - 0.9146;
pow  = 0.1858*current - 6.1088;
Ir=pow/(2*pi*sxc*syc);


T=zeros(N,N);

for i=1:1:N    
for j=N:-1:1 
            x=(i-1);
            y=(j-1);
          
 
            T(i,j)=exp(-(1/2).*(((x-xo)./sx).^2 +((y-yo)./sy).^2));

             
end
end

H=mat2gray(T,[0 1]);


A=zeros(N,N);

for i=1:1:N    
for j=N:-1:1 
           
    A(i,j)=0;

             
end
end

B=mat2gray(A,[0 1]);
 

G=zeros(N,N,fr);

aviobj = VideoWriter(['2Dptw' num2str(WormN) 'laser.avi']);
open(aviobj);
for k=1:fr 
if k>=f1 && k<=f2 
    G(:,:,k)=T;
writeVideo(aviobj,H);
else
     G(:,:,k)=A;
writeVideo(aviobj,B);
end
  

end
 
close(aviobj);
cd(oldfolder)   % added
end