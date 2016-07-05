function SkeletonTrace2D(WormID,N)

global outPlotsFolder   % added

oldfolder = pwd;        % added
cd(outPlotsFolder)      % added

t=2;

frames=size(N,1);
colwidth = numel(N(1,:));
segments = (colwidth-3)/2;

X = zeros(frames,segments);
Y = zeros(frames,segments);

for j = 1:segments
    X(:,j) = N(:,(2*j)+2);
    Y(:,j) = N(:,(2*j)+3);
end
 
x=X;
y=1024-Y;

n=1024;

T=zeros(n,n);

aviobj = VideoWriter(['2Dptw' num2str(WormID) 'skeleton.avi']);
open(aviobj);

for k=1:frames
    for m=1:segments
        T(y(k,m)-t:y(k,m)+t,x(k,m)-t:x(k,m)+t)=1;
    end

 writeVideo(aviobj,T);
 T=zeros(n,n);
end
  close(aviobj);
  cd(oldfolder);    % added
  
 end