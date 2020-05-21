
clear all
format long

% To run simulations
sims=100; % Set number of simulations         
a=4; s=3; p=12; % Number of actions states and prizes
tracking=0; % =1 if a tracking problem

% To estimate proportions of data sets for decision problems (see below)
problem=0; % Classes of decision problems simulated in the a paper
dominance=0; % =1 if want to add dominance assumptions

% To test data sets for decision problems (see below)
example=0; % Example data sets in the a paper
if example>0
    sim=1;
    problem=example;
end

% problem=0;            % For simlations 
% problem=1;            % For 3x3x4 (Tracking)
% problem=2;            % For 3x3x5 (Distinct Prizes) 
% problem=3;            % For 3x8x6 (Two Types)
% problem=4;            % For PPO application (2x2x3 w/ constant action)
                     
% example=0;            % For simlations 
% example=1;            % For 3x3x4 (Tracking)
% example=2;            % For 3x3x5 (Distinct Prizes) 
% example=3;            % For 3x8x6 (Two Types)
% example=4;            % For PPO application (2x2x3 w/ constant action)

% Number of actions, states, and prizes 
tracking=0;
if problem==1           % For 3x3x4 (Tracking)
    a=3; s=3; p=4; 
elseif problem==2       % For 3x3x5 (Distinct Prizes)
    a=3; s=3; p=5; 
elseif problem==3       % For 3x8x6 (Two Types)
	a=3; s=8; p=6; 
elseif problem==4       % For 2x2x3 w/ constant action (PPO application)
    a=2; s=2; p=3;
end

% Initialize all result vectors for simulations
equalityflag=zeros(1,sims); equalityerrorflag=zeros(1,sims); 
NIASFflag=zeros(1,sims); NIASFerrorflag=zeros(1,sims);
BREf=zeros(1,sims); BREferrorflag=zeros(1,sims); 
BREg=zeros(1,sims); BREgerrorflag=zeros(1,sims);
BRPf=zeros(1,sims); BRPferrorflag=zeros(1,sims);
BRPg=zeros(1,sims); BRPgerrorflag=zeros(1,sims);
BFSf=zeros(1,sims); BFSferrorflag=zeros(1,sims);
BFSg=zeros(1,sims); BFSgerrorflag=zeros(1,sims);

for sim=1:sims
  
% Generate random data set (for simulations)
[Pf,Pg]=RandomP(a,s);

% To test data sets for decision problems (see below)
if example==1           % For 3x3x4 (Tracking)
    Pf=[1/5 0 0; 0 11/50 9/50; 0 9/50 11/50];
    Pg=[1/10 2/10 2/10; 1/20 2/10 0; 1/20 0 2/10];
elseif example==2       % For 3x3x5 (Distinct Prizes)
    Pf=[1/3 0 0; 0 2/9 1/9; 0 1/9 2/9];
    Pg=[1/6 1/12 1/12; 1/12 1/72 17/72; 1/12 17/72 1/72];
elseif example==3       % For 3x8x6 (Two Types)
	Pf=[6/48 6/48 6/48 6/48 0 0 0 0; 0 0 0 0 4/48 2/48 3/48 3/48; 0 0 0 0 2/48 4/48 3/48 3/48];
    Pg=[4/48 4/48 4/48 4/48 2/48 2/48 2/48 2/48; 1/48 1/48 1/48 1/48 0 4/48 2/48 2/48; 1/48 1/48 1/48 1/48 4/48 0 2/48 2/48];
elseif example==4       % For 2x2x3 w/ constant action (PPO application)
    Pf=[10/100 40/100; 40/100 10/100];
    Pg=[5/100 20/100; 45/100 30/100];
elseif example==5
    Pf=[0.219923211040381 0.129655345654846 0.020852940334068;
    0.214467633277726   0.018185865893343   0.009673732377233;
    0.120062998252756   0.023342366708600   0.016827947848581;
    0.196408071133624   0.019488083847550   0.011111803631292];
    Pg=[0.139082250712627   0.098482573862582   0.010886400983702;
    0.109409535883985   0.018082510507619   0.029755817012650;
    0.184333285361237   0.067453130422442   0.009403282037746;
    0.318036841746637   0.006653447311697   0.008420924157076];
