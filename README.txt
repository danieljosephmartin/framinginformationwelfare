MATLAB programs that performs all of the tests.  

Tests20200520.m
In this program, you can determine, the number of simulations you want to run, how many actions, states, and prizes you want, and whether you want to test any of the decision problems or example data sets from the paper "Framing, Information, and Welfare" by Andrew Caplin and Daniel Martin.

Dependencies:
BFS.m = Tests FIAS
BRE.m = Tests for garbling of revealed experiments
BRP.m = Tests for MPS of revealed posteriors
FindEqualities.m = Looks to see if any NIAS-F inequalities hold with equality
NIASF.m = Tests for NIAS-F
NIASFStrict.m = Tests for NIAS-F assuming none hold with equality 
PrizeMapDistinct.m = Creates map between actions, states, and prizes if prizes distinct
PrizeMapRandom.m = Creates random map between actions, states, and prizes
PrizeMapTracking.m = Creates map between actions, states, and prizes for tracking problem
RandomP.m = Creates random data set
RemoveRedundant.m = Removes redundant NIASF inequalities
Restrictions.m = Generates NIASF inequalities

randfixedsum.m
Roger Stafford (2020). Random Vectors with Fixed Sum (https://www.mathworks.com/matlabcentral/fileexchange/9700-random-vectors-with-fixed-sum), MATLAB Central File Exchange. Retrieved May 21, 2020. 