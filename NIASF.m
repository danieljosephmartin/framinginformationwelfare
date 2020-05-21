function [lpsolflag,lpsolerrorflag,u]=NIASF(m,Dequal,Dstrict)

% Optimizer settings
options=optimset('linprog');
options.Display='off';
options.Preprocess='basic';

% Inputs: m=number of prizes, D=NIAS matrix

% Find solution
if isempty(Dstrict)==1
    lpsolflag=0; % NIAS can't hold strictly
    lpsolerrorflag=0; 
    u=[];
elseif isempty(Dequal)==1
    [lpsolflag,lpsolerrorflag,u]=NIASFStrict(m,Dstrict); % Normal way
else
    % Generate inputs to lingprog function
    % Vector to multipy by utility (to minimize)
    f=zeros(m,1);
    % RHS of NIAS inequalities (if positive, all constraints strict)
    b=zeros(size(Dstrict,1),1)+.00001;
    bequal=zeros(size(Dequal,1),1);
    
    [u,fval,exitflag]=linprog(f,Dstrict.*-1,b.*-1,Dequal,bequal,[],[],options);

    % Deal with wierd exit flag or a solution (x) clearly outside of bounds (given numeric precision)
    tighten=1;
    lpsolerrorflag=0;
    % Keep trying until resolve problem
    while ((exitflag~=1 && exitflag~=-2) || (exitflag==1 && (abs(min(Dstrict*u)-0)<.000000001 || min(Dequal*u)<-.000000001))) && max(b)<0.1
        % Indicate problematic solution
        lpsolerrorflag=1;
        % Tighten bounds
        tighten=tighten*10;
        b=b+.00001*tighten;
        % Try again with new bounds
        [u,fval,exitflag]=linprog(f,Dstrict.*-1,b.*-1,Dequal,bequal,[],[],options);
    end 
    lpsolflag=(exitflag==1); 
end

end