function hLocation2D(WormID,N)

global outPlotsFolder   % added

oldfolder = pwd;        % added
cd(outPlotsFolder)      % added

w=10;
t=2;

frames=size(N,1);

x=N(:,6);
y=1024-N(:,7);


n=1024;

T=zeros(n,n);



% figure;
 aviobj = VideoWriter(['2Dptw' num2str(WormID) 'asj.avi']);
 open(aviobj);

for k=1:frames

    
for i=1:1:(2*w)+1    
for j=1:1:(2*w)+1 
            x1=x(k)-w+i-1;
            y1=y(k)-w+j-1;
            
            r1=sqrt((x1-x(k)).^2+(y1-y(k)).^2);
          

 if r1>=w/2 && r1<=t+(w/2)
      T(y1,x1)=1;
 else
      
 end
             
end
end


 

 writeVideo(aviobj,T);
 
 T=zeros(n,n);
end

 close(aviobj);
 cd(oldfolder)      % added
end