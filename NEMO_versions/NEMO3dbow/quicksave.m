%Save all relevant variables in .mat file in case you need to close MATLAB.


global NEMOstep
global PERXY
global vidsz
global folderName
global univFileName
global CoM
global COMlistxy
global COMlistyz
global COMlistxz

clc

if isempty(NEMOstep)||isempty(PERXY)||isempty(vidsz)||isempty(folderName)...
        ||isempty(univFileName)||isempty(CoM)||isempty(COMlistxy)...
        ||isempty(COMlistyz)||isempty(COMlistxz)
    
    fprintf('The following variables are empty:\n  ')
    
    displaystr=[];
    if isempty(NEMOstep)
        displaystr=[displaystr,'NEMOstep,'];
    end
    if isempty(folderName)
        displaystr=[displaystr,'folderName, '];
    end
    if isempty(univFileName)
        displaystr=[displaystr,'univFileName, '];
    end
    if isempty(vidsz)
        displaystr=[displaystr,'vidsz, '];
    end
    if isempty(COMlistxy)
        displaystr=[displaystr,'COMlistxy, '];
    end
    if isempty(COMlistyz)
        displaystr=[displaystr,'COMlistyz, '];
    end
    if isempty(COMlistxz)
        displaystr=[displaystr,'COMlistxz, '];
    end
    if isempty(CoM)
        displaystr=[displaystr,'CoM, '];
    end
    if isempty(PERXY)
        displaystr=[displaystr,'PERXY, '];
    end
    
    fprintf([char(displaystr) '\b\b\n\n'])
    clear displaystr
    
    displaystr=[];
    if isempty(NEMOstep)
        disp('NEMOstep should not be empty.')
        
    else
        fprintf('The following variables should not be empty:\n  ')
        
        if NEMOstep>0 && (isempty(folderName)||isempty(univFileName)||isempty(vidsz))
            if isempty(folderName)
                displaystr=[displaystr,'folderName, '];
            end
            if isempty(univFileName)
                displaystr=[displaystr,'univFileName, '];
            end
            if isempty(vidsz)
                displaystr=[displaystr,'vidsz, '];
            end
        end
        
        if NEMOstep>2 && (isempty(COMlistxy)||isempty(COMlistxz)||isempty(COMlistyz))
            if isempty(COMlistxy)
                displaystr=[displaystr,'COMlistxy, '];
            end
            if isempty(COMlistxz)
                displaystr=[displaystr,'COMlistxz, '];
            end
            if isempty(COMlistyz)
                displaystr=[displaystr,'COMlistyz, '];
            end
        end
        
        if NEMOstep>3 && (isempty(PERXY)||isempty(CoM))
            if isempty(CoM)
                displaystr=[displaystr,'CoM, '];
            end
            if isempty(PERXY)
                displaystr=[displaystr,'PERXY, '];
            end
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
        save variables.mat NEMOstep PERXY COMlistxy COMlistyz COMlistxz vidsz folderName univFileName CoM
        fprintf('Saved in variables.mat.\n\n')

    case 'No'
        fprintf('Variables not saved.\n\n') 
end
clear choice
