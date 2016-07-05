function showvoxel(s)

%Displays voxel image after NEMOstep 2 is completed.
%
%INPUTS:
%   S: frame of voxel to be displayed


global NEMOstep

oldfolder=pwd;

if isempty(NEMOstep)==1
    disp('ERROR: NEMOstep is unassigned.')
end

if NEMOstep>2
    
    imxy = imread(['DATA/top/3_' int2str(s) '.png']);
    imxz = imread(['DATA/side1/1_' int2str(s) '.png']);
    imyz = imread(['DATA/side2/2_' int2str(s) '.png']);
    imxy = flipud(imxy);
    imxz = flipud(imxz);
    imyz = flipud(imyz);
    imxy = 1 - im2bw(imxy,graythresh(imxy));
    imxz = 1 - im2bw(imxz,graythresh(imxz));
    imyz = 1 - im2bw(imyz,graythresh(imyz));
    imxy3dproj = repmat(imxy,1,1,length(imxz(:,1)));
    imxz3dproj = repmat(imxz,1,1,length(imyz(1,:)));
    imxz3dproj = permute(imxz3dproj,[3,2,1]);
    imyz3dproj = repmat(imyz,1,1,length(imxz(1,:)));
    imyz3dproj = permute(imyz3dproj,[2,3,1]);
    im3dxyz = imxy3dproj & imxz3dproj & imyz3dproj;

    if ishandle(100000+s)
        close(100000+s)
    end
    figure(100000+s)
    
    col=[1 .7 .4];
    hiso = patch(isosurface(im3dxyz,0),'FaceColor',col,'EdgeColor','none');
    xlabel('x')
    ylabel('y')
    zlabel('z')
    axis equal
    lighting phong
    isonormals(im3dxyz,hiso);
    alpha(0.5);
    camlight
    view(140,80)
else
    disp('ERROR: Have yet to extract voxels. Please run NEMOanalysis further before attempting to display voxels.')
    disp(['NEMOstep=' int2str(NEMOstep)])
end    

cd(oldfolder)