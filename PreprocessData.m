%Get preprocessed data
%it normalizes the feature vector for the size and the location
% location: substract minimum value from each non zero element
% size: divide maximum value from normalized location values.

function [new_data] = PreprocessData(data)
%%% PREPROCESSING %%%

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
    else
        break;
    end
end
data = data(:,1:flag); % trunk the data from the right



%%% normalize the size of character instead of AxB we want CxC
%%% source : http://www.google.com/patents/EP0107196B1?cl=en %%%
xmax = max(data(1,:),[],2);
xmin = min(data(1,:),[],2);
ymax = max(data(2,:),[],2);
ymin = min(data(2,:),[],2);

A = xmax-xmin;
B = ymax-ymin;
C = 0.3; % arbitary chosen constant

for i = 1 : size(data,2)
    data(1,i) = (C*(data(1,i)-xmin))/A;
    data(2,i) = (C*(data(2,i)-ymin))/B;
end

%%% make the character start in the center of the drawing area %%%
x_deviation = data(1,1) - 0.5;
y_deviation = data(2,1) - 0.5;
for i = 1 : size(data,2)
    data(1,i) = data(1,i) - x_deviation;
    data(2,i) = data(2,i) - y_deviation;
end
new_data = data;
