function frameMakerMod(start, finish)

%Extracts individual frames from video file.
%
%INPUTS:
%   start: first frame number
%   finish: last frame number
%
%  -One video.
%
%OUTPUTS:
%  -Individual frames saved in their respective subfolders under 
%  C:\FOR_ANALYSIS\frames directory.

%Putting video file selected by user in variable mov
%Two variables to hold mov file name and path
[movFilename, movPathname] = uigetfile( ...
    {'*.avi;*.mpg;*.mpeg','Video Files (*.avi,*.mpg,*.mpeg)';
     '*.*',  'All Files (*.*)'}, ...
     'Select a video file');
mov = VideoReader(fullfile(movPathname,movFilename));

fprintf('Decomposing video into frames...\n');

%First creates file path for directory snaps
%Creates temp dir FOR_ANALYSIS under C: drive
outFolder = fullfile('C:\FOR_ANALYSIS','frames');
%Checks if a directory with filepath above exists. If not, creates it.
if ~exist(outFolder,'dir')
    mkdir(outFolder);
end

numFrames = mov.NumberOfFrames;
numFramesWritten = 0;

%For loop will iterate over all frames
for t = start:finish
    currFrame = read(mov,t);
    nameFrame = sprintf('%3.4d.png', t);        %Set name of file. %3.4d sets 3 digits of precision and displays 4 digits. % is holder for t, which is appended to name.
    pathFrame = fullfile(outFolder,nameFrame);  %Below sets full path to each frame.
    imwrite(currFrame,pathFrame,'png');         %Writing frame to file path
    %progressIndic = sprintf('Wrote frame %4d of %d.',t,numFrames);
    %disp(progressIndic);
    numFramesWritten = numFramesWritten + 1;
end

disp(sprintf('\nWrote %d frames to folder "%s" directly under C: drive\n', numFramesWritten, outFolder));