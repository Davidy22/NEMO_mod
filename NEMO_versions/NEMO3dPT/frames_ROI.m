function frames_ROI(start,finish,pxpmm)

%Crops each frame, based around center of bounding box containing the animal, and saves the pixel offset.
%
%INPUTS:
%   start: first frame number
%   finish: last frame number
%   pxpmm: pixels per millimeter
%
%  -Individual frames saved in their respective subfolders under the
%   /DATA_MASTER folder.
%
%OUTPUTS:
%  -Individual cropped frames saved in in their respective subfolders under
%   the /DATA folder.
%  -Pixel offsets for each cropped image, saved in global variables
%   COMlistxz, COMlistyz, COMlistxy.


global COMlistxz
global COMlistyz
global COMlistxy

oldfolder=pwd;

for image=start:finish

    if image==start

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Choosing worm from initial frames
        %%%SIDE1
        cd(oldfolder)
        cd('DATA_MASTER/side1');
        first_frame=imread(['1_' int2str(start) '.png']);

        fig1=figure('name','Choose worm of interest for SIDE1');imshow(first_frame);
        fig1;
        [c,r,p]=impixel(first_frame);
        COM1=[r,c];

        close(gcf);
        
        %%%SIDE2
        cd(oldfolder)
        cd('DATA_MASTER/side2');
        first_frame=imread(['2_' int2str(start) '.png']);

        fig1=figure('name','Choose worm of interest for SIDE2');imshow(first_frame);
        fig1;
        [c,r,p]=impixel(first_frame);
        COM2=[r,c];

        close(gcf);
        
        %%%TOP
        cd(oldfolder)
        cd('DATA_MASTER/top');
        first_frame=imread(['3_' int2str(start) '.png']);

        fig1=figure('name','Choose worm of interest for TOP');imshow(first_frame);
        fig1;
        [c,r,p]=impixel(first_frame);
        COM3=[r,c];

        close(gcf);
        
        
        %%%%%%%%%%%%%%%%%%%%%Cropping based on center point of bounding box
        cd(oldfolder)
        COMlistxz=[];
        [COM1]=centerpoints1(image,COM1,pxpmm);
        COMlistxz=[COMlistxz;COM1];
        
        cd(oldfolder)
        COMlistxy=[];
        [COM3]=centerpoints2(image,COM3,pxpmm);
        COMlistxy=[COMlistxy;COM3];
        
        cd(oldfolder)
        COMlistyz=[];
        [COM2]=centerpoints3(image,COM2,pxpmm);
        COMlistyz=[COMlistyz;COM2];
    else

        %%%%%%%%%%%%%%%%%%%%%Cropping based on center point of bounding box
        %%%%%%%%%%%%%%%%%%%%%Center points based on previous center points
        cd(oldfolder)
        [COM1]=centerpoints1(image,COM1,pxpmm);
        COMlistxz=[COMlistxz;COM1];
        
        cd(oldfolder)
        [COM3]=centerpoints2(image,COM3,pxpmm);
        COMlistxy=[COMlistxy;COM3];
        
        cd(oldfolder)
        [COM2]=centerpoints3(image,COM2,pxpmm);
        COMlistyz=[COMlistyz;COM2];
    end
end

cd(oldfolder)