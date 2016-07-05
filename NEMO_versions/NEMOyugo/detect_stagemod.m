function detect_stagemod(start,finish,segnum,fps)

%Determines phase (forward, reversal, pause, or omega turn) using structural profiling.
%
%INPUTS:
%   start: first frame number
%   finish: last frame number
%   segnum: number of segments, number of nodes will be segments+1
%   fps: frames per second
%
%  -Coordinates [XY_CoM, XY_segments] as saved in global variable pointvalue.
%   XY_segments are in order from head to tail.
%
%OUTPUTS:
%  -Excel file containing [frame, time, phase, XYZ_CoM, XYZ_segments].
%   XYZ_segments are in order from head to tail. Phase is filled.

global mainOutFolder                % ADDED
global folderName
global baseFileName
global pointvalue
global motionflag

oldfolder=pwd;

a=start;
b=finish;

stage=cell(b-a+1,1);

%%%%%%%%%%%%%BEGIN STAGE DETECTION%%%%%%%%%
timelist=pointvalue(:,2);
COMlist=zeros(length(timelist),3);
COMlist(:,1:2)=pointvalue(:,4:5);

for i=2:length(timelist)
    
    COMlist(i,3)=sqrt((COMlist(i,1)-COMlist(i-1,1))^2 ... 
        +(COMlist(i,2)-COMlist(i-1,2))^2)*fps;
end

Xlist=pointvalue(:,6:2:2*segnum+6);
Ylist=pointvalue(:,7:2:2*segnum+7);

motionflag = zeros(length(timelist),1);

%%%%%%%%%first detect omegaturn
points = length(Xlist(1,:));
bodylength = zeros(length(timelist),1);

for f = 1:length(timelist)           %%%go through frames,
    for n = 1:points-1         %%go through worm points adding distance between this wormpoint and next wormpoint
        bodylength(f) = bodylength(f)+norm([Xlist(f,n)-Xlist(f,n+1),Ylist(f,n)-Ylist(f,n+1)]);
    end
end

global headtaildist

headtaildist = zeros(length(timelist),1);

for f = 1:length(timelist)
    headtaildist(f) = norm([Xlist(f,1)-Xlist(f,points),Ylist(f,1)-Ylist(f,points)]);
end

maxhtdist = max(headtaildist);
omeganum = 0;
omegabit = 0;




for f = 1:length(timelist)
    
    if headtaildist(f)<=maxhtdist*.42 && omegabit==0
        
        omegabit = 1;
        omeganum = omeganum + 1;
    end
    
    if headtaildist(f)>maxhtdist*.42 && omegabit==1  %%has the worm left omegaturn?
        
        omegabit = 0;
    end
    
    if omegabit == 1
        
        motionflag(f) = -2; %-2 means OMEGA
    else
        motionflag(f) = 0;  %0 means no flag
    end
end
%%%%%%%%%end

%%%%%%%%%other motion style detection
num4speed = 4;       %%interval to calculate average velocity
num4angle = 10;
smCOMlist(:,1) = smooth(COMlist(:,1),31,'sgolay',1);
smCOMlist(:,2) = smooth(COMlist(:,2),31,'sgolay',1);

global vel
vel=zeros(length(timelist),1);
for f=num4speed+1:length(timelist)-num4speed
    vel(f)=sqrt((smCOMlist(f-num4speed,1)-smCOMlist(f+num4speed,1))^2 ... 
        +(smCOMlist(f-num4speed,2)-smCOMlist(f+num4speed,2))^2);
end

motionflag(1:num4speed+1)=1;
for f = 1+num4speed:length(timelist)-num4angle
    
    if motionflag(f)~=-2  %not OMEGA
        
        if vel(f)<0.004

            motionflag(f)=2;    %PAUSE
                
        elseif vel(f)>=0.004
            
            postvector=[Xlist(f,1)-Xlist(f,end),Ylist(f,1)-Ylist(f,end),0]; %worm orientation vector
            comvector=[smCOMlist(f+num4angle,1)-smCOMlist(f,1), ... 
                smCOMlist(f+num4angle,2)-smCOMlist(f,2),0];                 %worm motion vector
            
            if motionflag(f-1)==2   %PAUSE
                
                pausedeltavector=atan2(norm(cross(comvector,postvector)),dot(comvector,postvector));
                
                if pausedeltavector>1.6
                    
                    motionflag(f)=-1;   %REVERSE
                else
                    
                    motionflag(f)=1;    %FORWARD
                end
                
            elseif motionflag(f-1)==-2  %OMEGA
                
                omegadeltavector=atan2(norm(cross(comvector,postvector)),dot(comvector,postvector));
                
                if omegadeltavector>1.6
                    
                    motionflag(f)=-1;   %REVERSAL
                else
                    
                    motionflag(f)=1;    %FORWARD
                end
            else
                
                motionflag(f)=motionflag(f-1);
            end
        end
    end
end
%%%%%%%%end

% for f = 1:length(timelist)
%     if motionflag(f)==-1%-1 means REVERSE
%         COMlist(f,3) = -COMlist(f,3);
%     end
% end

motionflag(end-num4angle+1:end)=motionflag(end-num4angle);

for f=1:length(timelist)
    if motionflag(f)==-2
        stage(f)=cellstr('omega turn');
    elseif motionflag(f)==-1
        stage(f)=cellstr('reversal');
    elseif motionflag(f)==1
        stage(f)=cellstr('forward');
    elseif motionflag(f)==2
        stage(f)=cellstr('pause');
    end
end

cd(fullfile(mainOutFolder,'\NEMO'))  % changed to write new column over excel file
%mkdir('NEMO')
%cd('NEMO')

xlswrite([baseFileName '.xlsx'],stage,'Sheet1','C2')

cd(oldfolder)
save('done.txt')

