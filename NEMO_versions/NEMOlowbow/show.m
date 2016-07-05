function show=show(image)

premo;
cd('DATA_SAVED');

A=load(['skeleton_' int2str(image)]);
fig1=figure('units','normalized','outerposition',[1 -3 1 1]);imshow(A,'border','tight');
%set(fig1,'menubar','none');
fig1;

B=load(['mask_' int2str(image)]);
fig2=figure('units','normalized','outerposition',[-3 3 1 1]);imshow(B,'border','tight');
%set(fig2,'menubar','none');
fig2;

cd(oldfolder)
