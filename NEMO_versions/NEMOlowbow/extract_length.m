function extract_length(start,finish)
%EXTRACT_LENGTH Summary of this function goes here
%   Detailed explanation goes here

premo;

cd(oldfolder)
phase=load('phase.csv');

for s=start:finish
    
    if phase(s-start+1)~=111
    
        finallength(s)
    end

end

