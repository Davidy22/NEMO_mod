function [avgPostSpeed] = speedPostOmega(ONframe,timeIn, speedIn, colorIn)
%TIMEPOSTOMEGA Summary of this function goes here
%   Detailed explanation goes here
co = colorIn;
speed = speedIn;

co1 = co(:,1);
co3 = co(:,3);

reds = find(co1==1);
blues = find(co3==1);
TF = isempty(reds);
TF2 = isempty(blues);

if (TF == 0 || TF2 ==0 )

[actualTime1, lastBlue] = timeOmega(ONframe,timeIn, colorIn);


lastFrame = length(co);

postSpeed = speed(lastBlue+1:lastFrame);
avgPostS = mean(postSpeed);

avgPostSpeed = round(avgPostS,2,'significant');

else
    
avgPostSpeed = 0;

end

end

