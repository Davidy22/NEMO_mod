function [OmegaTurnAngle] = OmegaAngle(ONframe,colorIn,fileName)

co = colorIn;
%  pointsFile = xlsread('2DPT_T1_W1.xlsx');
% pointsFile = xlsread('PT_T15_11.xlsx');



pointsFile = xlsread(fileName);



co3 = co(:,3);

co1 = co(:,1);

reds = find(co1==1);
blues = find(co3==1);
TF = isempty(reds);
TF2 = isempty(blues);

if (TF == 0 || TF2 ==0 )

   
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

firstRed = a(end);    

range = find(co3==1);

rangeAfterOmega = range(end);
 
cmBeforeOmegaX = pointsFile((firstRed-100):(firstRed-50),4);
cmBeforeOmegaY = pointsFile((firstRed-100):(firstRed-50),5);

% cmBeforeOmegaXPower = power(cmBeforeOmegaX,2);
% cmBeforeOmegaYPower = power(cmBeforeOmegaY,2);
% 
% cmBefore = cmBeforeOmegaXPower + cmBeforeOmegaYPower;
% cmBeforeFinal = sqrt(cmBefore);
% 
% cmB1 = cmBeforeFinal(1);
% cmB2 = cmBeforeFinal(5);
%   
%  vBefore = cmB2 - cmB1;
 
 VBefore=[cmBeforeOmegaX(end) cmBeforeOmegaY(end)]-[cmBeforeOmegaX(1) cmBeforeOmegaY(1)];
 
 
cmAfterOmegaX = pointsFile((rangeAfterOmega+50):(rangeAfterOmega+100),4) ; 
cmAfterOmegaY = pointsFile((rangeAfterOmega+50):(rangeAfterOmega+100),5) ;

% cmAfterOmegaXPower = power(cmAfterOmegaX,2);
% cmAfterOmegaYPower = power(cmAfterOmegaY,2);
% 
% cmAfter = cmAfterOmegaXPower + cmAfterOmegaYPower;
% cmAfterFinal = sqrt(cmAfter);
% 
% cmA1 = cmAfterFinal(1);
% cmA2 = cmAfterFinal(5);
% 
% vAfter = cmA2 - cmA1;

 VAfter=[cmAfterOmegaX(1) cmAfterOmegaY(1)]-[cmAfterOmegaX(end) cmAfterOmegaY(end)];

 dotP = dot(VBefore,VAfter);
 
 magB = norm(VBefore);
 magA = norm (VAfter);
 
 teta = acos(dotP/(magB*magA));
 
 OmegaTurnA = rad2deg(teta);
 
 OmegaTurnAngle = round(OmegaTurnA,2,'significant');
 
else 
    
    OmegaTurnAngle = 0;

end