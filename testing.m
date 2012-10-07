%%store Hmms in an array
hmms_dir =  dir('Hmms/*.mat');
addpath('Hmms');
hmms = [];
for i = 1:size(hmms_dir)
    load(hmms_dir(i).name);
    
    hmms{i} = hNew;
    
end


%%log prob
for i = 1:size(testingFeatures,2)
lP = logprob(hmms,testingFeatures(:,i))
end