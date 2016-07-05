

disp('Please select the data folder you wish you analyze');
[PathName] = uigetdir; % this is the path of the file it looks at
MyDirInfo = dir([PathName, '\*.tif']); %finds all files in dir that are tif
dirSize = length(MyDirInfo);

select = input('Would you like to select a dark set? ');

mkdir('PT_TEST');
cd PT_TEST
stack = zeros(1024, 1024, dirSize);


if select == 1; 
    select2 = input('Are you using 405nm? ');

    if select2 == 1;
        disp('Please select a laser dark set.');
        
        [darkPath] = uigetdir;
        darkInfo = dir([darkPath, '\*.tif']);
        darkSize = length(darkInfo);
        
        laserOn = input('At what frame does the laser turn on? ');
             
        darkName = fullfile(darkPath, darkInfo(1).name);
        darkStill = imread(darkName);
        
        darkStack = zeros(1024, 1024, dirSize);
        
        for i = 1: laserOn-1;
            darkStack(:, :, i) = darkStill(:, :);
        end
        
        for i = laserOn+darkSize: dirSize;
            darkStack(:, :, i) = darkStill(:, :);
        end
        
        for i = laserOn:laserOn+darkSize-1;
            darkName = fullfile(darkPath, darkInfo(i+1-laserOn).name);
            darkLaser = imread(darkName);
            darkStack(:, :, i) = darkLaser(:, :);
        end
        
        for i = 1:dirSize;
            rawName = fullfile(PathName, MyDirInfo(i).name);
            raw = imread(rawName);
            stack(:, :, i) = raw(:, :);
        end
        
        stackSub = stack - darkStack;
        
        clear darkStack;
        clear stack;
        
        for i = 0:1;
            stackSub(:, :, laserOn+i) = stackSub(:, :, laserOn-1);
            stackSub(:, :, laserOn+darkSize-1+i) = stackSub(:, :, laserOn+darkSize-2);
        end
                    
        disp('Use the data cursor to determine a threshold value');
        imshow(stackSub(:, :, 1));
        caxis auto
        thresh = input('What is that threshold value? ');
        threshRange = linspace(thresh-2, thresh+2, 10);
        close all

        figure;
        subplot(2, 5, 10);

        startStack = zeros(1024, 1024, 10);
        for r = 1:10;   
            raw = stackSub(:, :, 1);
            rawCut = reshape(raw(213: 812, 213: 812), 600, 600); 
            BW = im2bw(rawCut, threshRange(r)/255);
            SpecR = bwareaopen(BW, 5000);
            WormErode = imerode(SpecR, ones(5,5));   
            WormMed = medfilt2(WormErode);
            WormDilate = imdilate(WormMed, ones(7, 7));
            WormErode2 = imerode(WormDilate, ones(5, 5));
            WormSpecR = bwareaopen(WormErode2, 2000);
            WormPad = padarray(WormSpecR, [212, 212]);
            WB = 1 - WormPad;
            startStack(:, :, r) = WB(:, :);
            subplot(2, 5, r);
            imshow(WB);
            title(strcat(['Threshold Parameter: ', num2str(r)]));
        end

        best = input('Which threshold looks the best? ');
        newThresh = threshRange(best);
        newThresh = newThresh/255;

        close all
        
        worm = find(startStack(:, :, best) == 0);
        wormSize = length(worm);

        for i = 1:laserOn-2;
            raw = stackSub(:, :, i);
            rawCut = reshape(raw(213: 812, 213: 812), 600, 600); 
            BW = im2bw(rawCut, newThresh);
            SpecR = bwareaopen(BW, 2000);
            WormErode = imerode(SpecR, ones(5,5));   
            WormMed = medfilt2(WormErode);
            WormDilate = imdilate(WormMed, ones(10, 10));
            WormErode2 = imerode(WormDilate, ones(5, 5));
            WormSpecR = bwareaopen(WormErode2, 2000);
            WormPad = padarray(WormSpecR, [212, 212]);
            if i == laserOn-2;
                boundWorm = regionprops(WormPad, 'BoundingBox');
                x1 = uint16(boundWorm.BoundingBox(2)) - 20;
                x2 = uint16(boundWorm.BoundingBox(2)+ boundWorm.BoundingBox(4)) + 20;
                y1 = uint16(boundWorm.BoundingBox(1)) - 20;
                y2 = uint16(boundWorm.BoundingBox(1)+ boundWorm.BoundingBox(3)) + 20;                
            end
            WB = 1 - WormPad;
            check = find(WB == 0);
            sizeWB = length(check);
            altThresh = best;
            if sizeWB > wormSize + 1500;
                while sizeWB > wormSize + 1500;
                    altThresh = altThresh + 1;
                    BW = im2bw(rawCut, threshRange(altThresh)/255);
                    SpecR = bwareaopen(BW, 5000);
                    WormErode = imerode(SpecR, ones(5,5));   
                    WormMed = medfilt2(WormErode);
                    WormDilate = imdilate(WormMed, ones(7, 7));
                    WormErode2 = imerode(WormDilate, ones(5, 5));
                    WormSpecR = bwareaopen(WormErode2, 2000);
                    WormPad = padarray(WormSpecR, [212, 212]);
                    WB = 1 - WormPad;
                    check = find(WB == 0);
                    sizeWB = length(check);
                end
            elseif sizeWB < wormSize - 4000;
                while sizeWB < wormSize - 4000;
                    altThresh = altThresh - 1;
                    BW = im2bw(rawCut, threshRange(altThresh)/255);
                    SpecR = bwareaopen(BW, 5000);
                    WormErode = imerode(SpecR, ones(5,5));   
                    WormMed = medfilt2(WormErode);
                    WormDilate = imdilate(WormMed, ones(7, 7));
                    WormErode2 = imerode(WormDilate, ones(5, 5));
                    WormSpecR = bwareaopen(WormErode2, 2000);
                    WormPad = padarray(WormSpecR, [212, 212]);
                    WB = 1 - WormPad;
                    check = find(WB == 0);
                    sizeWB = length(check);
                end
            end
            clear sizeWB
            clear check
            imwrite(WB, strcat(num2str(i), '.tif'));
        end   
        
        
        
        for i = laserOn-1:laserOn+darkSize;
            raw = stackSub(:, :, i);
            rawCut = reshape(raw(x1: x2, y1: y2), (x2-x1)+1, (y2-y1)+1); 
            BW = im2bw(rawCut, newThresh);
            SpecR = bwareaopen(BW, 2000);
            WormErode = imerode(SpecR, ones(3,3));   
            WormMed = medfilt2(WormErode);
            WormDilate = imdilate(WormMed, ones(10, 10));
            WormErode2 = imerode(WormDilate, ones(2, 2));
            WormMed2 = medfilt2(WormErode2);
            WormSpecR = bwareaopen(WormMed2, 2000);
            WormPad = zeros(1024, 1024);
            WormPad(x1: x2, y1:y2) = WormSpecR(:, :);         
            WB = 1 - WormPad;
   
                boundWorm = regionprops(WormPad, 'BoundingBox');
                x1 = uint16(boundWorm.BoundingBox(2)) - 20;
                x2 = uint16(boundWorm.BoundingBox(2)+ boundWorm.BoundingBox(4)) + 20;
                y1 = uint16(boundWorm.BoundingBox(1)) - 20;
                y2 = uint16(boundWorm.BoundingBox(1)+ boundWorm.BoundingBox(3)) + 20;         
            
            imwrite(WB, strcat(num2str(i), '.tif'));
        end     
        
        for i = laserOn+darkSize+1:dirSize;
            raw = stackSub(:, :, i);
            rawCut = reshape(raw(213: 812, 213: 812), 600, 600); 
            BW = im2bw(rawCut, newThresh);
            SpecR = bwareaopen(BW, 2000);
            WormErode = imerode(SpecR, ones(5,5));   
            WormMed = medfilt2(WormErode);
            WormDilate = imdilate(WormMed, ones(10, 10));
            WormErode2 = imerode(WormDilate, ones(3, 3));
            WormSpecR = bwareaopen(WormErode2, 2000);
            WormPad = padarray(SpecR, [212, 212]);
            WB = 1 - WormPad;
            check = find(WB == 0);
            sizeWB = length(check);
            altThresh = best;
            if sizeWB > wormSize + 2000;
                while sizeWB > wormSize + 2000;
                    altThresh = altThresh + 1;
                    BW = im2bw(rawCut, threshRange(altThresh)/255);
                    SpecR = bwareaopen(BW, 5000);
                    WormErode = imerode(SpecR, ones(5,5));   
                    WormMed = medfilt2(WormErode);
                    WormDilate = imdilate(WormMed, ones(7, 7));
                    WormErode2 = imerode(WormDilate, ones(5, 5));
                    WormSpecR = bwareaopen(WormErode2, 2000);
                    WormPad = padarray(WormSpecR, [212, 212]);
                    WB = 1 - WormPad;
                    check = find(WB == 0);
                    sizeWB = length(check);
                end
            elseif sizeWB < wormSize - 4000;
                while sizeWB < wormSize - 4000;
                    altThresh = altThresh - 1;
                    BW = im2bw(rawCut, threshRange(altThresh)/255);
                    SpecR = bwareaopen(BW, 5000);
                    WormErode = imerode(SpecR, ones(5,5));   
                    WormMed = medfilt2(WormErode);
                    WormDilate = imdilate(WormMed, ones(7, 7));
                    WormErode2 = imerode(WormDilate, ones(5, 5));
                    WormSpecR = bwareaopen(WormErode2, 2000);
                    WormPad = padarray(WormSpecR, [212, 212]);
                    WB = 1 - WormPad;
                    check = find(WB == 0);
                    sizeWB = length(check);
                end
            end
            clear sizeWB
            clear check
            imwrite(WB, strcat(num2str(i), '.tif'));
        end            
    else    
        disp('Please select your dark image');
        [FILENAME, PATHNAME] = uigetfile();
        dark = imread(strcat(PATHNAME, FILENAME));  

        fileName = fullfile(PathName, MyDirInfo(1).name);
        image = imread(fileName);
        image = image-dark;
        disp('Use the data cursor to determine a threshold value');
        imshow(image);
        thresh = input('What is that threshold value? ');
        threshRange = linspace(thresh-1, thresh+1, 10);
        close all

        figure(1) = subplot(2, 5, 10);
        for r = 1:10;
            rawCut = reshape(image(213: 812, 213: 812), 600, 600); 
            BW = im2bw(rawCut, threshRange(r)/255);
            SpecR = bwareaopen(BW, 5000);
            WormErode = imerode(SpecR, ones(5,5));   
            WormMed = medfilt2(WormErode);
            WormDilate = imdilate(WormMed, ones(10, 10));
            WormErode2 = imerode(WormDilate, ones(5, 5));
            WormSpecR = bwareaopen(WormErode2, 5000);
            WormPad = padarray(WormSpecR, [212, 212]);
            WB = 1 - WormPad;
            subplot(2, 5, r);
            imshow(WB);
            title(strcat(['Threshold Parameter: ', num2str(r)]));
        end

        best = input('Which threshold looks the best (count left to right)? ');
        threshRange = linspace(thresh-1, thresh+1, 10);
        newThresh = threshRange(best);
        close all

        for i = 1:dirSize;
            fileName = fullfile(PathName, MyDirInfo(i).name);
            raw = imread(fileName);
            rawDark = raw - dark;
            rawCut = reshape(rawDark(213: 812, 213: 812), 600, 600); 
            BW = im2bw(rawCut, newThresh/255);
            SpecR = bwareaopen(BW, 5000);
            WormErode = imerode(SpecR, ones(5,5));   
            WormMed = medfilt2(WormErode);
            WormDilate = imdilate(WormMed, ones(10, 10));
            WormErode2 = imerode(WormDilate, ones(5, 5));
            WormSpecR = bwareaopen(WormErode2, 5000);
            WormPad = padarray(WormSpecR, [212, 212]);
            WB = 1 - WormPad;
            imwrite(WB, strcat(num2str(i), '.tif'));
        end  
    end
