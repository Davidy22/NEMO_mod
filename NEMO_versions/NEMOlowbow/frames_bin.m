function numberOfFrames=frames_bin()
% Macro to extract frames and get frame means from an avi movie
% and save individual frames to separate image files.
% Then rebuilds a new movie by recalling the saved images from disk.
% Also computes the mean gray value of the color channels
% And detects the difference between a frame and the previous frame.

global vidHeight
global vidWidth
global folderName
global baseFileName


premo;

% Open the avi movie with MATLAB.
folder = fullfile(oldfolder);
[baseFileName, folderName, FilterIndex] = uigetfile({'*.avi';'*.mov';'*.mp4'},'Select video you wish to analyze');
% 		if ~isequal(baseFileName, 0)
			movieFullFileName = fullfile(folderName, baseFileName);
% 		else
% 			return;
%         end

        %mov=VideoReader(movieFullFileName);
        
%try
	videoObject = VideoReader(movieFullFileName)
	% Determine how many frames there are.
	numberOfFrames = videoObject.NumberOfFrames;
	vidHeight = videoObject.Height;
	vidWidth = videoObject.Width;
	
	numberOfFramesWritten = 0;
	
	
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

	
	% Loop through the movie, writing all frames out.
	% Each frame will be in a separate file with unique name.
	meanGrayLevels = zeros(numberOfFrames, 1);
	meanRedLevels = zeros(numberOfFrames, 1);
	meanGreenLevels = zeros(numberOfFrames, 1);
	meanBlueLevels = zeros(numberOfFrames, 1);
    
	for frame = 1 : numberOfFrames
        
        thisFrame = read(videoObject,frame);
        % Create a filename.
        if writeToDisk
            outputBaseFileName = sprintf('%1d.png', frame);
            outputFullFileName = fullfile(outputFolder, outputBaseFileName);
            % Write it out to disk.
            img=im2double(rgb2ycbcr(thisFrame));
            img=img(:,:,1);
            img_mean=mean(mean(img));
            img_std=std2(img);
            img_bin=im2bw(img,graythresh(img));
            imwrite(img_bin, outputFullFileName, 'png');
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
	
	% Alert user that we're done.
	if writeToDisk
		finishedMessage = sprintf('Done!  It wrote %d frames to folder\n"%s"', numberOfFramesWritten, outputFolder);
	else
		finishedMessage = sprintf('Done!  It processed %d frames of\n"%s"', numberOfFramesWritten, movieFullFileName);
	end
	disp(finishedMessage); % Write to command window.
	msgbox(finishedMessage); % Also pop up a message box.
	
	% Exit if they didn't write any individual frames out to disk.
	if ~writeToDisk
		return;
    end
            
            
	
%catch ME
	% Some error happened if you get here.
	%strErrorMessage = sprintf('Error extracting movie frames from:\n\n%s\n\nError: %s\n\n)', movieFullFileName, ME.message);
	%uiwait(msgbox(strErrorMessage));
%end
