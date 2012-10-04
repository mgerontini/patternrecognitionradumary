clc
clear all
close all
nStates = 5;
q = [1 ; 0 ; 0];
A = [.99 .01 0 0 ; 0 .99 .01 0 ; 0 0 .99 .01];
mc = MarkovChain(q, A);
pD(1) = GaussD('Mean',[0 0 0],'StDev',[0.1 0.1 0.3]);
pD(2) = GaussD('Mean',[1 0 0.2],'StDev',[0.2 0.2 0.3]);
pD(3) = GaussD('Mean',[-1 0.1 -0.1],'StDev',[0.3 0.2 0.1]);
% pD(4) = GaussD('Mean',[-1 0.35 0.2 0],'StDev',[0.1 0.3 0.2 0.1]);
% pD(5) = GaussD('Mean',[-2 0.4 -0.2 0],'StDev',[0.2 0.3 0.1 0.2]);
hGen = HMM('MarkovChain',mc,'OutputDistr',pD);
files = dir('dataset\*.mat');
for i = 1 : size(files)
    sprintf('Training file %d',i)
    cd dataset;
    load(files(i).name);
    cd ..
    trainingFeatures = [];
    testingFeatures = [];
    for j = 1 : 15
        temp = ExtractFeatures2(PreprocessData(c{j,1}));
        features = [temp(1,:) ; temp(3:4,:)];
        trainingFeatures = [trainingFeatures features];
        lData(j) = size(features,2);
    end
    hNew = MakeLeftRightHMM(nStates,GaussD,trainingFeatures,lData);
    string = strcat('HMMs/',files(i).name);
    save(string,'hNew');
    
    
    
    
    
    
    %     for j = 16 : 20
    %         testingFeatures = [testingFeatures ExtractFeatures2(PreprocessData(c{j,1}))];
    %     end
end