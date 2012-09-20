clc
clear all
close all

q = [1;0];
A = [0.9 0.1 0 ; 0 0.9 0.1];
mc = MarkovChain(q,A);
g1 = GaussD('Mean',0, 'StDev',1);
g2 = GaussD('Mean',3,'StDev',2);
h = HMM(mc,[g1;g2]);
x = [-0.2 2.6 1.3];
c = [1 0.1625 0.8266 0.0581];
pX = prob([g1;g2],x);
betaHat = backward(mc,pX,c);