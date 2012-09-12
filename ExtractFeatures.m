% Feature extraction for character recognition
% Input: 3xN matrix containing x,y,b values
% Output: a column vector of extracted features
function [features,featureVector] = ExtractFeatures(data)
%%% eliminate beginning and ending silence %%%
i = 1;
N = size(data,2);
while (data(3,i) == 0)
    i = i+1; % go to the point when the character drawing began
end
data = data(:,i:end); % ignore the initial part when the mouse wasn't pressed
N2 = size(data,2);
flag = N2; % we want to trunk the ending "silence" as well; flag will be the index of the last time when the mouse button was pressed before exiting
for i = N2 : -1 : 1
    if (data(3,i) == 0)
        flag = flag-1;
    end
end
data = data(:,1:flag); % trunk the data from the right
featureVector = data;

%%% make the character start in the center of the drawing area %%%
x_deviation = featureVector(1,1) - 0.5;
y_deviation = featureVector(2,1) - 0.5;
for i = 1 : size(featureVector,2)
    featureVector(1,i) = featureVector(1,i) - x_deviation;
    featureVector(2,i) = featureVector(2,i) - y_deviation;
end

%%% normalize the size of character instead of AxB we want CxC
%%% source : http://www.google.com/patents/EP0107196B1?cl=en %%%
xmax = max(featureVector(1,:),[],2);
xmin = min(featureVector(1,:),[],2);
ymax = max(featureVector(2,:),[],2);
ymin = min(featureVector(2,:),[],2);

A = xmax-xmin
B = ymax-ymin
C = 2; % arbitary chosen constant

for i = 1 : size(featureVector,2)
    featureVector(1,i) = (C*(featureVector(1,i)-xmin))/A;
    featureVector(2,i) = (C*(featureVector(2,i)-ymin))/B;
end

%%% extract the directions for the feature vector %%%
%%% N = 0 , NE = 1, E = 2, ES = 3, S = 4, WS = 5, W = 6, WN = 7
count = 1;
prev_x = 0;
prev_y = 0;
features= [];
e = 0.001; % error rate
while count < size(featureVector,2)
    
    
    prev_x =  featureVector(1,count);
    prev_y =  featureVector(2,count);
    next_x = featureVector(1,count+1);
    next_y = featureVector(2,count+1);
    
    diff_x = next_x - prev_x;
    diff_y = next_y - prev_y;
    
    
    if (diff_y>e) && ((diff_x >= 0) && (diff_x <= e))
        
        features(count) = 0;
        
    elseif (diff_y>e) && (diff_x >e)
        
        features(count) = 1;
        
        
    elseif (diff_x>e) && ((diff_y >= 0) && (diff_y <= e))
        features(count) = 2;
        
        
    elseif (diff_y<-e) && (diff_x >e)
        features(count) = 3;
        
        
    elseif (diff_y<-e) && ((diff_x >= 0) && (diff_x <= e))
        features(count) = 4;
        
    elseif (diff_y < -e) && (diff_x < -e)
        features(count) = 5;
        
    elseif (diff_x<-e) && ((diff_y >= 0) && (diff_y <= e))
        features(count) = 6;
        
        
    elseif  (diff_y>e) && (diff_x < -e)
        features(count) = 7;
    end
    
    count = count +1;
    
    
end
features
featureVector
end


