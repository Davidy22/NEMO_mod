% Finds data on when laser was turned on during experiment.
% laserStart and laserStop mark boundaries of the first occurence of the
% laser turning on and off. intensity is the intensity of the laser.

function [onFrame, offFrame, current] = laserOnOff( txtPath )
    f = fopen(txtPath);
    data = textscan(f, '%d %d %s %f %f');
    data = [cell2mat(data(1,1)) cell2mat(data(1,2))];
    [height, ~] = size(data);
    onFrame = 0;
    
    for i = 1:height
        if onFrame == 0
            if data(i,1) == 0
                continue
            else
                onFrame = data(i,2);
                current = data(i,1);
            end
        else
            if data(i,1) == 0
                offFrame = data(i-1,2);
                return
            end
        end
    end
end
