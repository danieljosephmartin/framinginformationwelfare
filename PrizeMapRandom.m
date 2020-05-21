function z=PrizeMapRandom(a,s,p)

% Temporary number of prizes
m=0; 
while m<p || min(std(z))==0 % if want different prizes in a state
    z=ceil(rand(a,s).*p);
    m=length(unique(z));
end

%%% Start Reporting %%% 
% z
%%% End Reporting %%% 

end