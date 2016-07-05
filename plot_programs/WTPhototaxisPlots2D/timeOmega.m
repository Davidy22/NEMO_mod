function [actualTime,lastBlue] = timeOmega(ONframe, timeIn, colorIn)
totalTime = timeIn;
co = colorIn;

co1 = co(:,1);
co3 = co(:,3);

reds = find(co1==1);
blues = find(co3==1);
TF = isempty(reds);
TF2 = isempty(blues);

if (TF == 0 || TF2 ==0 )


rangeOfReversal = find(co1==1);

%this part of code is to get the real start of reversal, and avoid getting
%a random lonely red before it 

OisFalse = 0;
i = 0;

while (OisFalse == 0)
i = i + 1;    
a = find(co1==1,i);
a2 = find(co1==1,i+1);

if (a(end) + 5 > a2(end) && a(end)>ONframe )
    OisFalse = 1;
end
end
%%%%%%%%

firstRealRed = a(end);

%here we want to get the real end of reversal, not the index of the last
%red bar in the graphic
i = find(rangeOfReversal==firstRealRed,1);
l = length(rangeOfReversal);
while ((rangeOfReversal(i)+6) > rangeOfReversal(i+1) && i+1 < l )
    
   i = i + 1; 
end

%%%%%

lastRed = rangeOfReversal(i);

colorsAfterReversal = co((lastRed+1):end,:);

co3AfterReversal = colorsAfterReversal(:,3);

rangeBlues = find(co3AfterReversal==1);

k = 1;
l2 = length(rangeBlues);

%here we get the reange of the blue ritgh after  the reversal, ignoring the
% random lonely green and red bar that appear
while ((rangeBlues(k)+6)> rangeBlues(k+1) && k+1 < l2)
   k = k+1;
end
%%%%

omegaTime1 = totalTime(lastRed + rangeBlues(1));
omegaTime2 = totalTime(lastRed + rangeBlues(end));

lastBlue = lastRed + rangeBlues(end);

actualT = omegaTime2-omegaTime1;


actualTime = round(actualT,2,'significant');

else 
    
actualTime = 0;

end

end

