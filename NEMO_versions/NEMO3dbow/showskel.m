function showskel(s)

%Displays skeleton after NEMOstep 3 is completed.
%
%INPUTS:
%   S: frame of skeleton to be displayed


global NEMOstep
global PERXY
global CoM

oldfolder=pwd;

if isempty(NEMOstep)==1
    disp('ERROR: NEMOstep is unassigned.')
end

if NEMOstep>3
    
    fieldname=['frame' int2str(s)];
    
    if ishandle(200000+s)
        close(200000+s)
    end
    figure(200000+s)
    
    plot3(PERXY.(fieldname)(:,1),PERXY.(fieldname)(:,2),PERXY.(fieldname)(:,3))
    hold on
    plot3(CoM.(fieldname)(:,1),CoM.(fieldname)(:,2),CoM.(fieldname)(:,3),'*b')
    xlabel('x')
    ylabel('y')
    zlabel('z')
    axis equal
else
    disp('ERROR: Have yet to extract skeleton. Please run NEMOanalysis further before attempting to display skeleton.')

    disp(['NEMOstep=' int2str(NEMOstep)])
end

cd(oldfolder)