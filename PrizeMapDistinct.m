function z=PrizeMapDistinct(a,s)

z=zeros(a,s);
for aa=1:a
    for ss=1:s
        z(aa,ss)=(aa-1)*s+ss;
    end
end

%%% Start Reporting %%% 
% z
%%% End Reporting %%% 

end