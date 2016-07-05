function segmentdata(a,b,N,fps,calibration)
%%   COPYRIGHT:  George D. Tsibidis(1) and Nektarios Tavernarakis(2)
%               (1) Institute of Electronic Structure and Laser 
%               (2) Institute of Molecular Biology and Biotechnology 
%               Foundation for Research and Technology-Hellas (FORTH)
%               January 2007
%
%
%segmentation of the animal
% a: starting value for image
% b: last value for image
% N: every segment contains N points odd number
%
% every segment contains N points

global vidHeight
global PERXY
global CoM
global COMlist
global folderName
global baseFileName
global wnumber

premo;
cd(oldfolder)
phase=load('phase.csv');
phase2=cell(size(phase,1),1);

for i=1:size(phase,1)
    if phase(i)==100
        phase2(i)=cellstr('forward');
    elseif phase(i)==110
        phase2(i)=cellstr('reversal');
    elseif phase(i)==111
        phase2(i)=cellstr('omega');
    end
end

cd('DATA_SAVED')

titles=cell(1,2*N+5);

for s=1:N
    
    titles(1,2*s+4)=cellstr(strcat('x',num2str(s),'[mm]'));
    titles(1,2*s+5)=cellstr(strcat('y',num2str(s),'[mm]'));
end

titles(1,2*N+6)=cellstr(strcat('x',num2str(N+1),'[mm]'));
titles(1,2*N+7)=cellstr(strcat('y',num2str(N+1),'[mm]'));
titles(1,1)=cellstr('frame');
titles(1,2)=cellstr('time[sec]');
titles(1,3)=cellstr('stage');
titles(1,4)=cellstr('x_CM[mm]');
titles(1,5)=cellstr('y_CM[mm]');

stage=cell(b-a+1,1);
pointvalue=zeros(b-a+1,2*N+5);
   
for s=a:b;
    
    poffset=COMlist(s-a+1,:);
    
    disp(['Exporting segment data for ' int2str(s)])
        
    point_segment_image=s;
    pointvalue(s-a+1,1) = round(point_segment_image);
    pointvalue(s-a+1,2) = (point_segment_image)/(fps);

    fieldname=['frame' int2str(s)];

    cd(oldfolder);
    centerofmass(s,calibration,poffset)

    pointvalue(s-a+1,4)=CoM.(fieldname)(1);
    pointvalue(s-a+1,5)=CoM.(fieldname)(2);
 
    if phase(s-a+1)~=111
        
        cd(oldfolder); 
        cd ('DATA_SAVED');
        n=N;
        n1=rem(length(PERXY.(fieldname)(1,:)),N);
        n2=(length(PERXY.(fieldname)(1,:))-n1)/N;
        
        A=[];
        A=n2*ones(N,1);
        for i=N-n1+1:N
            A(i)=A(i)+1;
        end

        F=1;

        for t=2:N;
            
            if t==2

                O1=PERXY.(fieldname)(1,1);
                O2=PERXY.(fieldname)(2,1);

                pointvalue(s-a+1,6)=1/calibration*((O2-calibration)+poffset(2));
                pointvalue(s-a+1,7)=1/calibration*((calibration-O1)+(vidHeight-poffset(1)));
            end
            
            F=F+A(t-1);

            P1=PERXY.(fieldname)(1,F);
            P2=PERXY.(fieldname)(2,F);

            pointvalue(s-a+1,2*t+4)=1/calibration*((P2-calibration)+poffset(2));
            pointvalue(s-a+1,2*t+5)=1/calibration*((calibration-P1)+(vidHeight-poffset(1)));

            if t==N

                Q1=PERXY.(fieldname)(1,end);
                Q2=PERXY.(fieldname)(2,end);

                pointvalue(s-a+1,2*N+6)=1/calibration*((Q2-calibration)+poffset(2));
                pointvalue(s-a+1,2*N+7)=1/calibration*((calibration-Q1)+(vidHeight-poffset(1)));
            end
        end
    else
        point_segment_image=s;
        pointvalue(s-a+1,1) = round(point_segment_image);
        pointvalue(s-a+1,2) = (point_segment_image)/(fps);
        
        cd(oldfolder);
        centerofmass(s,calibration,poffset)
        
        fieldname=['frame' int2str(s)];

        pointvalue(s-a+1,4)=CoM.(fieldname)(1);
        pointvalue(s-a+1,5)=CoM.(fieldname)(2);
    end
end

index=find(pointvalue(:,1)==a);
stage=phase2(index(1):end);

cd(folderName);
mkdir('NEMO');
cd('NEMO');

xlswrite([baseFileName '_' int2str(wnumber) '.xlsx'],titles,'Sheet1','A1');
xlswrite([baseFileName '_' int2str(wnumber) '.xlsx'],pointvalue,'Sheet1','A2')
xlswrite([baseFileName '_' int2str(wnumber) '.xlsx'],stage,'Sheet1','C2')


cd (oldfolder);

save('done.txt')

msgbox('Segment data available.')
