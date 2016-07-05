function showskel(s)

%Displays skeleton after NEMOstep 2 is completed.
%
%INPUTS:
%   S: frame of skeleton to be displayed


global NEMOstep
global PERXY
global CoM
global vidHeight

oldfolder=pwd;

if isempty(NEMOstep)==1
    disp('ERROR: NEMOstep is unassigned.')
end

if NEMOstep>2
    
    strFrame=['frame' int2str(framenum)];
    
    if ishandle(200000+s)
        close(200000+s)
    end
    figure(200000+s)
    
    plot(PERXY.(strFrame)(:,1),PERXY.(strFrame)(:,2))
    hold on
    plot(CoM.(strFrame)(:,1),vidHeight-CoM.(strFrame)(:,2),'*b')
    xlabel('x')
    ylabel('y')
    axis equal
else
    disp('ERROR: Have yet to extract skeleton. Please run NEMOanalysis further before attempting to display skeleton.')
    disp(['NEMOstep=' int2str(NEMOstep)])
end

