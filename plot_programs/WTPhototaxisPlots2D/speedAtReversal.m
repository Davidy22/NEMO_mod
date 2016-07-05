function [maxSpeed] = speedAtReversal(ONframe, speedIn, colorIn)
SVC = speedIn;
co = colorIn;
co1=co(:,1);


reds = find(co1==1);
TF = isempty(reds);

if (TF == 0)

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

rangeOfReversal = find(co1==1);

%here we want to get the real end of reversal, not the index of the last
%red bar in the graphic
k = find(rangeOfReversal==firstRealRed,1);
l = length(rangeOfReversal);
while ((rangeOfReversal(k)+5) > rangeOfReversal(k+1) && k+1 < l)
    
   k = k + 1; 
end

%%%%%

lastRed = rangeOfReversal(k);

A = SVC(firstRealRed:lastRed);
maxS = max(A);

maxSpeed = round(maxS,2,'significant');

else 
    
maxSpeed = 0;

end

end


