function [BWA1,BWA1errorflag]=BWA(a,s,WA1,WA2)

% Optimizer settings
options=optimset('linprog');
options.Display='off';
options.Preprocess='none';

% Inputs: Number of actions and states, Data conditional on state

% Put into standard Blackwell form (states x actions)
TWA1=WA1';
TWA2=WA2';
tmp=repmat({TWA1},a,1);
WA1mat=blkdiag(tmp{:});
WA2vec=(reshape(TWA2,1,a*s))';
WA1eye=[];
for aaaa=1:a
    WA1temp=zeros(a,a);
    WA1temp(aaaa,:)=ones(1,a);
    WA1eye=[WA1eye WA1temp];
end
WA2eye=ones(a,1);
f=zeros(a*a,1);
lb=zeros(a*a,1);
ub=ones(a*a,1);

[x,fval,exitflag,output]=linprog(f,[],[],[WA1mat; WA1eye],[WA2vec; WA2eye],lb,ub,[],options);

% Deal with wierd exit flag or a solution (x) clearly outside of bounds (given numeric precision)
tighten=1;
BWA1errorflag=0;
while ((exitflag~=1 && exitflag~=-2) || (exitflag==1 && min(x)<-.000000001) || (exitflag==1 && max(x)>1.000000001)) && max(lb)<0.0001 && min(ub)>0.9999
    % Indicate problematic solution
    BWA1errorflag=1;
    % Tighten bounds
    tighten=tighten*10;
    if min(x)<-.000000001
        lb=lb+.000000001*tighten;
    end
    if max(x)>1.000000001
        ub=ub-.000000001*tighten;
    end
    % Try again with new bounds
    [x,fval,exitflag,output]=linprog(f,[],[],[WA1mat; WA1eye],[WA2vec; WA2eye],lb,ub,[],options);
end
BWA1=(exitflag==1);

end