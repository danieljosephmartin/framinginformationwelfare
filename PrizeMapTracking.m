function z=PrizeMapTracking(a,s)

z=zeros(a,s);
for aa=1:a
    for ss=1:s
        if aa==ss
            z(aa,ss)=aa;
        else
            z(aa,ss)=a+1;
        end
    end
end

%%% Start Reporting %%% 
% z
%%% End Reporting %%% 

end