function end_correct(start,finish)

    global PERXI

    premo;

    for s=start:finish

            try    
                cd(oldfolder)
                cd('DATA_SAVED')
                T=load(['skeleton_' int2str(s)]);
                W=T;
                Z=load(['mask_' int2str(s)]);
                
                cd ../
                
                initiallength(Z,W,s)
                
                %change the directory to 'DATA_SAVED'

                
                %Load skeleton and edge into workspace.


                correcting_endpoints=s

                O=length(PERXI); %returns the length of vector PERXI

                perim=bwperim(Z,8); %Find perimeter of objects in binary image.
                %P=bwlabel(perim,8); %P is not being used

                Q=PERXI(:,1); %takes every rows of the first column of PERXI
                R=PERXI(:,round(O/20)); %takes every rows of the correspondent column to the round of the length of PERXI divided by 50
                S=PERXI(:,end); %takes every rows of the last column of PERXI
                T=PERXI(:,end-round(O/50)); %takes every rows of the correspondent column to the subtraction of the last row and the round of the length of PERXI divided by 50

                vecs=Q-R;
                vece=S-T;
                try
                    pts=Q+12*vecs;
                    pte=S+12*vece;

                    fig1=figure('visible','off','units','normalized','outerposition',[1 1 1 1]);imshow(W);
                    %fig1; %not being used

                    segs=imline(gca,[pts(2),Q(2)],[pts(1),Q(1)]);
                    BI1=segs.createMask(); % returns a mask that is associated with the ROI object over the target image
                    W(BI1)=255; 
                    sege=imline(gca,[pte(2),S(2)],[pte(1),S(1)]);
                    BI2=sege.createMask(); % returns a mask that is associated with the ROI object over the target image
                    W(BI2)=255;
                    
                catch
                    
                    try
                        
                        pts=Q+8*vecs;
                        pte=S+4*vece;

                        fig1=figure('visible','off','units','normalized','outerposition',[1 1 1 1]);imshow(W);
                        %fig1; %not being used

                        segs=imline(gca,[pts(2),Q(2)],[pts(1),Q(1)]);
                        BI1=segs.createMask(); % returns a mask that is associated with the ROI object over the target image
                        W(BI1)=255;
                        sege=imline(gca,[pte(2),S(2)],[pte(1),S(1)]);
                        BI2=sege.createMask(); % returns a mask that is associated with the ROI object over the target image
                        W(BI2)=255;
                        
                    catch
                        
                        pts=Q+4*vecs;
                        pte=S+8*vece;

                        fig1=figure('visible','off','units','normalized','outerposition',[1 1 1 1]);imshow(W);
                        %fig1; %not being used

                        segs=imline(gca,[pts(2),Q(2)],[pts(1),Q(1)]);
                        BI1=segs.createMask(); % returns a mask that is associated with the ROI object over the target image
                        W(BI1)=255;
                        sege=imline(gca,[pte(2),S(2)],[pte(1),S(1)]);
                        BI2=sege.createMask(); % returns a mask that is associated with the ROI object over the target image
                        W(BI2)=255;
                        
                    end
                end

                close(fig1);

                W(perim)=255;
            
                %remove pixels so that an object without holes shrinks to a 
                %minimally connected stroke, and an object with holes shrinks 
                %to a ring halfway between the hole and outer boundary
                W=bwmorph(W,'thin',Inf);   
            
                %Find branch points of skeleton
                W=bwmorph(W,'branchpoints');

                [c,r]=find(W==1);
                size1=length(r(:)); %returns the length of vector r
                
                %M=[];
                M=zeros(size1,3);
                for t=1:size1
                   %M=[M;[t,r(t),c(t)]];    
                   M(t,:) = [t,r(t),c(t)];  %list of branchpoints and positions
                end

                %START=[];END=[];
                START = zeros(size1,4);
                END=zeros(size1,4);
                for t=1:size1
                   %START=[START;[M(t,1) M(t,2) M(t,3) (M(t,2)-Q(2))^2+(M(t,3)-Q(1))^2]];
                   START(t,:)=[M(t,1) M(t,2) M(t,3) (M(t,2)-Q(2))^2+(M(t,3)-Q(1))^2];       %list of distances from original point
                   END(t,:)=[M(t,1) M(t,2) M(t,3) (M(t,2)-S(2))^2+(M(t,3)-S(1))^2];
                end

                k=find(START(:,end)==min(START(:,end)));
                START_value=[M(k(1),2); M(k(1),3)];
                
                k1=find(END(:,end)==min(END(:,end)));
                END_value=[M(k1(1),2); M(k1(1),3)];

                fig2=figure('visible','off','units','normalized','outerposition',[1 1 1 1]);imshow(T);
                %fig2; 

                segs2=imline(gca,[START_value(1),Q(2)],[START_value(2),Q(1)]);      %draw line from old endpoint to closest branch
                BI3=segs2.createMask(); % returns a mask that is associated with the ROI object over the target image
                T(BI3)=255;
                sege2=imline(gca,[END_value(1),S(2)],[END_value(2),S(1)]);          %draw line from old endpoint to closest branch
                BI4=sege2.createMask(); % returns a mask that is associated with the ROI object over the target image
                W2(BI4)=255;

                close(fig2);

                %remove pixels so that an object without holes shrinks to a 
                %minimally connected stroke, and an object with holes shrinks 
                %to a ring halfway between the hole and outer boundary
                T=bwmorph(T,'thin',Inf);   
                T=im2double(T);
                
                %changes the directory to DATA_SAVED and saves the skeleton
                %and the edges
                cd (oldfolder)
                cd ('DATA_SAVED')
                file1=['skeleton_' int2str(s)];
                save(file1,'T','-ascii');

                EDGES=[START_value';END_value'];
                file2=['edge_' int2str(s) '.txt'];
                save(file2,'EDGES','-ascii');
                
                if s==start+1
                    w=warning('query','last');
                    id=w.identifier;
                    warning('off',id)
                end
                
                if s==finish
                    warning('on','all')
                end
                
            catch
                %shows the error message, tries to fix it and run it again
                cd(oldfolder)
                err=lasterror;
                disp(err)
                disp(err.message);
                disp(err.identifier);
                disp(err.stack(1,1));
                disp(err.stack(2,1));
                disp(err.stack(3,1));
                skel_correct(s,100);
                extract_endpoints(s,s,1,0.5);
                end_correct(s,finish);
                break
            end
    end

    msgbox('Corrected endpoints.')
    %change the directory to oldfolder
    cd(oldfolder);
end
