function [BPC1,BPC1errorflag]=BFS(q1ax,q2ax,i,D)

% Optimizer settings
options=optimset('linprog');
options.Display='off';
options.Preprocess='none';

% Inputs: Number of actions and states, Data conditional on state

q1=sum(q1ax,1);
q2=sum(q2ax,1);
beq=q1-q2;
% Check if in polar
f=zeros(i,1);
lb=zeros(i,1);
[x,fval,exitflag,output]=linprog(f,[],[],D',beq,lb,[],[],options);

% Deal with wierd exit flag or a solution (x) clearly outside of bounds (given numeric precision)
tighten=1;
BPC1errorflag=0;
while ((exitflag~=1 && exitflag~=-2) || (exitflag==1 && min(x)<-.000000001)) && max(lb)<0.0001
	% Indicate problematic solution
    BPC1errorflag=1;
    % Tighten bounds
    tighten=tighten*10;
    lb=lb+.000000001*tighten;
    [x,fval,exitflag,output]=linprog(f,[],[],D',beq,lb,[],[],options);
end
BPC1=(exitflag==1);

end