function frames_bin(start,finish)

%Extracts individual frames from three AVI movies.
%
%INPUTS:
%   start: first frame number
%   finish: last frame number
%
%  -Three binarized videos, of square resolution (height=width), 
%   synchronized at the first frame, with black animal on a white background.
%
%OUTPUTS:
%  -Individual frames saved in their respective subfolders under the
%   /DATA_MASTER folder.


global vidsz
global folderName
global univFileName

oldfolder=pwd;

%%%%%%%%%%%%%%%%%%%SIDE1
folder = fullfile(oldfolder);
    [baseFileName, folderName, FilterIndex] = uigetfile({'*.avi';'*.mov';'*.mp4'},'Select video labeled SIDE1');
        movieFullFileName = fullfile(folderName, baseFileName)

suffixindex=strfind(baseFileName,'_side1');
univFileName=baseFileName(1:suffixindex-1);

baseFileName2=[univFileName,'_side2.avi'];
baseFileName3=[univFileName,'_top.avi'];

videoObject = VideoReader(movieFullFileName)
% Determine how many frames there are.
numberOfFrames = videoObject.NumberOfFrames;
vidsz = videoObject.Height;                                                 %saves size of video
numberOfFramesWritten = start-1;                                            %assumes square video

% Ask user if they want to write the individual frames out to disk.
    writeToDisk = true;

    % Extract out the various parts of the filename.
    [folder, baseFileName, extentions] = fileparts(movieFullFileName);
    % Make up a special new output subfolder for all the separate
    % movie frames that we're going to extract and save to disk.
    % (Don't worry - windows can handle forward slashes in the folder name.)
    folder = pwd;   % Make it a subfolder of the folder where this m-file lives.
    outputFolder = sprintf('DATA_MASTER/side1', folder, baseFileName);
    % Create the folder if it doesn't exist already.
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end

for frame = start:finish

    thisFrame = read(videoObject,frame);
    % Create a filename.
    if writeToDisk
        outputBaseFileName = sprintf(['1_','%1d.png'], frame);
        outputFullFileName = fullfile(outputFolder, outputBaseFileName);
        % Write it out to disk.
        img=im2double(rgb2ycbcr(thisFrame));
        img=img(:,:,1);
        img_mean=mean(mean(img));
        img_std=std2(img);
        img_bin=im2bw(img,img_mean-1*img_std);
        imwrite(img_bin, outputFullFileName, 'png');
    end

    % Update user with the progress.  Display in the command window.
    if writeToDisk
        progressIndication = sprintf('Wrote frame %4d of %d. for SIDE1', frame, numberOfFrames);
    else
        progressIndication = sprintf('Processed frame %4d of %d. for SIDE1', frame, numberOfFrames);
    end
    disp(progressIndication);
    % Increment frame count (should eventually = numberOfFrames
    % unless an error happens).
    numberOfFramesWritten = numberOfFramesWritten + 1;
end


%%%%%%%%%%%%%%%%%%%SIDE2
movieFullFileName = fullfile(folderName, baseFileName2)

videoObject=VideoReader(movieFullFileName)
% Determine how many frames there are.
numberOfFrames = videoObject.NumberOfFrames;
numberOfFramesWritten = start-1;

% Ask user if they want to write the individual frames out to disk.
    writeToDisk = true;

    % Extract out the various parts of the filename.
    [folder, baseFileName, extentions] = fileparts(movieFullFileName);
    % Make up a special new output subfolder for all the separate
    % movie frames that we're going to extract and save to disk.
    % (Don't worry - windows can handle forward slashes in the folder name.)
    folder = pwd;   % Make it a subfolder of the folder where this m-file lives.
    outputFolder = sprintf('DATA_MASTER/side2', folder, baseFileName);
    % Create the folder if it doesn't exist already.
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end

for frame = start:finish

    thisFrame = read(videoObject,frame);
    % Create a filename.
    if writeToDisk
        outputBaseFileName = sprintf(['2_','%1d.png'], frame);
        outputFullFileName = fullfile(outputFolder, outputBaseFileName);
        % Write it out to disk.
        img=im2double(rgb2ycbcr(thisFrame));
        img=img(:,:,1);
        img_mean=mean(mean(img));
        img_std=std2(img);
        img_bin=im2bw(img,img_mean-1*img_std);
        imwrite(img_bin, outputFullFileName, 'png');
    end

    % Update user with the progress.  Display in the command window.
    if writeToDisk
        progressIndication = sprintf('Wrote frame %4d of %d. for SIDE2', frame, numberOfFrames);
    else
        progressIndication = sprintf('Processed frame %4d of %d. for SIDE2', frame, numberOfFrames);
    end
    disp(progressIndication);
    % Increment frame count (should eventually = numberOfFrames
    % unless an error happens).
    numberOfFramesWritten = numberOfFramesWritten + 1;
end


%%%%%%%%%%%%%%%%%%%TOP
folder = fullfile(oldfolder);
        movieFullFileName = fullfile(folderName, baseFileName3);

videoObject=VideoReader(movieFullFileName)
% Determine how many frames there are.
numberOfFrames = videoObject.NumberOfFrames;
numberOfFramesWritten = start-1;

% Ask user if they want to write the individual frames out to disk.
    writeToDisk = true;

    % Extract out the various parts of the filename.
    [folder, baseFileName, extentions] = fileparts(movieFullFileName);
    % Make up a special new output subfolder for all the separate
    % movie frames that we're going to extract and save to disk.
    % (Don't worry - windows can handle forward slashes in the folder name.)
    folder = pwd;   % Make it a subfolder of the folder where this m-file lives.
    outputFolder = sprintf('DATA_MASTER/top', folder, baseFileName);
    % Create the folder if it doesn't exist already.
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end

for frame = start:finish

    thisFrame = read(videoObject,frame);
    % Create a filename.
    if writeToDisk
        outputBaseFileName = sprintf(['3_','%1d.png'], frame);
        outputFullFileName = fullfile(outputFolder, outputBaseFileName);
        % Write it out to disk.
        img=im2double(rgb2ycbcr(thisFrame));
        img=img(:,:,1);
        img_mean=mean(mean(img));
        img_std=std2(img);
        img_bin=im2bw(img,img_mean-1*img_std);
        imwrite(img_bin, outputFullFileName, 'png');
    end

    % Update user with the progress.  Display in the command window.
    if writeToDisk
        progressIndication = sprintf('Wrote frame %4d of %d. for TOP', frame, numberOfFrames);
    else
        progressIndication = sprintf('Processed frame %4d of %d. for TOP', frame, numberOfFrames);
    end
    disp(progressIndication);
    % Increment frame count (should eventually = numberOfFrames
    % unless an error happens).
    numberOfFramesWritten = numberOfFramesWritten + 1;
end

cd(oldfolder)
