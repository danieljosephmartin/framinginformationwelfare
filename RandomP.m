function [P1,P2,AW1,AW2,WA1,WA2]=RandomP(a,s)

stateprobs=ones(1,a)'*randfixedsum(s,1,1,0,1)';
% Determine action probabilities in each state in each frame
actionprobs1=randfixedsum(a,s,1,0,1);
actionprobs2=randfixedsum(a,s,1,0,1);
% Determine the state-dependent stochastic data set
P1=stateprobs.*actionprobs1;
P2=stateprobs.*actionprobs2;

% Allow prior to vary
% stateprobs1=ones(1,a)'*randfixedsum(s,1,1,0,1)';
% stateprobs2=ones(1,a)'*randfixedsum(s,1,1,0,1)';
% P1=stateprobs1.*actionprobs1;
% P2=stateprobs2.*actionprobs2;

%%% Start Reporting %%% 
% sum(P1,1)
% sum(P2,1)
% sum(P1,2)
% sum(P2,2)
% sum(sum(P1))
% sum(sum(P2))
%%% End Reporting %%% 

end