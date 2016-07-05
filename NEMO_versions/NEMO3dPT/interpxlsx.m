function interpxlsx

%Interpolates missing data within stage motion information. For .xlsx only.
%
%If your stage data has holes in it, you will NEED to use this.

oldfolder=pwd;

[FileName,PathName,FilterIndex]=uigetfile('.xlsx');
[N,T,D]=xlsread([PathName, FileName]);

X1=N(:,5);
X2=N(:,2:4);
X=[X1,X2];

out=X;
out(any(abs(X2)<100,2),:)=[];
X=out;

Y=zeros(X(end,1)-X1(1,1)+1,4);
yndex=1;

for i=2:size(X,1)
    
    jump=X(i,1)-X(i-1,1);
    differx=X(i,2)-X(i-1,2);
    differy=X(i,3)-X(i-1,3);
    differz=X(i,4)-X(i-1,4);
    stepx=differx/jump;
    stepy=differy/jump;
    stepz=differz/jump;
    
    for k=1:jump
        Y(yndex,1)=X(i-1,1)+k-1;
        Y(yndex,2)=X(i-1,2)+stepx*(k-1);
        Y(yndex,3)=X(i-1,3)+stepy*(k-1);
        Y(yndex,4)=X(i-1,4)+stepz*(k-1);
        
        yndex=yndex+1;
    end
end

Y(yndex,1)=X(end,1);
Y(yndex,2)=X(end,2);
Y(yndex,3)=X(end,3);
Y(yndex,4)=X(end,4);
        
cd(PathName)
[pathstr,name,ext]=fileparts(FileName); 
xlswrite([name '_interp'],Y)
cd(oldfolder)

end
        
        