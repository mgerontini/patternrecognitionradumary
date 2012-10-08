%%store Hmms in an array
hmms_dir =  dir('Hmms/*.mat');
addpath('Hmms');
hmms = [];
for i = 1:size(hmms_dir)
    load(hmms_dir(i).name);
    
    hmms{i} = hNew;
    
end


%%log prob
% c = DrawCharacter;
% data = PreprocessData(c);
% features = ExtractFeatures2(data);
% lP = logprob(hmms,features)
testing_dir =  dir('TestingFeatures/*.mat');
addpath('TestingFeatures');
TC = 0;
FC = 0;
 for i = 1:size(testing_dir)
  % ind =   getClassFromInd(classes(i));
   
     test_data = load(testing_dir(i).name);
     for j = 1:size(test_data.testingFeatures,2)
 lP = logprob(hmms,test_data.testingFeatures(:,j));
 c = getClass(lP);
c
if c ~= i
    FC = FC + 1;
else
    TC = TC + 1;
end
 sprintf('The actual class is %s' , testing_dir(i).name)
     end
 end
 
 FC
 TC