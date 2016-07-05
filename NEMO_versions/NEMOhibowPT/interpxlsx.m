function interpxlsx

%Interpolates missing data within stage motion information. For .xlsx only.
%
%If your stage data has holes in it, you will NEED to use this.

oldfolder=pwd;
global mainOutFolder

%[FileName,PathName,FilterIndex]=uigetfile('.xlsx');
FileName = 'pOffsetData.xlsx';         
PathName = fullfile(mainOutFolder,'pOffsetData\');
[N,T,D]=xlsread([PathName, FileName]);

X1=N(:,2);
X2=N(:,4:5);
X=[X1,X2];

out=X;
out(any(X2<100,2),:)=[];
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
[pathstr,name,ext]=fileparts(FileName); 
xlswrite([name '_interp'],Y)
cd(oldfolder)
        
        