function [totalTime] = timeAvoidance(ONframe,timeIn, colorIn)
[actualTime1] = timeOmega(ONframe,timeIn, colorIn);
[actualTime2] = timeReversal(ONframe,timeIn, colorIn);


totalT = actualTime1+actualTime2;

totalTime = round(totalT,2,'significant');

end

