clear all
clc
close all

q = [0.75 ; 0.25];
A = [0.99 0.01 ; 0.03 0.97];
b1 = GaussD('Mean', 0, 'Variance', 1);
b2 = GaussD('Mean', 3, 'Variance', 2);

mc = MarkovChain(q, A);
h = HMM(mc, [b1;b2]);
[x,s] = rand(h, 100000);
flag1 = 0;
flag2 = 0;
for i = 1 : 100000
    if (s(i) == 1)
        flag1 = flag1 + 1;
    
    else 
        flag2 = flag2 + 1;
    end
end