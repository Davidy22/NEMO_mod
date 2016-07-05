function interpcsv

%Interpolates missing data within stage motion information. For .csv or other non-descript text files only.
%
%If your stage data has holes in it, you will NEED to use this.

oldfolder=pwd;

[FileName,PathName,FilterIndex]=uigetfile('..\*.*');
N=importdata([PathName, FileName],'\t');
data=N.data;
textdata=N.textdata;

X1=textdata(1:end,2);
X2=data;

X1=X1(1:size(X2,1));
S = sprintf('%s*', X1{:});
X1 = sscanf(S, '%f*');
X=[X1,X2];

out=X;
out(any(abs(X2)<100,2),:)=[];
X=out;

Y=zeros(X(end,1)-X1(1,1)+1,3);
yndex=1;

for i=2:size(X,1)
    
    jump=X(i,1)-X(i-1,1);
    differx=X(i,2)-X(i-1,2);
    differy=X(i,3)-X(i-1,3);
    stepx=differx/jump;
    stepy=differy/jump;
    
    for k=1:jump
        Y(yndex,1)=X(i-1,1)+k-1;
        Y(yndex,2)=X(i-1,2)+stepx*(k-1);
        Y(yndex,3)=X(i-1,3)+stepy*(k-1);
        
        yndex=yndex+1;
    end
end

Y(yndex,1)=X(end,1);
Y(yndex,2)=X(end,2);
Y(yndex,3)=X(end,3);
        
cd(PathName)
xlswrite([FileName '_interp'],Y)
cd(oldfolder)
        
        