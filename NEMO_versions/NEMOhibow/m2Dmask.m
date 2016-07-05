function [cutmask] = m2Dmask(binarymask,pxpmm,framenum)

%Detects masks with holes as omega-turns, and determines ideal cutting location.
%
%INPUTS:
%   binarymask: binary mask array before omega-turn analysis and cutting
%   pxpmm: pixels per millimeter
%   framenum: frame number
%
%OUTPUTS:
%  -cutmask: binary mask array, cut if an omega-turn detected


openedomega = 1-bwmorph(1-binarymask,'open',Inf);
extedgeimage = bwmorph(imfill(openedomega,'holes'),'remove');
intedgeimage = bwmorph(openedomega,'remove') - extedgeimage;
[unused,anyinterior]=find(intedgeimage);

if isempty(anyinterior)
    cutmask=binarymask;
else
    
    strFrame=['frame' int2str(framenum)];
    fprintf(['Cutting omega-turn for ' strFrame '.\n'])
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%interior
    [inrow,incol] = find(intedgeimage);%
    inedgeinturn = zeros(length(inrow),2);%
    inedgeinturn(1,1) = inrow(1);%
    inedgeinturn(1,2) = incol(1);%
    inedgeinturn(2,1) = inrow(2);%
    inedgeinturn(2,2) = incol(2);%
    %%%%%%%%%%%%%%% initialization of interior edge
    
    for n = 2:100000000%%%%%%%%%%%interior
        dist4in = [];
        for i = -1:1
            for j = -1:1%%%%%%%%%%%% search from the neighbour
                if intedgeimage(inedgeinturn(n,1)+i,inedgeinturn(n,2)+j)&&...
                       ~ismember([inedgeinturn(n,1)+i,inedgeinturn(n,2)+j],inedgeinturn,'rows')
                   dist4in = [dist4in;[inedgeinturn(n,1)+i,inedgeinturn(n,2)+j,...
                       norm([inedgeinturn(n,1)+i-inedgeinturn(n-1,1),inedgeinturn(n,2)+j-inedgeinturn(n-1,2)])]]; 
                end
            end
        end
        
        if isempty(dist4in)%end condition
            break
        end
        
        [temp,temppos] = max(dist4in(:,3));%pick the point the farthest from last point
        inedgeinturn(n+1,1) = dist4in(temppos,1);
        inedgeinturn(n+1,2) = dist4in(temppos,2);
    end
    inedgeinturn(all(inedgeinturn==0,2),:)=[];%cut off [0,0] points
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%nbf>indexavailble for inedgeinturn%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    num4aglcal = round(pxpmm/30);%distance of points to the concerned point used to calculate the local angle
    inangle = zeros(length(inedgeinturn),1);
    for n = 1:length(inedgeinturn)
        invector = [0,0];
        
        if n-num4aglcal>0&&n+num4aglcal<=length(inedgeinturn)%both ok
            nbf = n-num4aglcal;%
            naf = n+num4aglcal;%
        elseif n-num4aglcal<=0&&n+num4aglcal<=length(inedgeinturn)%naf ok, nbf too small
            nbf = n-num4aglcal+length(inedgeinturn);%
            naf = n+num4aglcal;%
        elseif n-num4aglcal>0&&n+num4aglcal>length(inedgeinturn)%nbf ok, naf too big
            nbf = n-num4aglcal;%
            naf = n+num4aglcal-length(inedgeinturn);%
        else
            nbf=n-num4aglcal+length(inedgeinturn);
            naf=n+num4aglcal-length(inedgeinturn);
            
        end%%%%%%%%%%%% deal with the boundary
        
        for ii = 1:3%
            for jj = 1:3%
                invector = invector+[ii-2,jj-2]*...%
                    (1-openedomega(inedgeinturn(n,1)-2+ii,inedgeinturn(n,2)-2+jj));%
            end%
        end%%%%%%%%%%%% calculate the vector pointing out of the body
        
        inangle(n) = acos(dot(inedgeinturn(nbf,:)-inedgeinturn(n,:),invector)/norm(inedgeinturn(nbf,:)-inedgeinturn(n,:))...
                /norm(invector))+acos(dot(inedgeinturn(naf,:)-inedgeinturn(n,:),invector)...
                /norm(inedgeinturn(naf,:)-inedgeinturn(n,:))/norm(invector));%interior angle
    end
    [intouchingangle,intouchingnumber] = min(inangle);%regard touching point as the minimum ex-angle point
    
    circspan=num4aglcal;
    if intouchingnumber<circspan+1
        inedgeinturn=circshift(inedgeinturn,circspan+1-intouchingnumber);
        intouchingnumber=circspan+1;
    elseif intouchingnumber>size(inedgeinturn,1)-circspan
        inedgeinturn=circshift(inedgeinturn,(size(inedgeinturn,1)-circspan)-intouchingnumber);
        intouchingnumber=size(inedgeinturn,1)-circspan;
    end
    
    intouching = inedgeinturn(intouchingnumber,:);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%exterior
    
    [exrow,excol] = find(extedgeimage);%
    exedgeinturn = zeros(length(exrow),2);%
    exedgeinturn(1,1) = exrow(1);%
    exedgeinturn(1,2) = excol(1);%
    exedgeinturn(2,1) = exrow(2);%
    exedgeinturn(2,2) = excol(2);%
    %%%%%%%%%%%%%%% initialization of exterior edge
    
    for n = 2:100000000%%%%%%%%%%%exterior
        dist4ex = [];
        for i = -1:1
            for j = -1:1%%%%%%%%%%%% search from the neighbour
                if extedgeimage(exedgeinturn(n,1)+i,exedgeinturn(n,2)+j)&&...
                        ~ismember([exedgeinturn(n,1)+i,exedgeinturn(n,2)+j],exedgeinturn,'rows')
                   dist4ex = [dist4ex;[exedgeinturn(n,1)+i,exedgeinturn(n,2)+j,...
                       norm([exedgeinturn(n,1)+i-exedgeinturn(n-1,1),exedgeinturn(n,2)+j-exedgeinturn(n-1,2)])]]; 
                end
            end
        end
        
        if isempty(dist4ex)
            break
        end
        
        [temp,temppos] = max(dist4ex(:,3));%pick the point the farthest from last point
        exedgeinturn(n+1,1) = dist4ex(temppos,1);
        exedgeinturn(n+1,2) = dist4ex(temppos,2);
    end
    exedgeinturn(all(exedgeinturn==0,2),:)=[];%cut off [0,0] points
    
    num4aglcal = round(pxpmm/15);%distance of points to the concerned point used to calculate the local angle
    exangle = zeros(length(exedgeinturn),1);
    for n = 1:length(exedgeinturn)
        exvector = [0,0];
        
        if n-num4aglcal>0&&n+num4aglcal<=length(exedgeinturn)%
            nbf = n-num4aglcal;%
            naf = n+num4aglcal;%
       elseif n-num4aglcal<=0&&n+num4aglcal<=length(exedgeinturn)%naf ok, nbf too small
            nbf = n-num4aglcal+length(exedgeinturn);%
            naf = n+num4aglcal;%
        elseif n-num4aglcal>0&&n+num4aglcal>length(exedgeinturn)%nbf ok, naf too big
            nbf = n-num4aglcal;%
            naf = n+num4aglcal-length(exedgeinturn);%
        else
            nbf=n-num4aglcal+length(exedgeinturn);
            naf=n+num4aglcal-length(exedgeinturn);
        end%%%%%%%%%%%% deal with the boundary
        
        for ii = 1:3%
            for jj = 1:3%
                exvector = exvector+[ii-2,jj-2]*...%
                    (1-openedomega(exedgeinturn(n,1)-2+ii,exedgeinturn(n,2)-2+jj));%
            end%
        end%%%%%%%%%%%% calculate the vector pointing out of the body
        
        exangle(n) = acos(dot(exedgeinturn(nbf,:)-exedgeinturn(n,:),exvector)/norm(exedgeinturn(nbf,:)-exedgeinturn(n,:))...
                /norm(exvector))+acos(dot(exedgeinturn(naf,:)-exedgeinturn(n,:),exvector)...
                /norm(exedgeinturn(naf,:)-exedgeinturn(n,:))/norm(exvector));%exterior angle
    end
    
    exthresh=4;
    circspan=round(pxpmm/6);
    if any(exangle(1:circspan)>exthresh)

        exangle=circshift(exangle,-circspan);
        exedgeinturn=circshift(exedgeinturn,-circspan);
    end

    smoothspan=2.*round((pxpmm/30+1)/2)-1;
    smoothexangle=smooth(exangle,smoothspan,'sgolay',1);
    [maximaheight,maximaloca]=findpeaks(smoothexangle,'MinPeakDistance',smoothspan,...
        'MinPeakProminence',0.4,'MaxPeakWidth',round(length(smoothexangle)/3));
    numexmaxima=length(maximaloca);
    
    if numexmaxima==1
        
        smoothexangle=6-smooth(exangle,smoothspan,'sgolay',1);
        [minimaheight,minimaloca]=findpeaks(smoothexangle,'MinPeakDistance',smoothspan,...
        'MinPeakProminence',0.4,'MaxPeakWidth',round(length(smoothexangle)/3),'SortStr','descend');
        if isempty(minimaloca)
            disp('ERROR: No minima made it past the PeakProminence/PeakWidth/PeakDistance thresholds.')
            return
        end
    
        errorflag=1;
        minimadisthresh=5;
        while errorflag==1
            try
                j1=1;
                while maximaloca(1)-minimaloca(j1)<ceil(minimadisthresh*smoothspan)
                    j1=j1+1;
                end
                extouching=exedgeinturn(minimaloca(j1),:);
                errorflag=0;
            catch
                minimadisthresh=minimadisthresh-0.5;
            end
        end
        
        cutimage = insertShape(openedomega,'line',[intouching(2) intouching(1) ...
            1.1*(extouching(2)-intouching(2))+intouching(2) 1.1*(extouching(1)-intouching(1))+intouching(1)], ...
            'LineWidth',3,'Color','black'); %cutting
        cutmask = im2bw(cutimage,graythresh(cutimage));
        
    elseif numexmaxima==2
        
        exforwlength=maximaloca(2)-maximaloca(1);
        exbackwlength=length(exedgeinturn)-exforwlength;
        
        num4aglcal=round(pxpmm/30);
        if exforwlength<exbackwlength
            exedgefocus=exedgeinturn(maximaloca(1)-num4aglcal:maximaloca(2)+num4aglcal,:);
            
        elseif exforwlength>exbackwlength
            exedgefocus=[exedgeinturn(maximaloca(2)-num4aglcal:end,:);...
                exedgeinturn(1:maximaloca(1)+num4aglcal,:)];
        end
        
        exfocangle = zeros(length(exedgefocus),1);
        for n = 1:length(exedgefocus)
            exvector = [0,0];

            if n-num4aglcal>0&&n+num4aglcal<=length(exedgefocus)%
                nbf = n-num4aglcal;%
                naf = n+num4aglcal;%
            elseif n-num4aglcal<=0&&n+num4aglcal<=length(exedgefocus)%naf ok, nbf too small
            nbf = n-num4aglcal+length(exedgefocus);%
            naf = n+num4aglcal;%
             elseif n-num4aglcal>0&&n+num4aglcal>length(exedgefocus)%nbf ok, naf too big
            nbf = n-num4aglcal;%
            naf = n+num4aglcal-length(exedgefocus);%
            else
            nbf=n-num4aglcal+length(exedgefocus);
            naf=n+num4aglcal-length(exedgefocus);
            end%%%%%%%%%%%% deal with the boundary

            for ii = 1:3%
                for jj = 1:3%
                    exvector = exvector+[ii-2,jj-2]*...%
                        (1-openedomega(exedgefocus(n,1)-2+ii,exedgefocus(n,2)-2+jj));%
                end%
            end%%%%%%%%%%%% calculate the vector pointing out of the body
            
            exfocangle(n) = acos(dot(exedgefocus(nbf,:)-exedgefocus(n,:),exvector)/norm(exedgefocus(nbf,:)-exedgefocus(n,:))...
                    /norm(exvector))+acos(dot(exedgefocus(naf,:)-exedgefocus(n,:),exvector)...
                    /norm(exedgefocus(naf,:)-exedgefocus(n,:))/norm(exvector));%exterior angle
        end
        
        [extouchingangle,extouchingnumber] = min(exfocangle);                  %minimum ex-angle within focus
        extouching = exedgefocus(extouchingnumber,:);
        cutimage = insertShape(openedomega,'line',[intouching(2) intouching(1) ...
            1.1*(extouching(2)-intouching(2))+intouching(2) 1.1*(extouching(1)-intouching(1))+intouching(1)], ...
            'LineWidth',3,'Color','black'); %cutting
        cutmask = im2bw(cutimage,graythresh(cutimage));
        
    elseif numexmaxima>2
        fprintf('\nError in number of exterior maxima.\n')
        figure(framenum)
        plot(smoothexangle)
        maximaheight=maximaheight
        maximaloca=maximaloca
        uiwait
        cutmask=[];
    end
end



