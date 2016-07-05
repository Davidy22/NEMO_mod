function [A,B]=endpoints(s,A,B,d,phase)
%
%   COPYRIGHT:  George D. Tsibidis(1) and Nektarios Tavernarakis(2)
%               (1) Institute of Electronic Structure and Laser 
%               (2) Institute of Molecular Biology and Biotechnology 
%               Foundation for Research and Technology-Hellas (FORTH)
%               January 2007
%
%
% a: starting s
% b: ending s
% A: coordinates of head  76 139    
% B: coordinates of tail  170 195    
%A-->A+1
%B-->B+1

premo
    
cd ('DATA_SAVED')
K2=[0,0;0,0];

disp(['Exporting edge data for ' int2str(s)])

cd(oldfolder)
cd('DATA_SAVED')

if phase(s-d+1)~=111

    if s~=d && phase(s-d)==111  %detect omega turn ends

        disp('Omega Turn End detected')
        corrected_skel=load(['skeleton_' int2str(s)]);
        figskel=figure('name','OMEGA TURN END: Choose head, then tail');imshow(corrected_skel);
        [c,r,p]=impixel(corrected_skel);
        A=[c(1),r(1)];
        B=[c(2),r(2)];
        close(gcf)
        cd(oldfolder)
        [Anext,Bnext]=endpoints2(s,A,B);
    else

        sk=load(['skeleton_' int2str(s)]);

        sk=[zeros(size(sk,1),1),sk,zeros(size(sk,1),1)];
        sk=[zeros(1,size(sk,2));sk;zeros(1,size(sk,2))];

        endpoints=bwmorph(sk,'endpoints');

        M=[];
        [c,r]=find(endpoints==1);

        for t=1:length(r(:))

            M=[M;[t,r(t),c(t)]];
        end

        START=[];END=[];

        for t=1:length(r(:))

            START=[START;[M(t,1) M(t,2) M(t,3) (M(t,2)-A(1))^2+(M(t,3)-A(2))^2]];
            END=[END;[M(t,1) M(t,2) M(t,3) (M(t,2)-B(1))^2+(M(t,3)-B(2))^2]];
        end

        k=find(START(:,end)==min(START(:,end)));
        START_value=[M(k(1),2), M(k(1),3)];

        k1=find(END(:,end)==min(END(:,end)));
        END_value=[M(k1(1),2), M(k1(1),3)];

        K1=K2;
        K2=[START_value; END_value];

        cd ..
        cd ('DATA_SAVED')
        aq=['edge_' int2str(s) '.txt'];
        save(aq,'K2','-ascii');

        A=K1(1,:);
        B=K1(2,:);
        Anext=K2(1,:);
        Bnext=K2(2,:);

        M([k(1) k1(1)],:)=[]; 

    end

    if (Anext(1)==Bnext(1) && Anext(2)==Bnext(2))   %detect errors and correct

        disp('Error detected')
        cd(oldfolder)
        skel_correct(s)
        cd(oldfolder)
        [Anext,Bnext]=endpoints2(s,A,B);
    end

else    %if omega turn, set edges to previous non-omega

    disp('Omega turn')
    EDGES=load(['edge_' int2str(s-1) '.txt']);
    filecopy=['edge_' int2str(s) '.txt'];
    save(filecopy,'EDGES', '-ascii');
    
    Anext=A;
    Bnext=B;
    
end

A=[];
B=[];
A=Anext;
B=Bnext;
       %%%%% the points which are the ends of tails that should be removed
cd(oldfolder)
