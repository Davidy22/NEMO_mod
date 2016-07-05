function frames_bin(start,finish)

%Extracts individual frames from one AVI movie.
%
%INPUTS:
%   start: first frame number
%   finish: last frame number
%
%  -One binarized video.
%
%OUTPUTS:
%  -Individual frames saved in their respective subfolders under the
%   /DATA_MASTER folder.


global vidHeight
global vidWidth
global folderName
global baseFileName

oldfolder=pwd;

% Open the avi movie with MATLAB.
folder = fullfile(oldfolder);
    [baseFileName, folderName, FilterIndex] = uigetfile({'*.avi';'*.mov';'*.mp4'},'Select video you wish to analyze');
        movieFullFileName = fullfile(folderName, baseFileName);
        
videoObject = VideoReader(movieFullFileName)
% Determine how many frames there are.
numberOfFrames = videoObject.NumberOfFrames;
vidHeight = videoObject.Height;
vidWidth = videoObject.Width;

numberOfFramesWritten = start-1;

% Ask user if they want to write the individual frames out to disk.
    writeToDisk = true;

    % Extract out the various parts of the filename.
    [folder, baseFileName, extentions] = fileparts(movieFullFileName);
    % Make up a special new output subfolder for all the separate
    % movie frames that we're going to extract and save to disk.
    % (Don't worry - windows can handle forward slashes in the folder name.)
    folder = pwd;   % Make it a subfolder of the folder where this m-file lives.
    outputFolder = sprintf('DATA_MASTER', folder, baseFileName);
    % Create the folder if it doesn't exist already.
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end

for frame = start:finish

    thisFrame = read(videoObject,frame);
    % Create a filename.
    if writeToDisk
        outputBaseFileName = sprintf('%1d.png', frame);
        outputFullFileName = fullfile(outputFolder, outputBaseFileName);
        % Write it out to disk.
        imwrite(thisFrame, outputFullFileName, 'png');
    end


    % Update user with the progress.  Display in the command window.
    if writeToDisk
        progressIndication = sprintf('Wrote frame %4d of %d.', frame, numberOfFrames);
    else
        progressIndication = sprintf('Processed frame %4d of %d.', frame, numberOfFrames);
    end
    disp(progressIndication);
    % Increment frame count (should eventually = numberOfFrames
    % unless an error happens).
    numberOfFramesWritten = numberOfFramesWritten + 1;
end
