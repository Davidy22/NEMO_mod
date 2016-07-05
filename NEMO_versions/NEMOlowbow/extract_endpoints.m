function finish=extract_endpoints(start,finish)
%
%
%   COPYRIGHT:  George D. Tsibidis(1) and Nektarios Tavernarakis(2)
%               (1) Institute of Electronic Structure and Laser 
%               (2) Institute of Molecular Biology and Biotechnology 
%               Foundation for Research and Technology-Hellas (FORTH)
%               January 2007
%
%
%Objective: to extract all animals from images
%
% Input: start: first image
%        finish: final image
%       correct: use correction algorithm to see the front and the tail of
%                the object. In our case we have always to put correct=1 so
%                that we will know which one is the front and which the
%                back part of the animal
%       threshold: threshold used for images
%       N: number of segments
%       frames_per_sec: frames per sec
%

%DESCRIPTION:This is a matalb file that uses machine vision to extract in an
%automated way a number of image files and data aimed to elucidate the
%movement and behaviour of C.elegans.
%

premo

cd(oldfolder)
phase=load('phase.csv');
        
  %EXTRACT IMAGE AND DATA FILES FROM ALL IMAGES
  
for image=start:finish

    if image==start
        
        cd ('DATA_SAVED')
        
        first_skeleton=load(['skeleton_' int2str(start)]);
        fig1=figure('name','Choose head, then tail');
        imshow(first_skeleton)
        
        [c,r,p]=impixel(first_skeleton);
        A=[c(1),r(1)];
        B=[c(2),r(2)];
        
        close(gcf)
      
        cd (oldfolder)
        [A,B]=endpoints(image,A,B,start,phase);
    else

        cd (oldfolder)
        [A,B]=endpoints(image,A,B,start,phase);
    end
    
end

cd (oldfolder)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


