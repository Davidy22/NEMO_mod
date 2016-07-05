function initiallength(mask,skel,s)

    global PERXI

    %change the directory to 'DATA_SAVED'
    premo
    cd(oldfolder)
    
    phase=load('phase.csv')
    cd('DATA_SAVED')

    %show for the user the current image
    discovering_length_for=s

    PERXI=[];
    %Load skeleton and edge into workspace.
    W=skel;
    Y=load(['edge_' int2str(s) '.txt']);
    
    %Create a matrix of zeros, based on W
    X=[zeros(size(W,1),1),W,zeros(size(W,1),1)];
    X=[zeros(1,size(X,2));X;zeros(1,size(X,2))];
    
    start=[Y(1,2);Y(1,1)]+1;


    PERXI=start;
    aaa=1; %not being used
    
    while((length(find(X==1))>1))
        aaa=aaa+1; %not being used
        A=[];

        %start(1)
        %start(2)
        for i=start(1)-3:start(1)+1
            for j=start(2)-3:start(2)+1
                %X(i,j); 
                if (X(i,j)==1)      
                    if ~(i==start(1) && j==start(2)) 
%                     else 
%                     if (i~=start(1) && j~=start(2))   
                        A=[A;[j,i,sqrt((i-start(1))^2+(j-start(2))^2)]];
                    end
                end

            end
        end

        %Search for the minimum index in the 3rd column of this Array
        %(distance)
        k=find(A(:,3)==min(A(:,3)));

        %Take only the first element and set it to the variable k
        k=k(1);
                
        PERXI=[PERXI,[A(k,2);A(k,1)]];

        
        X(start(1),start(2))=0;

        %Returns a matrix L, of the same size as X,
        %containing labels for the connected components in X. 8
        %specifies 8-connected objects
        L=bwlabel(X,8);
        
        %For vectors, max(X) is the largest element in X. For matrices,
        %max(X) is a row vector containing the maximum element from each
        %column. For N-D arrays, max(X) operates along the first
        %non-singleton dimension.
        L1=max(L(:));

        if L1>1

            %size11=[];
            size11 = zeros(L1, 2);
            for w=1:L1
                ra=find(L==w);
                %size11=[size11,length(ra)];
                size11(w) = length(ra); %returns the length of vector (ra) and saves in the array size11
            end
            %size11=size11; %doesn't make sense
            p=find(size11==max(size11)); %searches for the largest element in size11

            %er=find(~(L==p)); 
            er= ~(L==p); %searches where L is not equal to p
            
            X(er)=0;
            A=[];
            for i=start(1)-2:start(1)+2
                for j=start(2)-2:start(2)+2
                    if (X(i,j)==1)  
                        %if (i==start(1) && j==start(2)) 
                        %else 
                        if ~(i==start(1) && j==start(2))
                            A=[A;[j,i,sqrt((i-start(1))^2+(j-start(2))^2)]];
                        end
                    end
                end
            end
            k=find(A(:,3)==min(A(:,3))); %Search for the minimum index in the 3rd column of this Array
            
            %start=[A(k,2);A(k,1)]; 
        %else 
        end
        start=[A(k,2);A(k,1)]; 

    end


    PERXI=PERXI-1;
    
    %change the directory to oldfolder
    cd(oldfolder)
end
