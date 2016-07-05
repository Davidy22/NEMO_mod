function NEMO(start,finish,segnum,fps,pxpmm)

%Master function to organize and remember steps of NEMO analysis.
%
%INPUTS:
%   start: first frame number
%   finish: last frame number
%   segnum: number of segments, number of nodes will be segments+1
%   fps: frames per second
%   pxpmm: pixels per millimeter
%
%  -One binarized video, with black animal on a white background.

%  -Excel sheet containing stage offsets, in format [frame x y], with first
%   line corresponding to input variable 'start'.
%
%OUTPUTS:
%  -Excel file containing [frame, time, phase, XY_CoM, XY_segments].
%   XY_segments are in order from head to tail. 

global mainOutFolder
global PERXY
global NEMOstep
global baseFileName
global folderName

oldfolder=pwd;

% try
%     currentversion=fileread('Z:\NEMOhibow\version.txt');
%     servavail=1;
% catch
%     choice=questdlg({'Could not connect to update server.';'';...
%         'Continue with NEMO anyway?'},...
%         'Server error',...
%         'Continue','Quit','Quit');
%     
%     switch choice
%         case 'Continue'
%             servavail=0;
%             
%         case 'Quit'
%             return
%             
%     end
% end
%     
% if servavail==1
%     
%     localversion=fileread('version.txt');
% 
%     if strcmpi(localversion,currentversion)==0                                  %Version control
% 
%         choice=questdlg({['Most recent version is ' currentversion '.'];...
%             ['Local version is ' localversion '.'];'';'Do you wish to update?'},...
%             'Version out-of-date',...
%             'Update','Continue without updating','Continue without updating');
% 
%         switch choice
%             case 'Update'
%                 copyfile('Z:\NEMOhibow\*.m','..\NEMOhibow\','f')
%                 copyfile('Z:\NEMOhibow\*.txt','..\NEMOhibow\','f')
%                 uiwait(msgbox('Please run NEMO again once you close this dialog box, fam.',...
%                     'Updating from source directory - Z:\NEMOhibow.'))
%                 return
% 
%             case 'Continue without updating'
% 
%         end
%     end
% end
%
% if isempty(NEMOstep)
%     assignin('base','NEMOstep',0)
%     
%     NEMOstep=0
% end
% 
% 
% if exist('done.txt','file')==2
%     
%     NEMOstep=6
% end

NEMOstep = 0;

if NEMOstep==0
    clearvars -global -except NEMO* mainOutFolder
    PERXY=struct;
    
    NEMOstep=1;
end


if NEMOstep==1
%     if ~exist('DATA_MASTER','dir')
%         mkdir('DATA_MASTER')
%     end
%     frames_bin(start,finish)                                                %Extracts frames from video
    
    NEMOstep=2;
end


if NEMOstep==2
    recon_pixels_auto(start,finish,pxpmm)                                        %Extracts mask and skeleton
    
    NEMOstep=3;
end
    
    
if NEMOstep==3
    extract_endpoints(start,finish)                                         %Determines head and tail

    NEMOstep=4;
end


if NEMOstep==4
    segment_data_auto(start,finish,segnum,fps,pxpmm)                             %Segments skeleton
    
    NEMOstep=5;
end


if NEMOstep==5 
    detect_stage_auto(start,finish,segnum,fps)                                   %Categorizes frames into phases
    
    NEMOstep=6;
end


%% if NEMOstep==6
%     choice=questdlg({'Do you want to delete all intermediate files and reset NEMO?';'Check your segmentdata.xlsx sheet for errors!'},...
%         'Nuke everything?',...
%         'Yes','Hold on','Generate another Excel sheet','Hold on');
%     
%     switch choice
%         case 'Yes'
%             delete('done.txt')
%             if exist('DATA_MASTER','dir')
%                 rmdir('DATA_MASTER','s')
%             end
%             if exist('DATA_SAVED','dir')
%                 rmdir('DATA_SAVED','s')
%             end
%             NEMOstep=[];
%             close all
%             clear global
%             
%         case 'Hold on'
%             fprintf('All files retained. Run again to reset NEMO.\n\n')
%             
%             choice=questdlg('Would you like to check the Excel sheet? Or view a path animation?',...
%                 'Double-check your results',...
%                 'Open Excel sheet','Display path animation','Do nothing','Do nothing');
%             
%             switch choice
%                 case 'Open Excel sheet'
%                     fullFileName=[folderName,'NEMO\',baseFileName,'.xlsx'];
%                     winopen(fullFileName)
%                     
%                 case 'Display path animation'
%                     showpath(folderName, baseFileName)
%                     
%                 case 'Do nothing'
%             end
%   
%         case 'Generate another Excel sheet'
%             
%             choice=questdlg('Make sure you close any instances of the Excel Sheet before you continue.',...
%                 'What part do you want to redo?',...
%                 'The segments','The phases','The phases');
%             
%             switch choice
%                 case 'The segments'
%                     NEMOstep=4
%                     segment_data(start,finish,segnum,fps,pxpmm)
%                     NEMOanalysis(start,finish,segnum,fps,pxpmm)
%                 case 'The phases'
%                     NEMOstep=5
%                     detect_stage(start,finish,segnum,fps)
%                     NEMOanalysis(start,finish,segnum,fps,pxpmm)
%             end
%     end
% end



