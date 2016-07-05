disp('Please select the data folder you wish you analyze');
[PathName] = uigetdir;
MyDirInfo = dir([PathName, '\*.tif']);
dirSize = length(MyDirInfo);

select = input('Would you like to select a dark set? ');

mkdir('PT_TEST');
cd PT_TEST

if select == 1; 
    select2 = input('Are you using 405nm? ');
    
    if select2 == 1;
        disp('Please select a laser dark set.');
        
        [darkPath] = uigetdir;
        darkInfo = dir([darkPath, '\*.tif']);
        darkSize = length(darkInfo);
        
        laserOn = input('At what frame does the laser turn on? ');
        laserOff = input('At what frame does the laser turn off? ');
        omegaTurnStart = input('At what frame(s) does the worm start its Omega turn(s)?' );
        omegaTurnEnd = input('At what frame(s) does the worm end its Omega turn(s)?' );
        omegaCount = length(omegaTurnStart);     
        
        darkName = fullfile(darkPath, darkInfo(1).name);
        darkStill = imread(darkName);
        imSize = length(darkStill);
        
        frame1 = fullfile(PathName, MyDirInfo(1).name);
        firstFrame = imread(frame1);
        
        frameD = firstFrame - darkStill;
                    
        imshow(frameD);
        caxis auto
        thresh = 2;
        threshRange = linspace(thresh-2, thresh+2, 10);
        close all

        figure;
        subplot(2, 5, 10);

        startStack = zeros(1024, 1024, 10);
        for r = 1:10;   
            BW = im2bw(frameD, threshRange(r)/255);
            SpecR = bwareaopen(BW, 300);
            WormErode = imerode(SpecR, ones(3,3));   
            WormMed = medfilt2(WormErode);
            WormDilate = imdilate(WormMed, ones(4, 4));
            WormErode2 = imerode(WormDilate, ones(3, 3));
            WormSpecR = bwareaopen(WormErode2, 300);
            WB = 1 - WormSpecR;
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

        BW = im2bw(frameD, newThresh);
        SpecR = bwareaopen(BW, 300);
        WormErode = imerode(SpecR, ones(3,3));   
        WormMed = medfilt2(WormErode);
        WormDilate = imdilate(WormMed, ones(4, 4));
        WormErode2 = imerode(WormDilate, ones(3, 3));
        WormSpecR = bwareaopen(WormErode2, 300);

        [wormLabel, num] = bwlabel(WormSpecR);
        if num > 1;
            imshow(wormLabel);
            caxis auto
            disp('Please click on the worm.');
            [X, Y] = ginput(1);
            X = uint16(X);
            Y = uint16(Y);
            value = wormLabel(Y, X);
            wormIndex = wormLabel == value;
            wormLabel(wormIndex) = 1;
            wormLabel(~wormIndex) = 0; 
        end

        box = 100;

            boundWorm = regionprops(wormLabel, 'BoundingBox');
            x1 = uint16(boundWorm.BoundingBox(2)) - box;
            x2 = uint16(boundWorm.BoundingBox(2)+ boundWorm.BoundingBox(4)) + box;
            y1 = uint16(boundWorm.BoundingBox(1)) - box;
            y2 = uint16(boundWorm.BoundingBox(1)+ boundWorm.BoundingBox(3)) + box;   

        worm = find(wormLabel == 1);
        wormSize = length(worm);
        cst = 1000;

        for i = 1:laserOn-1;
            fileName = fullfile(PathName, MyDirInfo(i).name);
            raw = imread(fileName);
            frameD = raw - darkStill;
            rawCut = reshape(frameD(x1: x2, y1: y2), (x2-x1)+1, (y2-y1)+1); 
            BW = im2bw(rawCut, newThresh);
            SpecR = bwareaopen(BW, 300);
            %WormFill = imfill(SpecR, 'holes');
            WormErode = imerode(SpecR, ones(3,3));   
            WormMed = medfilt2(WormErode);
            WormDilate = imdilate(WormMed, ones(5, 5));
            WormErode2 = imerode(WormDilate, ones(3, 3));
            WormSpecR = bwareaopen(WormErode2, 300);
            WormPad = zeros(imSize, imSize);
            WormPad(x1: x2, y1:y2) = WormSpecR(:, :);  
            [wormLabel, num] = bwlabel(WormPad);
            clear x1
            clear x2
            clear y1
            clear y2
            if num > 1;
                for n = 1:num;
                    object = find(wormLabel == n);
                    objectSize = length(object);
                    if objectSize > wormSize + cst;
                        wormLabel(object) = 0;
                    elseif objectSize < wormSize - cst;
                        wormLabel(object) = 0;
                    else 
                        wormLabel(object) = 1;
                    end
                end

                [wormLabel2, num2] = bwlabel(wormLabel);
                if num2 > 1;
                    imshow(wormLabel2);
                    caxis auto
                    disp('Please click on the worm.');
                    [X, Y] = ginput(1);
                    X = uint16(X);
                    Y = uint16(Y);
                    value = wormLabel2(Y, X);
                    wormIndex = wormLabel2 == value;
                    wormLabel2(wormIndex) = 1;
                    wormLabel2(~wormIndex) = 0; 
                end 
                wormLabel = wormLabel2;

                WB = 1 - wormLabel;
            else
                WB = 1 - WormPad;
            end
            check = find(WB == 0);
            sizeWB = length(check);
            altThresh = best;
            if sizeWB > wormSize + cst;
                while sizeWB > wormSize + cst;
                    altThresh = altThresh + 1;
                    BW = im2bw(rawCut, threshRange(altThresh)/255);
                    SpecR = bwareaopen(BW, 300);
                    %WormFill = imfill(SpecR, 'holes');
                    WormErode = imerode(SpecR, ones(3,3));   
                    WormMed = medfilt2(WormErode);
                    WormDilate = imdilate(WormMed, ones(5, 5));
                    WormErode2 = imerode(WormDilate, ones(3, 3));
                    WormSpecR = bwareaopen(WormErode2, 300);
                    WormPad = zeros(imSize, imSize);
                    WormPad(x1: x2, y1:y2) = WormSpecR(:, :);  
                    [wormLabel, num] = bwlabel(WormPad);
                    if num > 1;
                        for n = 1:num;
                            object = find(wormLabel == n);
                            objectSize = length(object);
                            if objectSize > wormSize + cst;
                                wormLabel(object) = 0;
                            elseif objectSize < wormSize - cst;
                                wormLabel(object) = 0;
                            else 
                                wormLabel(object) = 1;
                            end
                        end

                        [wormLabel2, num2] = bwlabel(wormLabel);
                        if num2 > 1;
                            imshow(wormLabel2);
                            caxis auto
                            disp('Please click on the worm.');
                            [X, Y] = ginput(1);
                            X = uint16(X);
                            Y = uint16(Y);
                            value = wormLabel2(Y, X);
                            wormIndex = wormLabel2 == value;
                            wormLabel2(wormIndex) = 1;
                            wormLabel2(~wormIndex) = 0; 
                        end 
                        wormLabel = wormLabel2;

                        WB = 1 - wormLabel;
                    else
                        WB = 1 - WormPad;
                    end
                    check = find(WB == 0);
                    sizeWB = length(check);
                end
            elseif sizeWB < wormSize - cst;
                while sizeWB < wormSize - cst;
                    altThresh = altThresh - 1;
                    BW = im2bw(rawCut, threshRange(altThresh)/255);
                    SpecR = bwareaopen(BW, 300);
                    %WormFill = imfill(SpecR, 'holes');
                    WormErode = imerode(SpecR, ones(3,3));   
                    WormMed = medfilt2(WormErode);
                    WormDilate = imdilate(WormMed, ones(5, 5));
                    WormErode2 = imerode(WormDilate, ones(3, 3));
                    WormSpecR = bwareaopen(WormErode2, 300);
                    WormPad = zeros(imSize, imSize);
                    WormPad(x1: x2, y1:y2) = WormSpecR(:, :);  
                    [wormLabel, num] = bwlabel(WormPad);
                    if num > 1;
                        for n = 1:num;
                            object = find(wormLabel == n);
                            objectSize = length(object);
                            if objectSize > wormSize + cst;
                                wormLabel(object) = 0;
                            elseif objectSize < wormSize - cst;
                                wormLabel(object) = 0;
                            else 
                                wormLabel(object) = 1;
                            end
                        end

                        [wormLabel2, num2] = bwlabel(wormLabel);
                        if num2 > 1;
                            imshow(wormLabel2);
                            caxis auto
                            disp('Please click on the worm.');
                            [X, Y] = ginput(1);
                            X = uint16(X);
                            Y = uint16(Y);
                            value = wormLabel2(Y, X);
                            wormIndex = wormLabel2 == value;
                            wormLabel2(wormIndex) = 1;
                            wormLabel2(~wormIndex) = 0; 
                        end 
                        wormLabel = wormLabel2;

                        WB = 1 - wormLabel;
                    else
                        WB = 1 - WormPad;
                    end
                    check = find(WB == 0);
                    sizeWB = length(check);
                end
            end
            BW1 = 1 - WB;
            if omegaCount == 0;
                BW2 = imfill(BW1, 'holes');
                boundWorm = regionprops(BW2, 'BoundingBox');
                WB = 1 - BW2;
            else
                for j = 1:omegaCount;
                    if i >= omegaTurnStart(j) && i <= omegaTurnEnd(j);
                        boundWorm = regionprops(BW1, 'BoundingBox');
                        WB = 1 - BW1;
                    else
                        BW2 = imfill(BW1, 'holes');
                        boundWorm = regionprops(BW2, 'BoundingBox');
                        WB = 1 - BW2;
                    end
                end
            end
            x1 = uint16(boundWorm.BoundingBox(2)) - box;
            x2 = uint16(boundWorm.BoundingBox(2)+ boundWorm.BoundingBox(4)) + box;
            y1 = uint16(boundWorm.BoundingBox(1)) - box;
            y2 = uint16(boundWorm.BoundingBox(1)+ boundWorm.BoundingBox(3)) + box;    
            wormSize = sizeWB;
            clear sizeWB
            clear check
            imwrite(WB, strcat(num2str(i), '.tif'));
        end  
        
        for i = laserOn:laserOff;
            fileName = fullfile(PathName, MyDirInfo(i).name);
            raw = imread(fileName);
            frameD = raw - darkStill;
            rawCut = reshape(frameD(x1: x2, y1: y2), (x2-x1)+1, (y2-y1)+1); 
            BW = im2bw(rawCut, 2/255);
            SpecR = bwareaopen(BW, 300);
            %WormFill = imfill(SpecR, 'holes');
            WormErode = imerode(SpecR, ones(3,3));   
            WormMed = medfilt2(WormErode);
            WormDilate = imdilate(WormMed, ones(5, 5));
            WormErode2 = imerode(WormDilate, ones(3, 3));
            WormSpecR = bwareaopen(WormErode2, 300);
            WormPad = zeros(imSize, imSize);
            WormPad(x1: x2, y1:y2) = WormSpecR(:, :);  
            [wormLabel, num] = bwlabel(WormPad);
            if num > 1;
                for n = 1:num;
                    object = find(wormLabel == n);
                    objectSize = length(object);
                    if objectSize < wormSize - cst;
                        wormLabel(object) = 0;
                    else 
                        wormLabel(object) = 1;
                    end
                end
                WB = 1 - wormLabel;
            else
                WB = 1 - WormPad;
            end
            check = find(WB == 0);
            sizeWB = length(check);
            if sizeWB > wormSize;
                ii = 1;
                while sizeWB > wormSize;
                    ii = ii+1;
                    jj = ii*10;
                    darkName = fullfile(darkPath, darkInfo(jj).name);
                    darkLaser = imread(darkName);
                    frameD = raw - darkLaser;
                    rawCut = reshape(frameD(x1: x2, y1: y2), (x2-x1)+1, (y2-y1)+1);
                    BW = im2bw(rawCut, 2/255);
                    SpecR = bwareaopen(BW, 300);
                    %WormFill = imfill(SpecR, 'holes');
                    WormErode = imerode(SpecR, ones(3,3));   
                    WormMed = medfilt2(WormErode);
                    WormDilate = imdilate(WormMed, ones(5, 5));
                    WormErode2 = imerode(WormDilate, ones(3, 3));
                    WormSpecR = bwareaopen(WormErode2, 300);
                    WormPad = zeros(imSize, imSize);
                    WormPad(x1: x2, y1:y2) = WormSpecR(:, :);  
                    [wormLabel, num] = bwlabel(WormPad);
                    if num > 1;
                        for n = 1:num;
                            object = find(wormLabel == n);
                            objectSize = length(object);
                            if objectSize < wormSize - cst;
                                wormLabel(object) = 0;
                            else 
                                wormLabel(object) = 1;
                            end
                        end

                        [wormLabel2, num2] = bwlabel(wormLabel);
                        if num2 > 1;
                            imshow(wormLabel2);
                            caxis auto
                            disp('Please click on the worm.');
                            [X, Y] = ginput(1);
                            X = uint16(X);
                            Y = uint16(Y);
                            value = wormLabel2(Y, X);
                            wormIndex = wormLabel2 == value;
                            wormLabel2(wormIndex) = 1;
                            wormLabel2(~wormIndex) = 0; 
                        end 
                        wormLabel = wormLabel2;

                        WB = 1 - wormLabel;
                    else
                        WB = 1 - WormPad;
                    end
                    check = find(WB == 0);
                    sizeWB = length(check);
                end
            end   
            BW1 = 1 - WB;
            if omegaCount == 0;
                BW2 = imfill(BW1, 'holes');
                boundWorm = regionprops(BW2, 'BoundingBox');
                WB = 1 - BW2;
            else
                for j = 1:omegaCount;
                    if i >= omegaTurnStart(j) && i <= omegaTurnEnd(j);
                        boundWorm = regionprops(BW1, 'BoundingBox');
                        WB = 1 - BW1;
                    else
                        BW2 = imfill(BW1, 'holes');
                        boundWorm = regionprops(BW2, 'BoundingBox');
                        WB = 1 - BW2;
                    end
                end
            end
            x1 = uint16(boundWorm.BoundingBox(2)) - box;
            x2 = uint16(boundWorm.BoundingBox(2)+ boundWorm.BoundingBox(4)) + box;
            y1 = uint16(boundWorm.BoundingBox(1)) - box;
            y2 = uint16(boundWorm.BoundingBox(1)+ boundWorm.BoundingBox(3)) + box;    
            wormSize = sizeWB;
            clear sizeWB
            clear check
            imwrite(WB, strcat(num2str(i), '.tif'));
        end   
        
        for i = laserOff+1:dirSize;
            fileName = fullfile(PathName, MyDirInfo(i).name);
            raw = imread(fileName);
            frameD = raw - darkStill;
            rawCut = reshape(frameD(x1: x2, y1: y2), (x2-x1)+1, (y2-y1)+1); 
            BW = im2bw(rawCut, newThresh);
            SpecR = bwareaopen(BW, 300);
            %WormFill = imfill(SpecR, 'holes');
            WormErode = imerode(SpecR, ones(3,3));   
            WormMed = medfilt2(WormErode);
            WormDilate = imdilate(WormMed, ones(5, 5));
            WormErode2 = imerode(WormDilate, ones(3, 3));
            WormSpecR = bwareaopen(WormErode2, 300);
            WormPad = zeros(imSize, imSize);
            WormPad(x1: x2, y1:y2) = WormSpecR(:, :);  
            [wormLabel, num] = bwlabel(WormPad);
            if num > 1;
                for n = 1:num;
                    object = find(wormLabel == n);
                    objectSize = length(object);
                    if objectSize > wormSize + cst;
                        wormLabel(object) = 0;
                    elseif objectSize < wormSize - cst;
                        wormLabel(object) = 0;
                    else 
                        wormLabel(object) = 1;
                    end
                end

                [wormLabel2, num2] = bwlabel(wormLabel);
                if num2 > 1;
                    imshow(wormLabel2);
                    caxis auto
                    disp('Please click on the worm.');
                    [X, Y] = ginput(1);
                    X = uint16(X);
                    Y = uint16(Y);
                    value = wormLabel2(Y, X);
                    wormIndex = wormLabel2 == value;
                    wormLabel2(wormIndex) = 1;
                    wormLabel2(~wormIndex) = 0; 
                end 
                wormLabel = wormLabel2;

                WB = 1 - wormLabel;
            else
                WB = 1 - WormPad;
            end
            check = find(WB == 0);
            sizeWB = length(check);
            altThresh = best;
            if sizeWB > wormSize + cst;
                while sizeWB > wormSize + cst;
                    altThresh = altThresh + 1;
                    BW = im2bw(rawCut, threshRange(altThresh)/255);
                    SpecR = bwareaopen(BW, 300);
                    %WormFill = imfill(SpecR, 'holes');
                    WormErode = imerode(SpecR, ones(3,3));   
                    WormMed = medfilt2(WormErode);
                    WormDilate = imdilate(WormMed, ones(5, 5));
                    WormErode2 = imerode(WormDilate, ones(3, 3));
                    WormSpecR = bwareaopen(WormErode2, 300);
                    WormPad = zeros(imSize, imSize);
                    WormPad(x1: x2, y1:y2) = WormSpecR(:, :);  
                    [wormLabel, num] = bwlabel(WormPad);
                    if num > 1;
                        for n = 1:num;
                            object = find(wormLabel == n);
                            objectSize = length(object);
                            if objectSize > wormSize + cst;
                                wormLabel(object) = 0;
                            elseif objectSize < wormSize - cst;
                                wormLabel(object) = 0;
                            else 
                                wormLabel(object) = 1;
                            end
                        end

                        [wormLabel2, num2] = bwlabel(wormLabel);
                        if num2 > 1;
                            imshow(wormLabel2);
                            caxis auto
                            disp('Please click on the worm.');
                            [X, Y] = ginput(1);
                            X = uint16(X);
                            Y = uint16(Y);
                            value = wormLabel2(Y, X);
                            wormIndex = wormLabel2 == value;
                            wormLabel2(wormIndex) = 1;
                            wormLabel2(~wormIndex) = 0; 
                        end 
                        wormLabel = wormLabel2;

                        WB = 1 - wormLabel;
                    else
                        WB = 1 - WormPad;
                    end
                    check = find(WB == 0);
                    sizeWB = length(check);
                end
            elseif sizeWB < wormSize - cst;
                while sizeWB < wormSize - cst;
                    altThresh = altThresh - 1;
                    BW = im2bw(rawCut, threshRange(altThresh)/255);
                    SpecR = bwareaopen(BW, 300);
                    %WormFill = imfill(SpecR, 'holes');
                    WormErode = imerode(SpecR, ones(3,3));   
                    WormMed = medfilt2(WormErode);
                    WormDilate = imdilate(WormMed, ones(5, 5));
                    WormErode2 = imerode(WormDilate, ones(3, 3));
                    WormSpecR = bwareaopen(WormErode2, 300);
                    WormPad = zeros(imSize, imSize);
                    WormPad(x1: x2, y1:y2) = WormSpecR(:, :);  
                    [wormLabel, num] = bwlabel(WormPad);
                    if num > 1;
                        for n = 1:num;
                            object = find(wormLabel == n);
                            objectSize = length(object);
                            if objectSize > wormSize + cst;
                                wormLabel(object) = 0;
                            elseif objectSize < wormSize - cst;
                                wormLabel(object) = 0;
                            else 
                                wormLabel(object) = 1;
                            end
                        end

                        [wormLabel2, num2] = bwlabel(wormLabel);
                        if num2 > 1;
                            imshow(wormLabel2);
                            caxis auto
                            disp('Please click on the worm.');
                            [X, Y] = ginput(1);
                            X = uint16(X);
                            Y = uint16(Y);
                            value = wormLabel2(Y, X);
                            wormIndex = wormLabel2 == value;
                            wormLabel2(wormIndex) = 1;
                            wormLabel2(~wormIndex) = 0; 
                        end 
                        wormLabel = wormLabel2;

                        WB = 1 - wormLabel;
                    else
                        WB = 1 - WormPad;
                    end
                    check = find(WB == 0);
                    sizeWB = length(check);
                end 
            end   
            BW1 = 1 - WB;
            if omegaCount == 0;
                BW2 = imfill(BW1, 'holes');
                boundWorm = regionprops(BW2, 'BoundingBox');
                WB = 1 - BW2;
            else
                for j = 1:omegaCount;
                    if i >= omegaTurnStart(j) && i <= omegaTurnEnd(j);
                        boundWorm = regionprops(BW1, 'BoundingBox');
                        WB = 1 - BW1;
                    else
                        BW2 = imfill(BW1, 'holes');
                        boundWorm = regionprops(BW2, 'BoundingBox');
                        WB = 1 - BW2;
                    end
                end
            end
            x1 = uint16(boundWorm.BoundingBox(2)) - box;
            x2 = uint16(boundWorm.BoundingBox(2)+ boundWorm.BoundingBox(4)) + box;
            y1 = uint16(boundWorm.BoundingBox(1)) - box;
            y2 = uint16(boundWorm.BoundingBox(1)+ boundWorm.BoundingBox(3)) + box;    
            wormSize = sizeWB;
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
        threshRange = linspace(thresh-2, thresh+2, 10);
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
    imSize = length(image);
    caxis auto
    thresh = input('What is that threshold value? ');
    Range = linspace(0, 255, 256);
    
    if thresh < 3;
        threshRange = Range(0:9);
    elseif thresh > 250;
        threshRange = Range(247:256);
    else
        threshRange = Range(thresh-3: thresh+6);
    end
    
    close all
    
    figure;
    subplot(2, 5, 10);
    
    startStack = zeros(imSize, imSize, 10);
    
    for r = 1:10;   
        fileName = fullfile(PathName, MyDirInfo(1).name);
        raw = imread(fileName);
        BW = im2bw(raw, threshRange(r)/255);
        SpecR = bwareaopen(BW, 300);
        WormErode = imerode(SpecR, ones(3,3));   
        WormMed = medfilt2(WormErode);
        WormDilate = imdilate(WormMed, ones(4, 4));
        WormErode2 = imerode(WormDilate, ones(3, 3));
        WormSpecR = bwareaopen(WormErode2, 300);
        WB = 1 - WormSpecR;
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
    
    fileName = fullfile(PathName, MyDirInfo(1).name);
    raw = imread(fileName);
    BW = im2bw(raw, newThresh);
    SpecR = bwareaopen(BW, 300);
    WormErode = imerode(SpecR, ones(3,3));   
    WormMed = medfilt2(WormErode);
    WormDilate = imdilate(WormMed, ones(4, 4));
    WormErode2 = imerode(WormDilate, ones(3, 3));
    WormSpecR = bwareaopen(WormErode2, 300);
    
    [wormLabel, num] = bwlabel(WormSpecR);
    if num > 1;
        imshow(wormLabel);
        caxis auto
        disp('Please click on the worm.');
        [X, Y] = ginput(1);
        X = uint16(X);
        Y = uint16(Y);
        value = wormLabel(Y, X);
        wormIndex = wormLabel == value;
        wormLabel(wormIndex) = 1;
        wormLabel(~wormIndex) = 0; 
    end
    
    box = 150;
    
        boundWorm = regionprops(wormLabel, 'BoundingBox');
        x1 = uint16(boundWorm.BoundingBox(2)) - box;
        x2 = uint16(boundWorm.BoundingBox(2)+ boundWorm.BoundingBox(4)) + box;
        y1 = uint16(boundWorm.BoundingBox(1)) - box;
        y2 = uint16(boundWorm.BoundingBox(1)+ boundWorm.BoundingBox(3)) + box;   
    
    worm = find(wormLabel == 1);
    wormSize = length(worm);
    cst = 500;
    
    for i = 1:dirSize;
        fileName = fullfile(PathName, MyDirInfo(i).name);
        raw = imread(fileName);
        rawCut = reshape(raw(x1: x2, y1: y2), (x2-x1)+1, (y2-y1)+1); 
        BW = im2bw(rawCut, newThresh);
        SpecR = bwareaopen(BW, 300);
        %WormFill = imfill(SpecR, 'holes');
        WormErode = imerode(SpecR, ones(3,3));   
        WormMed = medfilt2(WormErode);
        WormDilate = imdilate(WormMed, ones(5, 5));
        WormErode2 = imerode(WormDilate, ones(3, 3));
        WormSpecR = bwareaopen(WormErode2, 300);
        WormPad = zeros(imSize, imSize);
        WormPad(x1: x2, y1:y2) = WormSpecR(:, :);  
        [wormLabel, num] = bwlabel(WormPad);
        if num > 1;
            for n = 1:num;
                object = find(wormLabel == n);
                objectSize = length(object);
                if objectSize > wormSize + cst;
                    wormLabel(object) = 0;
                elseif objectSize < wormSize - cst;
                    wormLabel(object) = 0;
                else 
                    wormLabel(object) = 1;
                end
            end

            [wormLabel2, num2] = bwlabel(wormLabel);
            if num2 > 1;
                imshow(wormLabel2);
                caxis auto
                disp('Please click on the worm.');
                [X, Y] = ginput(1);
                X = uint16(X);
                Y = uint16(Y);
                value = wormLabel2(Y, X);
                wormIndex = wormLabel2 == value;
                wormLabel2(wormIndex) = 1;
                wormLabel2(~wormIndex) = 0; 
            end 
            wormLabel = wormLabel2;

            WB = 1 - wormLabel;
        else
            WB = 1 - WormPad;
        end
        check = find(WB == 0);
        sizeWB = length(check);
        altThresh = best;
        if sizeWB > wormSize + cst;
            while sizeWB > wormSize + cst;
                altThresh = altThresh + 1;
                BW = im2bw(rawCut, Range(altThresh)/255);
                SpecR = bwareaopen(BW, 300);
                %WormFill = imfill(SpecR, 'holes');
                WormErode = imerode(SpecR, ones(3,3));   
                WormMed = medfilt2(WormErode);
                WormDilate = imdilate(WormMed, ones(5, 5));
                WormErode2 = imerode(WormDilate, ones(3, 3));
                WormSpecR = bwareaopen(WormErode2, 300);
                WormPad = zeros(imSize, imSize);
                WormPad(x1: x2, y1:y2) = WormSpecR(:, :);  
                [wormLabel, num] = bwlabel(WormPad);
                if num > 1;
                    for n = 1:num;
                        object = find(wormLabel == n);
                        objectSize = length(object);
                        if objectSize > wormSize + cst;
                            wormLabel(object) = 0;
                        elseif objectSize < wormSize - cst;
                            wormLabel(object) = 0;
                        else 
                            wormLabel(object) = 1;
                        end
                    end
                    
                    [wormLabel2, num2] = bwlabel(wormLabel);
                    if num2 > 1;
                        imshow(wormLabel2);
                        caxis auto
                        disp('Please click on the worm.');
                        [X, Y] = ginput(1);
                        X = uint16(X);
                        Y = uint16(Y);
                        value = wormLabel2(Y, X);
                        wormIndex = wormLabel2 == value;
                        wormLabel2(wormIndex) = 1;
                        wormLabel2(~wormIndex) = 0; 
                    end 
                    wormLabel = wormLabel2;
                    
                    WB = 1 - wormLabel;
                else
                    WB = 1 - WormPad;
                end
                check = find(WB == 0);
                sizeWB = length(check);
            end
        elseif sizeWB < wormSize - cst;
            while sizeWB < wormSize - cst;
                altThresh = altThresh - 1;
                BW = im2bw(rawCut, threshRange(altThresh)/255);
                SpecR = bwareaopen(BW, 300);
                %WormFill = imfill(SpecR, 'holes');
                WormErode = imerode(SpecR, ones(3,3));   
                WormMed = medfilt2(WormErode);
                WormDilate = imdilate(WormMed, ones(5, 5));
                WormErode2 = imerode(WormDilate, ones(3, 3));
                WormSpecR = bwareaopen(WormErode2, 300);
                WormPad = zeros(imSize, imSize);
                WormPad(x1: x2, y1:y2) = WormSpecR(:, :);  
                [wormLabel, num] = bwlabel(WormPad);
                if num > 1;
                    for n = 1:num;
                        object = find(wormLabel == n);
                        objectSize = length(object);
                        if objectSize > wormSize + cst;
                            wormLabel(object) = 0;
                        elseif objectSize < wormSize - cst;
                            wormLabel(object) = 0;
                        else 
                            wormLabel(object) = 1;
                        end
                    end
                    
                    [wormLabel2, num2] = bwlabel(wormLabel);
                    if num2 > 1;
                        imshow(wormLabel2);
                        caxis auto
                        disp('Please click on the worm.');
                        [X, Y] = ginput(1);
                        X = uint16(X);
                        Y = uint16(Y);
                        value = wormLabel2(Y, X);
                        wormIndex = wormLabel2 == value;
                        wormLabel2(wormIndex) = 1;
                        wormLabel2(~wormIndex) = 0; 
                    end 
                    wormLabel = wormLabel2;
                    
                    WB = 1 - wormLabel;
                else
                    WB = 1 - WormPad;
                end
                check = find(WB == 0);
                sizeWB = length(check);
            end
            boundWorm = regionprops(WormPad, 'BoundingBox');
            x1 = uint16(boundWorm.BoundingBox(2)) - box;
            x2 = uint16(boundWorm.BoundingBox(2)+ boundWorm.BoundingBox(4)) + box;
            y1 = uint16(boundWorm.BoundingBox(1)) - box;
            y2 = uint16(boundWorm.BoundingBox(1)+ boundWorm.BoundingBox(3)) + box;     
        end   
        wormSize = sizeWB;
        clear sizeWB
        clear check
        imwrite(WB, strcat(num2str(i), '.tif'));
    end      
end


