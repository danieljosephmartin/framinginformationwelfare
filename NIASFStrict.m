function [lpsolflag,lpsolerrorflag,u]=NIASFStrict(m,D)

% Optimizer settings
options=optimset('linprog');
options.Display='off';
options.Preprocess='basic';

% Inputs: m=number of prizes, D=NIAS matrix

% Generate inputs to lingprog function
% Vector to multipy by utility (to minimize)
f=zeros(m,1);
% Number of NIAS inequalities
i=size(D,1);
% RHS of NIAS inequalities (if positive, all constraints strict)
b=zeros(i,1)+.00001;

% Find solution
[u,fval,exitflag]=linprog(f,D.*-1,b.*-1,[],[],[],[],[],options);

% Deal with wierd exit flag or a solution (x) clearly outside of bounds (given numeric precision)
tighten=1;
lpsolerrorflag=0;
% Keep trying until resolve problem
while ((exitflag~=1 && exitflag~=-2) || (exitflag==1 && abs(min(D*u)-0)<.000000001))
    % Indicate problematic solution
    lpsolerrorflag=1;
    % Tighten bounds
    tighten=tighten*10;
    b=b+.00001*tighten;
    % Try again with new bounds
    [u,fval,exitflag]=linprog(f,D.*-1,b.*-1,[],[],[],[],[],options);
end 
lpsolflag=(exitflag==1);

end