%% ***** SCRIPT DESCRIPTION ***** %
% This script will allow a user to select data they wish to analyze, and 
% after using a GUI to select the settings of the type of analysis they 
% would like to run, will run function to produce binarized version 
% of frame data. It is then fed into an appropriate version of NEMO which 
% produces processed data information in spreadsheet form. It is then 
% given to a plot program that creates  visuals of the data.


%% Clearing workspace
clc;
clearvars;
% below is used for better user readability during execution of program
split = '\n---------------------------------------------\n';

%% Storing location of files to be used

% Location of directory that will temporarily hold all intermediate files
% for analysis process. All processed data will be kept here until last
% user defines permanent location of processed data. Must be global since
% var is accessed in NEMO, darkSub, and frameMaker.
global mainOutFolder
mainOutFolder = 'C:\FOR_ANALYSIS';

% Location of NEMO files. This directory holds directories of the different
% versions of NEMO (the main function and other dependent functions)
NEMOlocation = 'C:\analysis_files\NEMO_versions';

% Location of plot functions. This directory holds directories of the 
% different plot functions (the main function + other dependent functions)
plotslocation = 'C:\analysis_files\plot_programs';

% Location of dark sub function
darksublocation = 'C:\analysis_files\dark_sub';


%% ***** USER INPUT FOR ANALYSIS SETTINGS***** %
% Next few sections will gather information from user on what kind of 
% analysis to run

%% Default settings for analysis

twoD = 1;                   % is 2D
highRes = 1;                % is high resolution
%pixCoords = 1;              % user would like pixel coordinates of data
%darkField = 1;              % is a dark field set
adultW = 1;                 % is an adult worm
testType = 'freemotion';    % worm in freemotion data
FPS = 30;
pixpMM = 320;
startFrame = 1;
endFrame = 9999;
segNum = 20;                % number of segments to break worm into in NEMO
isFrames = 1;               % data is fed as frames into program
global is405                % if laser glow around specimen is 405nm
is405 = 1;                  % must be global b/c darkSub uses it
global laserHalo            % laser glow around specimen
laserHalo = 0;              % must be global b/c darkSub uses it

%% Run GUI for user to select settings
% Runs UI which changes the variables (see above cell) that will be used
% to find appropriate NEMO/plot functions this program must call

% UI function
f1 = analysisSettings();
waitfor(f1);


%% ***** FINDING APPROPRIATE NEMO/PLOT FILE PATHS ***** %
% Uses answers from previous section to save path to appropriate NEMO/plot
% functions to run

%% Finding NEMO path

% right now, low res and 3D analysis not available.
if (twoD == 0)
    fprintf('\nProgram does not support 3D yet. Coming soon.\n')
    fprintf('Press any key to close program.')
    pause
    deleteAll();
    quit
elseif (highRes == 0)
    fprintf('\nProgram does not support low resolution data yet. Coming soon.\n')
    fprintf('Press any key to close program.')
    pause
    deleteAll();
    quit
elseif (is405 == 0)
    fprintf('\nProgram does not support IR laser data yet. Coming soon.\n')
        fprintf('Press any key to close program.')
    pause
    deleteAll();
    quit
end


% Adding NEMO folder name to NEMO versions dir path
if (twoD == 1 && highRes == 1) %&& pixCoords == 1)        % 2D, hi res
    NEMOpath = fullfile(NEMOlocation,'NEMOhibowPT');
elseif (twoD == 1 && highRes == 0) %&& pixCoords == 0)    % 2D, lo res
    NEMOpath = fullfile(NEMOlocation,'NEMOlowbow');
elseif (twoD == 0 && highRes == 1) %&& pixCoords == 1)    % 3D, hi res
    NEMOpath = fullfile(NEMOlocation,'NEMO3dPT');
elseif (twoD == 0 && highRes == 0) %&& pixCoords == 0)    % 3D, lo res
    NEMOpath = fullfile(NEMOlocation,'NEMO3dlowbow');

