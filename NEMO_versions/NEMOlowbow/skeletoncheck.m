function skeletoncheck(start,finish)


premo;
cd(oldfolder)
mkdir('EXHIBIT')

for i=start:finish
    
    cd(oldfolder)
    cd('DATA_SAVED')
    
    X=load(['mask_' int2str(i)]);
    X=bwperim(X);
    
    Y=load(['skeleton_' int2str(i)]);
    
    rgbImage=cat(3,X,Y,zeros(size(X)));
    
    cd(oldfolder)
    cd('EXHIBIT')
    
    imwrite(rgbImage,['perimskel_' int2str(i) '.tif'])
end

cd(oldfolder)