end

% Determine revealed experiment and revealed posteriors
REf=Pf./(ones(1,a)'*sum(Pf,1));
REg=Pg./(ones(1,a)'*sum(Pg,1));
RPf=Pf./(sum(Pf,2)*ones(1,s));
RPg=Pg./(sum(Pg,2)*ones(1,s));

% Determine map between actions, states, and prizes
if problem==0
    if tracking==1
        z=PrizeMapTracking(a,s);
    else
        if a*s==p
            z=PrizeMapDistinct(a,s);
        else
            z=PrizeMapRandom(a,s,p);
        end
    end
elseif problem==1           % For 3x3x4 (Tracking)
    z=PrizeMapTracking(a,s); 
elseif problem==2       % For 3x3x5 (Distinct Prizes)
    z=PrizeMapDistinct(a,s);
elseif problem==3       % For 3x8x6 (Two Types)
	z=[1 1 1 1 2 2 2 2; 4 3 4 3 3 4 3 4; 6 6 5 5 6 5 5 6];
elseif problem==4       % For PPO application (2x2x3 w/ constant action)
    z=[1 3; 2 2];
end

% Determine restrictions given by data
[D,i,qfax,qfbax,qgax,qgbax]=Restrictions(a,s,p,z,Pf,Pg);

% Determine extra restrictions given by knowledge of world
if dominance==1
    if problem==4       % For PPO application (2x2x3 w/ constant action)
        D(i+1,:)=[1 -1 0]; D(i+2,:)=[0 1 -1]; i=i+2;
    end
end

% Remove redundant contraints from D
[Dnew,inew]=RemoveRedundant(D,i);

% Find equalities
[Dstrict,Dequal,equalityflag(1,sim),equalityerrorflag(1,sim)]=FindEqualities(Dnew,inew);

% Test NIASF using LP problem but with strict and equal
[NIASFflag(1,sim),NIASFerrorflag(1,sim),uNIAS]=NIASF(p,Dequal,Dstrict);

% Test FIAS
% Check if frame f is better
[BFSf(1,sim),BFSferrorflag(1,sim)]=BFS(qfax,qgax,i,D);
% Check if frame g is better
[BFSg(1,sim),BFSgerrorflag(1,sim)]=BFS(qgax,qfax,i,D);

% Revealed Better Informed Actions
% REf * S = REg
[BREf(1,sim),BREferrorflag(1,sim)]=BRE(a,s,REf,REg);
% REg * S = REf
[BREg(1,sim),BREgerrorflag(1,sim)]=BRE(a,s,REg,REf);

% MPS of Revealed Posteriors
% RPf * T = RPg
[BRPf(1,sim),BRPferrorflag(1,sim)]=BRP(a,s,RPf,RPg);
% RPg * T = RPf
[BRPg(1,sim),BRPgerrorflag(1,sim)]=BRP(a,s,RPg,RPf);

end

disp('Error flags (all should be zero)')
mean(equalityerrorflag)
mean(NIASFerrorflag)
mean(BREferrorflag)
mean(BREgerrorflag)
mean(BRPferrorflag)
mean(BRPgerrorflag)
mean(BFSferrorflag)
mean(BFSgerrorflag)

disp('How often NIASF inequalities were equal (w/o pass and w/ pass')
mean(equalityflag)
mean(equalityflag.*NIASFflag)

disp('Summary - NIASF rate, Blackwell rate, FIAS rate, Blackwell+NIAS rate, FIAS+NIAS rate, Rate where gap')
mean(NIASFflag)
mean(BREf)+mean(BREg)
mean(BFSf)+mean(BFSg)
mean(BREf.*NIASFflag)+mean(BREg.*NIASFflag)
mean(BFSf.*NIASFflag)+mean(BFSg.*NIASFflag)
((mean(BFSf.*NIASFflag)+mean(BFSg.*NIASFflag))-(mean(BREf.*NIASFflag)+mean(BREg.*NIASFflag)))/mean(NIASFflag)
