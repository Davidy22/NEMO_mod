function frameROI(start,finish,calibration)

global mainOutFolder
global COMlist
premo;
oldfolder = pwd;

for image=start:finish

    if image==start

        cd ('C:/FOR_ANALYSIS/binarized_frames');
        first_frame=imread(['frame', int2str(start) '.tif']);
        %first_binary=bwareaopen(first_binary,round(calibration^1.2));
        
        warning('off','all')
%         fig1=figure;
        title('Choose worm of interest');
        imshow(first_frame);
%         fig1;
        [c,r,p]=impixel(first_frame);
 
        close(gcf); 
        
        warning('on','all')

        cd(oldfolder)
        COMlist=[];
%         COM=centerpoints(image,image,COM,calibration);
    else

        cd(oldfolder)
%         COM=centerpoints(image,image,COM,calibration);
    end
end
COMlist