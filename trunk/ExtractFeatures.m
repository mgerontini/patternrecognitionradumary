% Feature extraction for character recognition
% Input: 3xN matrix containing x,y,b values
% Output: a column vector of extracted features
function featureVector = ExtractFeatures(data)
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


