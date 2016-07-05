% script that deletes all created files by program

global mainOutFolder

if exist(mainOutFolder,'dir')
    rmdir(mainOutFolder,'s')
end