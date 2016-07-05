function skelmanu=skel_correct(image)
%remove manually the extra bits along the skeleton
%   COPYRIGHT:  George D. Tsibidis(1) and Nektarios Tavernarakis(2)
%               (1) Institute of Electronic Structure and Laser 
%               (2) Institute of Molecular Biology and Biotechnology 
%               Foundation for Research and Technology-Hellas (FORTH)
%               January 2007
%

premo;
s=0;

while s==0
    %cd(oldfolder);
    %cd('DATA');
    
    
    cd(oldfolder);
    cd ('DATA_SAVED');

    A=load(['skeleton_' int2str(image)]);
    file3=['mackup_', int2str(image)];
    save(file3,'A', '-ascii');
    
    fig2=figure('name','Correct this skeleton');imshow(A,'InitialMagnification',100);
    fig2;

    cd(oldfolder)
    [C,R,p]=impixel(A);
%     C=round(C);
%     R=round(R);
    C_new=C(1:end);
    R_new=R(1:end);

    for k=1:length(C_new)
        A(R_new(k),C_new(k))=0;  

    end

    [labeledImage, numberOfBlobs] = bwlabel(A);
    blobMeasurements = regionprops(labeledImage, 'area');
    allAreas = [blobMeasurements.Area];
    [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
    biggestBlob = ismember(labeledImage, sortIndexes(1));
    BW3 = biggestBlob > 0;
    
    
    
%     BW3=bwareaopen(A, prunesize);
    BW3=im2double(BW3);

    fig3=figure;imshow(BW3,'InitialMagnification',100);
    close(fig2);
    fig3;

    cd ('DATA_SAVED');
    promptMessage=sprintf('Is the correction satisfactory?');
    button = questdlg(promptMessage, 'Continue?','Yes','No','Yes');
    if strcmp(button, 'Yes');
        s=1;
        F=(['mackup_' int2str(image)]);
        delete(F);
        close(fig3);
    else
        s=0;
        close(fig3);
        H=load(['mackup_' int2str(image)]);
        file4=['skeleton_' int2str(image)];
        save(file4,'H', '-ascii');
        F=(['mackup_' int2str(image)]);
        delete(F)
        
    end
end

file5=['skeleton_' int2str(image)];
save(file5,'BW3','-ascii');

cd (oldfolder)
