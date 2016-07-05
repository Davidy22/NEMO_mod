function centerofmass(s,calibration,poffset)

global vidWidth
global vidHeight
global CoM


premo;

    
    fieldname=['frame' int2str(s)];
   
    cd(oldfolder)
    cd('DATA_SAVED')
    msk=load(['mask_' int2str(s)]);

    [ycm,xcm]=find(msk==1);
    CoM.(fieldname)=[mean(xcm), mean(ycm)];
    CoM.(fieldname)(1)=1/calibration*((CoM.(fieldname)(1)-calibration)+poffset(2));
    CoM.(fieldname)(2)=1/calibration*((calibration-CoM.(fieldname)(2))+(vidHeight-poffset(1)));
    
