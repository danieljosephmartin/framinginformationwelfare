function [D,i,q1ax,q1bax,q2ax,q2bax]=Restrictions(a,s,p,z,P1,P2)

% Intialize constraint matrix
D=zeros(1,p);
i=0;
% Determine NIAS constraints for frame 1
q1ax=zeros(a,p);
q1bax=zeros(a*a,p);
for aa=1:a
    for bb=1:a
        if aa~=bb
        i=i+1;
        for pp=1:p
            q1ax(aa,pp)=0;
            q1bax((aa-1)*a+bb,pp)=0;
            for ss=1:s
                if z(aa,ss)==pp
                    q1ax(aa,pp)=q1ax(aa,pp)+P1(aa,ss);
                end
                if z(bb,ss)==pp
                    q1bax((aa-1)*a+bb,pp)=q1bax((aa-1)*a+bb,pp)+P1(aa,ss);
                end
            end
        end
        % Add to bank of NIAS constraints 
        D(i,:)=q1ax(aa,:)-q1bax((aa-1)*a+bb,:);
        end
    end
end

% Determine NIAS constraints for frame 2
q2ax=zeros(a,p);
q2bax=zeros(a*a,p);
for aa=1:a
    for bb=1:a
        if aa~=bb
        i=i+1;
        for pp=1:p
            q2ax(aa,pp)=0;
            q2bax((aa-1)*a+bb,pp)=0;
            for ss=1:s
                if z(aa,ss)==pp
                    q2ax(aa,pp)=q2ax(aa,pp)+P2(aa,ss);
                end
                if z(bb,ss)==pp
                    q2bax((aa-1)*a+bb,pp)=q2bax((aa-1)*a+bb,pp)+P2(aa,ss);
                end
            end
        end
        % Add to bank of NIAS constraints
        D(i,:)=q2ax(aa,:)-q2bax((aa-1)*a+bb,:);
        end
    end
end

end