 function asjLocation3D(WormID,N)

w=10;
t=2;

frames=size(N,1);

x=N(:,6);
y=800-N(:,7);


n=800;

T=zeros(n,n);


 
% figure;
 aviobj = VideoWriter(['3Dfmw' num2str(WormID) 'asj.avi']);
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
end

 close(aviobj);

end