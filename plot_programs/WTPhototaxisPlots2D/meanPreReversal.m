function [speedPreRev] = meanPreReversal(ONframe, speedIn, colorIn)
%avg speed before reversal
SVC = speedIn;
co = colorIn;

co1 = co(:,1);

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

A = SVC(1:a(end));
spr = mean(A);

speedPreRev = round(spr,2,'significant');


else
    
    speedPreRev = 0;
    
end

end


