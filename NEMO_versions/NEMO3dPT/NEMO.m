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
%  -Three binarized videos, of square resolution (height=width), 
%   synchronized at the first frame, with black animal on a white background.
%  -Excel sheet containing stage offsets, in format [frame x y z], with first
%   line corresponding to input variable 'start'.
%
%OUTPUTS:
%  -Excel file containing [frame, time, phase, XYZ_CoM, XYZ_segments].
%   XYZ_segments are in order from head to tail. 


global NEMOstep
global folderName
global univFileName

mainOutFolder = desktop

oldfolder=pwd;

try
    currentversion=fileread('Z:\NEMO3dbow\version.txt');
    servavail=1;
catch
    choice=questdlg({'Could not connect to update server.';'';...
        'Continue with NEMO anyway?'},...
        'Server error',...
        'Continue','Quit','Quit');
    
    switch choice
        case 'Continue'
            servavail=0;
            
        case 'Quit'
            return
            
    end
end
    
if servavail==1
    
    localversion=fileread('version.txt');

    if strcmpi(localversion,currentversion)==0                                  %Version control

        choice=questdlg({['Most recent version is ' currentversion '.'];...
            ['Local version is ' localversion '.'];'';'Do you wish to update?'},...
            'Version out-of-date',...
            'Update','Continue without updating','Continue without updating');

        switch choice
            case 'Update'
                copyfile('Z:\NEMO3dbow\*.m','..\NEMO3dbow\','f')
                copyfile('Z:\NEMO3dbow\*.txt','..\NEMO3dbow\','f')
                uiwait(msgbox('Please run NEMO again once you close this dialog box, fam.',...
                    'Updating from source directory - Z:\NEMO3dbow.'))
                return

            case 'Continue without updating'

        end
    end
end


if isempty(NEMOstep)
    assignin('base','NEMOstep',0)
    
    NEMOstep=0
end


if exist('done.txt','file')==2
    
    NEMOstep=6
end


if NEMOstep==0
    if ~exist('DATA_MASTER','dir')
        mkdir('DATA_MASTER')
    end
    frames_bin(start,finish)                                                %Extracts frames from video
    
    NEMOstep=1
end


if NEMOstep==1
    if ~exist('DATA','dir')
        mkdir('DATA')
    end
    frames_ROI(start,finish,pxpmm)                                          %Crops frames
    
    NEMOstep=2
end


if NEMOstep==2
    recon_voxels(start,finish)                                              %Constructs voxel image
                                                                            %Extracts skeleton
    NEMOstep=3
end


if NEMOstep==3
    extract_endpoints(start,finish)                                         %Reorients skeleton, head to tail
    
    NEMOstep=4
end


% if NEMOstep==4
%     %insert some kind of phase detection here
%     
%     NEMOstep=5
% end


if NEMOstep==4
    segment_data(start,finish,segnum,fps,pxpmm)                             %Segments skeleton
                                                                            %Outputs in Excel format
    NEMOstep=6
end


if NEMOstep==6
    choice=questdlg({'Do you want to delete all intermediate files and reset NEMO?';'Check your segmentdata.xlsx sheet for errors!'},...
        'Nuke everything?',...
        'Yes','Hold on','Generate another Excel sheet','Hold on');
    
    switch choice
        case 'Yes'
            delete('done.txt')
            if exist('DATA','dir')
                rmdir('DATA','s')
            end
            if exist('DATA_MASTER','dir')
                rmdir('DATA_MASTER','s')
            end
            NEMOstep=[];
            close all
            clear global
            
        case 'Hold on'
            fprintf('All files retained. Run again to reset NEMO.\n\n')
            
            choice=questdlg('Would you like to check the Excel sheet? Or view a path animation?',...
                'Double-check your results',...
                'Open Excel sheet','Display path animation','Do nothing','Do nothing');
            
            switch choice
                case 'Open Excel sheet'
                    fullFileName=[folderName,'NEMO\',univFileName,'.xlsx'];
                    winopen(fullFileName)
                    
                case 'Display path animation'
                    showpath(folderName, univFileName)
                    
                case 'Do nothing'
            end
  
        case 'Generate another Excel sheet'
            
%             choice=questdlg('Make sure you close any instances of the Excel Sheet before you continue.',...
%                 'What part do you want to redo?',...
%                 'The segments','The phases','The phases');
            
%             switch choice
%                 case 'The segments'
                    NEMOstep=6
                    segment_data(start,finish,segnum,fps,pxpmm)
                    NEMO(start,finish,segnum,fps,pxpmm)
%                 case 'The phases'
%                     NEMOstep=8
%                     stagedetect(start,finish,N,fps)
%                     NEMOanalysis(start,finish,N,fps,calibration)
%             end
    end
    
end



