function finallength(s)

global PERXY

premo

cd(oldfolder)
cd('DATA_SAVED')

disp(['Constructing length for ' int2str(s)])

fieldname=['frame' int2str(s)];

try    

    X=load(['skeleton_' int2str(s)]);
    Y=load(['edge_' int2str(s) '.txt']);

    X=[zeros(size(X,1),1),X,zeros(size(X,1),1)];
    X=[zeros(1,size(X,2));X;zeros(1,size(X,2))];
    first=[Y(1,2);Y(1,1)]+1;

    PERXY.(fieldname)=first;
    aaa=1;
    while((length(find(X==1))>1))
        aaa=aaa+1;
        A=[];

        for i=first(1)-3:first(1)+1
            for j=first(2)-3:first(2)+1
                if (X(i,j)==1)  
                    if (i==first(1) && j==first(2))

                    else    

                    A=[A;[j,i,sqrt((i-first(1))^2+(j-first(2))^2)]];
                    end
                end

            end
        end

        k=find(A(:,3)==min(A(:,3)));
        k=k(1);
        PERXY.(fieldname)=[PERXY.(fieldname),[A(k,2);A(k,1)]];

        X(first(1),first(2))=0;

        L=bwlabel(X,8);
        L1=max(L(:));

        if L1>1

            size11=[];
            for w=1:L1
            ra=find(L==w);
            size11=[size11,length(ra)];
            end
            size11=size11;
            p=find(size11==max(size11));

            er=find(~(L==p));

            X(er)=0;
            A=[];
            for i=first(1)-2:first(1)+2
                for j=first(2)-2:first(2)+2
                    if (X(i,j)==1)  

                        if (i==first(1) && j==first(2))

                        else    

                        A=[A;[j,i,sqrt((i-first(1))^2+(j-first(2))^2)]];
                        end
                    end

                end
            end
            k=find(A(:,3)==min(A(:,3)));
            first=[A(k,2);A(k,1)];
        else

            first=[A(k,2);A(k,1)];
        end
    end

    PERXY.(fieldname)=PERXY.(fieldname)-1;
catch

    cd(oldfolder)
    disp('Error detected')
%     err=lasterror;
%     disp(err)
%     disp(err.message)
%     disp(err.identifier)
    skel_correct(s)
    EDGEA=Y(1,:);
    EDGEB=Y(2,:);
    endpoints2(s,EDGEA,EDGEB)
    finallength(s)
end

cd(oldfolder)
