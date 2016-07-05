function bulk=extract_object(start,finish)

    premo;

    for s=start:finish

        disp(['Extracting mask and skeleton for frame ' int2str(s)])  %shows to the user the current file

        %change the directory
        cd 'DATA'
        %Read image based on number given by parameter
        A=imread([int2str(s) '.png']); 

        %Convert RGB image or colormap to grayscale
%         GRAY=rgb2gray(A);

        %Convert image to binary image, based on threshold
        cw=1-A;

        %Remove small objects from binary image
        [labeledImage, numberOfBlobs] = bwlabel(cw);
        blobMeasurements = regionprops(labeledImage, 'area');
        allAreas = [blobMeasurements.Area];
        [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
        biggestBlob = ismember(labeledImage, sortIndexes(1));
        cw = biggestBlob > 0;
        %Convert image to double precision
        maskBW=im2double(cw);   

%         SE=strel('disk',1);
%         BW=imerode(BW,SE);
%         maskBW=imdilate(BW,SE);

        skelBW=bwmorph(maskBW,'thin',Inf);
        skelBW=im2double(skelBW);

        cd .. 

        %change the folder to the data_saved folder 
        cd ('DATA_SAVED')

        %save the file1
        file1=['mask_' int2str(s)];
        save(file1,'maskBW', '-ascii');
        %save the file2
        file2=['skeleton_' int2str(s)];
        save(file2,'skelBW', '-ascii');

        %change the directory to the old folder
        cd (oldfolder);

    end    

    msgbox('Extractions done, brah! #matlab')
end
