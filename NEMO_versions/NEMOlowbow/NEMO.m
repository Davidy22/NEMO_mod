function NEMO(start, finish, segnum,fps,pxpmm)

global mainOutFolder
global NEMOstep
global start1
global finish1
global current1
global wnumber
global stop0
global stop1
global nof
global startspr
global finishspr
global PERXY

premo;

% if isempty(NEMOstep)==1
%     assignin('base','NEMOstep',0)
%     
%     NEMOstep=0
% end
% 
% 
% if exist('done.txt','file')==2
%     
%     NEMOstep=9
% end

mainOutFolder = 'C:\FOR_ANALYSIS';  % TEMPORARY
NEMOstep = 0;
oldfolder = pwd;    % dir of NEMO files

if NEMOstep==0
    clearvars -global -except NEMO* mainOutFolder start* finish* stop* PERXY nof current1 wnumber
    
    wnumber=0;
    PERXY=struct;
    
    NEMOstep=1
end


if NEMOstep==1      %get frames
    nof = finish - start;
    
    NEMOstep=2
end


if NEMOstep==2      %choose start and end frame
    close all
    cd(oldfolder)
    startspr = start;
    finishspr = finish;
    
%     while stop0==false
%         uiwait
%     end
%     uiresume

    wnumber=wnumber+1;
        
    NEMOstep=3
end


if NEMOstep==3      %choose worm
    cd(oldfolder)
    if ~exist('DATA','dir')
        mkdir('DATA')
    end
    if ~exist('DATA_SAVED','dir')
        mkdir('DATA_SAVED')
    end
    
    frameROI(startspr,finishspr,pxpmm)
    
    NEMOstep=4
end


if NEMOstep==4      %get phases
    close all
    start1=startspr;
    finish1=finishspr;
    current1=startspr;
    interface1({startspr,finishspr})
    
    while stop1==false
        uiwait
    end
    uiresume
        
    NEMOstep=5
end


if NEMOstep==5      %get skeleton
    extract_object(startspr,finishspr)

    NEMOstep=6
end


if NEMOstep==6      %get head and tail
    extract_endpoints(startspr,finishspr)
    
    NEMOstep=7
end


if NEMOstep==7      %get length
    extract_length(startspr,finishspr)

    NEMOstep=8
end


if NEMOstep==8      %get segments
    segmentdata(startspr,finishspr,segnum,fps,pxpmm)
    
    NEMOstep=9
end

if NEMOstep==9
    choice=questdlg({'Do you want to delete all intermediate files and reset NEMO?';'Check your segmentdata.xlsx sheet for errors!'},...
        'Nuke everything?',...
        'Yes','Hold on','Generate another Excel sheet','Hold on');
    
    switch choice
        case 'Yes'
            choice2=questdlg({'Are you done analyzing this video,';'or do you want to analyze another worm on the same video?'},...
                'Nuke EVERYTHING, everything?',...
                'I am finished with this video','Try another worm','Try another worm');
            
            switch choice2
                case 'I am finished with this video'
                    cd(oldfolder)
                    delete('done.txt')
                    delete('phase.csv')
                    rmdir('DATA_MASTER','s')
                    rmdir('DATA','s')
                    rmdir('DATA_SAVED','s')
                    NEMOstep=[];
                    close all
                    
                case 'Try another worm'
                    cd(oldfolder)
                    delete('done.txt')
                    delete('phase.csv')
                    rmdir('DATA','s')
                    rmdir('DATA_SAVED','s')
                    NEMOstep=2;
                    close all
                    NEMO(segnum,fps,pxpmm)
            end
            
        case 'Hold on'
            disp('All files retained. Run again to reset NEMO')
  
        case 'Generate another Excel sheet'
            segmentdata(startspr,finishspr,segnum,fps,pxpmm)
            NEMO(segnum,fps,pxpmm)
    end

            
end