% Commented out due to making pixel coordinates mandatory
% elseif (twoD == 1 && highRes == 1 && pixCoords == 0)    % 2D, hi res, no pix coords
%     NEMOpath = fullfile(NEMOlocation,'NEMOhibow');
% elseif (twoD == 0 && highRes == 1 && pixCoords == 0)    % 3D, hi res, no pix coords
%     NEMOpath = fullfile(NEMOlocation,'NEMO3dbow');
%     
% elseif (highRes == 0 && pixCoords == 1)          % low res (2D or 3D) with pixCoord
%                                                  % does not exist
%     fprintf('\nPixel coordinates for low resolution data not possible.\n')
%     noPix = input('Would you like to continue with no pixel coordinates? (Y,n) ','s');
%     if noPix == 'Y' || noPix == 'y'
%         if twoD == 1
%             NEMOpath = fullfile(NEMOlocation,'NEMOlowbow');
%         else
%             NEMOpath = fullfile(NEMOlocation,'NEMO3dlowbow');
%         end
%     else
%         deleteAll();
%         quit
%     end
end

%% Finding plot function path

% if 3D, only supports adult, freemotion
if (twoD == 0)
    if (strcmp(testType,'freemotion') == 1 && adultW == 1)
        plotpath = fullfile(plotslocation,'WTStandardPlots3D');     % 3D, adult, freemotion
    elseif (strcmp(testType,'phototaxis') == 1 && adultW == 1)
        plotpath = fullfile(plotslocation, 'WTPhototaxisPlots3D');  % 3D, adult, phototaxis
    else
        fprintf('\nFor now, this program only supports 3D analysis of FREEMOTION and PHOTOTAXIS of ADULT worms.\n')
        fprintf('Press any key to close the program.\n')
        pause
        deleteAll();
        quit
    end
    
% All other 2D cases
% If L1 worm, must be freemotion or phototaxis
elseif (twoD == 1 && adultW == 0)
    if strcmp(testType,'freemotion') == 1
        plotpath = fullfile(plotslocation,'L1StandardPlots2D');     % 2D, L1, freemotion
    elseif strcmp(testType,'phototaxis') == 1
        plotpath = fullfile(plotslocation,'L1PhototaxisPlots2D');   % 2D, L1, phototaxis
    else
        fprintf('\nFor now, this program only supports analysis of FREEMOTION and PHOTOTAXIS of L1 worms.\n')
        fprintf('Press any key to close the program.\n')
        pause
        deleteAll();
        quit
    end
    
% If adult, can be freemotion, electrotaxis, phototaxis, or thermotaxis
elseif (twoD == 1 && adultW == 1)
    if strcmp(testType, 'freemotion') == 1
        plotpath = fullfile(plotslocation,'WTFreemotionPlots2D');   % 2D, adult, freemotion
    elseif strcmp(testType,'electrotaxis') == 1
        plotpath = fullfile(plotslocation,'WTElectrotaxisPlots2D'); % 2D, adult, electrotaxis
    elseif strcmp(testType,'phototaxis') == 1
        plotpath = fullfile(plotslocation,'WTPhototaxisPlots2D');   % 2D, adult, phototaxis
    elseif strcmp(testType,'thermotaxis') == 1
        plotpath = fullfile(plotslocation,'WTStandardPlots2D');     % 2D, adult, thermootaxis
    else
        fprintf('\nThis program cannot handle the chosen settings.\n')
        fprintf('Press any key to close the program.\n')
        pause
        deleteAll();
        quit
    end