else 
    fileName = fullfile(PathName, MyDirInfo(1).name);
    image = imread(fileName);
    disp('Use the data cursor to determine a threshold value');
    imshow(image);
    thresh = input('What is that threshold value? ');
    threshRange = linspace(thresh-2, thresh+2, 10);
    close all
    
    figure;
    subplot(2, 5, 10);
    
    startStack = zeros(1024, 1024, 10);
    for r = 1:10;   
        fileName = fullfile(PathName, MyDirInfo(1).name);
        raw = imread(fileName);
        rawCut = reshape(raw(213: 812, 213: 812), 600, 600); 
        BW = im2bw(rawCut, threshRange(r)/255);
        SpecR = bwareaopen(BW, 5000);
        WormErode = imerode(SpecR, ones(5,5));   
        WormMed = medfilt2(WormErode);
        WormDilate = imdilate(WormMed, ones(10, 10));
        WormErode2 = imerode(WormDilate, ones(5, 5));
        WormSpecR = bwareaopen(WormErode2, 5000);
        WormPad = padarray(WormSpecR, [212, 212]);
        WB = 1 - WormPad;
        startStack(:, :, r) = WB;
        imwrite(WB, strcat(num2str(i), '.tif'));
        subplot(2, 5, r);
        imshow(WB);
        title(strcat(['Threshold Parameter: ', num2str(r)]));
    end
    
    best = input('Which threshold looks the best? ');
    newThresh = threshRange(best);
    newThresh = newThresh/255;
    close all
    
    worm = find(startStack(:, :, best) == 0);
    wormSize = length(worm);
    
    for i = 1:dirSize;
        fileName = fullfile(PathName, MyDirInfo(i).name);
        raw = imread(fileName);
        rawCut = reshape(raw(213: 812, 213: 812), 600, 600); 
        BW = im2bw(rawCut, newThresh);
        SpecR = bwareaopen(BW, 5000);
