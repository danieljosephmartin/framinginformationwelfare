function [BAW1,BAW1errorflag]=BAW(a,s,AW1,AW2)

% Optimizer settings
options=optimset('linprog');
options.Display='off';
options.Preprocess='basic';

% Inputs: Number of actions and states, Data conditional on state

% Put into standard Blackwell form (states x actions)
TAW1=AW1';
TAW2=AW2';
tmp=repmat({TAW1},a,1);
AW1mat=blkdiag(tmp{:});
AW2vec=(reshape(TAW2,1,a*s))';
AW1eye=[];
for aaaa=1:a
    AW1eye=[AW1eye eye(a)];
end
AW2eye=ones(a,1);
f=zeros(a*a,1);
lb=zeros(a*a,1);
ub=ones(a*a,1);

[x,fval,exitflag,output]=linprog(f,[],[],[AW1mat; AW1eye],[AW2vec; AW2eye],lb,ub,[],options);

% Deal with wierd exit flag or a solution (x) clearly outside of bounds (given numeric precision)
tighten=1;
BAW1errorflag=0;
while ((exitflag~=1 && exitflag~=-2) || (exitflag==1 && min(x)<-.000000001) || (exitflag==1 && max(x)>1.000000001)) && max(lb)<0.0001 && min(ub)>0.9999
    % Indicate problematic solution
    BAW1errorflag=1;
    % Tighten bounds
    tighten=tighten*10;
    if min(x)<-.000000001
        lb=lb+.000000001*tighten;
    end
    if max(x)>1.000000001
        ub=ub-.000000001*tighten;
    end
    % Try again with new bounds
    [x,fval,exitflag,output]=linprog(f,[],[],[AW1mat; AW1eye],[AW2vec; AW2eye],lb,ub,[],options);
end
BAW1=(exitflag==1);

end