end

 
%% ***** PREPARING DIRECTORIES AND VARIABLES FOR SUB/NEMO ACCESS ***** %
% Makes sure the inputs to darkSub/NEMO will be 100% valid (won't cause
% them to crash and that right data is in appropriate dir

%% Frames
% Checks for valid frame range and creates dir with frames accessible to
% NEMO

fprintf('\nCopying frames...\n')

% fprintf('\nPress any key to continue.\n');
% pause

if  isFrames == 1     
    outFolderFrames = fullfile(mainOutFolder,'\frames');
    
    % Creates neat directory for frames data
    if ~exist(outFolderFrames,'dir')
        mkdir(outFolderFrames);
    end
    
    % Variable matrix holds all tif file names in inFolderFrames
    inFolderFramesInfo = dir([inFolderFrames,'\*.tif']);
    
    % If user left GUI end frame empty, end frame is set to last
    if endFrame == 9999
        endFrame = length(inFolderFramesInfo);
    end
        
    % Checks for start frame error
    if startFrame > length(inFolderFramesInfo)
        fprintf(split)
        fprintf('\nStart frame input is greater than actual number of frames in data (%d frames).\n',length(inFolderFramesInfo))
        fixStart = input('Would you like to set start frame to 1? (Y/n) ','s');
        if (fixStart == 'Y' || fixStart == 'y')
            startFrame = 1;
        else
            startFrame = input('Please input the start frame: ');
            while (startFrame > length(inFolderFramesInfo) || startFrame <= 0 ...
                    || startFrame > endFrame)
                startFrame = input('Invalid. Please input the start frame: ');
            end
        end
    end
    
    % Checks for end frame error
    if endFrame > length(inFolderFramesInfo)
        fprintf(split)
        fprintf('\nEnd frame input is greater than actual number of frames in data (%d frames).\n',length(inFolderFramesInfo))
        fixEnd = input('Would you like to set end frame to last frame in data? (Y/n) ','s');
        if (fixEnd == 'Y' || fixEnd == 'y')
            endFrame = length(inFolderFramesInfo);
        else
            endFrame = input('Please input the end frame: ');
            while (endFrame > length(inFolderFramesInfo) || endFrame <= 0 ...
                    || endFrame < startFrame)
                endFrame = input('Invalid. Please input the end frame: ');
            end
        end
    end
    
    % Checks for 100 frame minimum
    while endFrame - startFrame < 99
        fprintf('\nA minimum of 100 frames must be analyzed.\n')
        fprintf('\nThe selected directory has %d frames. Please enter again the start and end frames.\n',length(inFolderFramesInfo))
        startFrame = input('Start frame: ');
        endFrame = input('End frame: ');
        
        if endFrame > length(inFolderFramesInfo) || startFrame > length(inFolderFramesInfo) || startFrame > endFrame || startFrame < 1 || endFrame < 1
            fprintf('\nInvalid. Try again.\n')
            startFrame = 1;
            endFrame = 2;
        end
    end
    
    % If >999 frames, takes computational time. Asks user to be patient.
    if endFrame - startFrame > 999
        fprintf('\nPlease wait...\n')
    end
    
    % Once start and end frames are sure to be valid,
    % copy specified range of frames to appropriate dir
    for frameNum = startFrame:endFrame
        framePath = fullfile(inFolderFrames,inFolderFramesInfo(frameNum).name);
        copyfile(framePath, [outFolderFrames,'\',sprintf('%3.4d',frameNum),'.tif']);
    end
        
        
% If isFrames == 0, user picks video data to put its frames into
% accessible dir    
else
    fprintf('\nPress any key to continue.\n');
    pause
    frameMaker(startFrame, endFrame, vidFilePath);    % function that decomposes video
                                                     % and saves start to end frame
end
 

fprintf(split)

%% Platform offset text file
% Function that asks user for .txt file containing platform data. Converts 
% .txt file to xlsx and puts it in dir accessible to NEMO

% fprintf('\nPress any key to continue to select .txt file containing platform offset data.\n')
% pause

% get platform offest data path
% [txtName, txtDir] = uigetfile('*.txt*','Select .txt file with offset information');
% txtPath = fullfile(txtDir,txtName);

% funtion converting .txt to .xlsx, saves it under new dir in mainOutFolder
txt2xlsx(txtPath);

% cd to NEMO directory
cd(NEMOpath)

% fill in holes in offset data that and place excel in proper dir
fprintf('\nInterpolating missing data in platform offset file...\n')
interpxlsx();

fprintf(split);

%% Additional parameters for phototaxis
% Phototaxis plot functions require addition parameters (current of the
% laser and its on/off frame, info that is found in platform offset .txt
% file). Function extracts this information and saves to variables.

if strcmp(testType,'phototaxis') == 1
    % run function that gets laser on/off frame and its current
    [laserOnFrame, laserOffFrame, current] = laserOnOff(txtPath);
end


%% ***** DARKSUB RUN ***** %
% Outputs binarized .tif frames to <mainOutFolder>\binarized_frames

cd(darksublocation)

fprintf('\nWill now binarize the image data. Please follow the instructions as they appear.\n\n')

darkSub();

fprintf('Binarization of frames complete.\n');


%% ***** NEMO RUN ***** %
% Takes filepaths established wrt user answers to run appropriate versions
% of NEMO and plots

fprintf(split)
fprintf('\nWill now run NEMO. Press any key to continue.'); % may want to say 'skeletonizing', etc.
pause;
fprintf('\n\n')

cd(NEMOpath)
NEMO(startFrame, endFrame, segNum, FPS, pixpMM);

fprintf('\nNEMO successful. Press any key to generate plots.\n')
fprintf('\nIMPORTANT: Do NOT click on any of the windows as they appear.\n')
pause


%% ***** PLOTS RUN ***** %
% Follows path determined by user to plot programs and runs programs to
% generate plots in mainOutFolder directory.
cd(plotpath)

fprintf(split)
fprintf('\nGenerating plots...\n')

% calls main plot function. Calls main with additional parameters if
% phototaxis
if strcmp(testType,'phototaxis') == 1
    main('ID',laserOnFrame,laserOffFrame,current,gelatinCon);
else
    main('ID');
end
close all;

fprintf('\nGenerating plots successful. Press any key to continue to select data you would like to keep.')
pause
fprintf('\n')

%% ***** SAVING FILES ***** %
% Brings up GUI to allow user to check which files to keep. Ask for save
% location and moves selected files from mainOutFolder to specified dir.

% Removes renamed copies of frames from mainOutFolder
if exist([mainOutFolder,'\frames'],'dir')
    rmdir([mainOutFolder,'\frames'],'s')
end

% Set default for which files to keep
keepBinarizedFrames = 0;
makeBinarizedMovie = 0;
keepSkelCoords = 0;
keepPixCoords = 0;
keepPlots = 1;
keepExcelOffsetData = 0;
keepExcelOffsetDataInterp = 0;

% Call GUI to allow user to check which files to save
cd(fileparts(mfilename('fullpath')))
f2 = toKeepFiles();
waitfor(f2);

% Ask user where to save selected files
finalOutFolder = uigetdir('C:\', 'Select destination folder to save processed data');


% if checkbox for save binarized video true, create and save in destination
if makeBinarizedMovie == 1
    binary2mov(finalOutFolder);
end

% Move selected data to destination folder
if keepBinarizedFrames == 1
    movefile([mainOutFolder,'\binarized_frames'],finalOutFolder,'f')
end
if keepSkelCoords == 1 
    movefile([mainOutFolder,'\NEMO\NEMO_excel.xlsx'],finalOutFolder,'f')
end
if keepPixCoords == 1 
    movefile([mainOutFolder,'\NEMO\NEMO_excelpixelcoord.xlsx',],finalOutFolder,'f')
end
if keepPlots == 1 
    movefile([mainOutFolder,'\plots',],finalOutFolder,'f')
end
if keepExcelOffsetData == 1 
    movefile([mainOutFolder,'\pOffsetData\pOffsetData.xlsx',],finalOutFolder,'f')
end
if keepExcelOffsetDataInterp == 1 
    movefile([mainOutFolder,'\pOffsetData\pOffsetData_interp.xls',],finalOutFolder,'f')
end

    
%% CLEAN UP
% Delete all temporary files, clear variables, command line, and exit
% MATLAB

fprintf(split)
fprintf('\nFiles saved successfully. Press any key to clean up workspace and exit program.')
pause

deleteAll();

clc
clearvars

fprintf('Goodbye.')
pause(1)

quit