%         Filled = imfill(SpecR,'holes');
%         Omega = Filled;
%         OmegaHole = Omega - BW;
%         OmegaSpecR = bwareaopen(OmegaHole, 1000);
%         Worm = Omega - OmegaSpecR;     
        WormErode = imerode(SpecR, ones(5,5));   
        WormMed = medfilt2(WormErode);
        WormDilate = imdilate(WormMed, ones(10, 10));
        WormErode2 = imerode(WormDilate, ones(5, 5));
        WormSpecR = bwareaopen(WormErode2, 2000);
        WormPad = padarray(WormSpecR, [212, 212]);
        WB = 1 - WormPad;
        check = find(WB == 0);
        sizeWB = length(check);
        altThresh = best;
        if sizeWB > wormSize + 1000;
            while sizeWB > wormSize + 1000;
                altThresh = altThresh + 1;
                raw = imread(fileName);
                rawCut = reshape(raw(213: 812, 213: 812), 600, 600); 
                BW = im2bw(rawCut, threshRange(altThresh)/255);
                SpecR = bwareaopen(BW, 5000);
                WormErode = imerode(SpecR, ones(5,5));   
                WormMed = medfilt2(WormErode);
                WormDilate = imdilate(WormMed, ones(10, 10));
                WormErode2 = imerode(WormDilate, ones(5, 5));
                WormSpecR = bwareaopen(WormErode2, 2000);
                WormPad = padarray(WormSpecR, [212, 212]);
                WB = 1 - WormPad;
                check = find(WB == 0);
                sizeWB = length(check);
            end
        elseif sizeWB < wormSize - 1000;
            while sizeWB < wormSize - 1000;
                altThresh = altThresh - 1;
                raw = imread(fileName);
                rawCut = reshape(raw(213: 812, 213: 812), 600, 600); 
                BW = im2bw(rawCut, threshRange(altThresh)/255);
                SpecR = bwareaopen(BW, 5000);
                WormErode = imerode(SpecR, ones(5,5));   
                WormMed = medfilt2(WormErode);
                WormDilate = imdilate(WormMed, ones(10, 10));
                WormErode2 = imerode(WormDilate, ones(5, 5));
                WormSpecR = bwareaopen(WormErode2, 2000);
                WormPad = padarray(WormSpecR, [212, 212]);
                WB = 1 - WormPad;
                check = find(WB == 0);
                sizeWB = length(check);
            end
        end   
        clear sizeWB
        clear check
        imwrite(WB, strcat(num2str(i), '.tif'));
    end
end


