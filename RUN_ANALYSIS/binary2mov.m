function binary2mov( outFolder )
%BINARY2MOV rearranges 
%   Detailed explanation goes here

global mainOutFolder

% take name of all tif files in binarized frame dir
list = dir([mainOutFolder,'\binarized_frames\*.tif']);
name = {list.name}; % stores names into matrix that is 1 x numFrames

% will reorder frames in numerical order
str = sprintf('%s#', name{:});
num = sscanf(str, 'frame%d.tif#');
[~, index] = sort(num);
name = name(index);


outMov = VideoWriter([outFolder,'\binary_mov.avi']);
outMov.FrameRate = 30;

open(outMov)

for ii = 1:length(name)
    img = imread(fullfile([mainOutFolder,'\binarized_frames\',name{ii}]));
    writeVideo(outMov,img);
end

close(outMov)

end

