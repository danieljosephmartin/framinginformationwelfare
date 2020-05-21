function [Dnew,inew]=RemoveRedundant(D,i)

% Note all redundant constraints
depend=[];
for i1=1:i
    for i2=1:i
        % Let one constraint go through and check higher ones
        if i2>i1
            if abs((D(i1,:)/(norm(D(i1,:))))-(D(i2,:)/(norm(D(i2,:)))))<.000000001
                depend=[depend i2];
            end
        end
    end
end
% Cut redundant constraints
Dnew=D;
depend=unique(depend);
Dnew(depend,:)=[];
inew=size(Dnew,1);

end
