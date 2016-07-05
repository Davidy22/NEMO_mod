%Save all relevant variables in .mat file in case you need to close MATLAB.


global NEMOstep
global PERXY
global vidWidth
global vidHeight
global folderName
global baseFileName
global CoM
global pointvalue

clc

if isempty(NEMOstep)||isempty(PERXY)||isempty(vidWidth)||isempty(vidHeight)...
        ||isempty(folderName)||isempty(baseFileName)||isempty(CoM)||isempty(pointvalue)
    
    fprintf('The following variables are empty:\n  ')
    
    displaystr=[];
    if isempty(NEMOstep)
        displaystr=[displaystr,'NEMOstep,'];
    end
    if isempty(folderName)
        displaystr=[displaystr,'folderName, '];
    end
    if isempty(baseFileName)
        displaystr=[displaystr,'baseFileName, '];
    end
    if isempty(vidWidth)
        displaystr=[displaystr,'vidWidth, '];
    end
    if isempty(vidHeight)
        displaystr=[displaystr,'vidHeight, '];
    end
    if isempty(CoM)
        displaystr=[displaystr,'CoM, '];
    end
    if isempty(PERXY)
        displaystr=[displaystr,'PERXY, '];
    end
    if isempty(pointvalue)
        displaystr=[displaystr,'pointvalue, '];
    end
    
    fprintf([char(displaystr) '\b\b\n\n'])
    clear displaystr
    
    displaystr=[];
    if isempty(NEMOstep)
        disp('NEMOstep should not be empty.')
        
    else
        fprintf('The following variables should not be empty:\n  ')
        
        if NEMOstep>1 && (isempty(folderName)||isempty(baseFileName)...
                ||isempty(vidWidth)||isempty(vidHeight))
            if isempty(folderName)
                displaystr=[displaystr,'folderName, '];
            end
            if isempty(baseFileName)
                displaystr=[displaystr,'baseFileName, '];
            end
            if isempty(vidWidth)
                displaystr=[displaystr,'vidWidth, '];
            end
            if isempty(vidHeight)
                displaystr=[displaystr,'vidHeight, '];
            end
        end
        
        if NEMOstep>2 && (isempty(PERXY)||isempty(CoM))
            if isempty(CoM)
                displaystr=[displaystr,'CoM, '];
            end
            if isempty(PERXY)
                displaystr=[displaystr,'PERXY, '];
            end
        end
        
        if NEMOstep>4 && (isempty(pointvalue))
            displaystr=[displaystr,'pointvalue, '];
        end
        
        fprintf([char(displaystr) '\b\b\n\n'])
        clear displaystr
    end
else
    fprintf('No empty variables. Good work, bratan.\n\n')
end

choice=questdlg({'You want to triple-check:';'Are empty variables supposed to be empty?'},...
        'Overwrite save?',...
        'Yes','No','No');
    
switch choice
    case 'Yes'
        save variables.mat NEMOstep PERXY vidWidth vidHeight folderName baseFileName CoM pointvalue
        fprintf('Saved in variables.mat.\n\n')

    case 'No'
        fprintf('Variables not saved.\n\n') 
end
clear choice
