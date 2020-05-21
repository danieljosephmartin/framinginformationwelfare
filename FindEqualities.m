function [Dstrict,Dequal,equalityflag,equalityerrorflag]=FindEqualities(Dnew,inew)

% Optimizer settings
options=optimset('linprog');
options.Display='off';
options.Preprocess='none';

% Find all equalities
Dstrict=[];
Dequal=[];
equalityflag=0;
equalityerrorflag=0;

% Need at least two constraints
if inew>1
    for i1=1:inew
        Dtemp=Dnew;
        % Grab contraint
        beq=Dnew(i1,:);
        % Drop contraint
        Dtemp(i1,:)=[];
        % Check if a non-negative combo gives negative of constraint 
        f=zeros(inew-1,1);
        lb=zeros(inew-1,1);
        [x,fval,exitflag,output]=linprog(f,[],[],Dtemp',beq.*-1,lb,[],[],options);        
        
        % Deal with wierd exit flag or a solution (x) clearly outside of bounds (given numeric precision)
        tighten=1;
        while ((exitflag~=1 && exitflag~=-2) || (exitflag==1 && min(x)<-.000000001)) && max(lb)<0.0001
            % Indicate problematic solution
            equalityerrorflag=1;
            % Tighten bounds
            tighten=tighten*10;
            lb=lb+.000000001*tighten;
            [x,fval,exitflag,output]=linprog(f,[],[],Dtemp',beq.*-1,lb,[],[],options);   
        end

        if exitflag==1 && min(x(find(abs(x-0)>.000000001)))>.000000001 % && ((abs(min(x(find(abs(x-0)>.000000001)))-max(x(find(abs(x-0)>.000000001))))<.000000001) || sum(length(find(abs(x-0)>.000000001)))==1)  
            Dequal=[Dequal; beq];
            equalityflag=1;
        else
            Dstrict=[Dstrict; beq];
        end
    end
end

end