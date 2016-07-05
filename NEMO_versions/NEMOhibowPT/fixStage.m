[FileName,PathName,FilterIndex]=uigetfile('.xlsx');
[N,T,D]=xlsread([PathName, FileName],'Sheet1');
%disp(sort(N(1,:)))
oldfolder=pwd;
% for i=1:length(N(:,1))
%     N(i,:)=sort(N(i,:));
% end

for i=1:length(N(:,1))-1
    if N(i,1)==0 && N(i+1,1)>0
       N(i,1)=mean([N(i-1,1) N(i+1,1)]);
    elseif N(i,1)==0 && N(i+1,1)==0
       sub=N(i+2,1)-N(i-1,1);
       N(i,1)=(sub/3)+N(i-1,1);
       N(i+1,1)=2*(sub/3)+N(i-1,1);
    elseif N(i,1)==0 && N(i+1,1)==0 && N(i+2,1)==0
       sub=N(i+3,1)-N(i-1,1);
       N(i,1)=(sub/4)+N(i-1,1);
       N(i+1,1)=2*(sub/4)+N(i-1,1);
       N(i+2,1)=3*(sub/4)+N(i-1,1);
    end
end

% for i=1:length(N(:,1))
%     for j=1:3
%     if N(i,j)>200000
%         N(i,j)=N(i,j)/255;
%     end
%     if N(i,j)<10000
%         N(i,j)=0;
%     end
%     end
% end
% %
% for i=1:length(N(:,3))
%     if N(i,3)>115000 && N(i+1,3)<115000 || N(i,3)==0 
%         N(i,3)=mean([N(i-1,3) N(i+1,3)]);
%     end
% end
% 
% for i=1:length(N(:,5))
%     if N(i,5)<140000 && N(i+1,5)>140000 || N(i,5)==0
%         N(i,5)=mean([N(i-1,5) N(i+1,5)]);
%     end
% end

cd(PathName)
[pathstr,name,ext]=fileparts(FileName); 
xlswrite([name '_interpfix'],N)
cd(oldfolder)