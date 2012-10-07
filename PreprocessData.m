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
        break
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

data(1,:) = (C*(data(1,:)-xmin))/A;
data(2,:) = (C*(data(2,:)-ymin))/B;

%%% make the character start in the center of the drawing area %%%

data(1,:) = data(1,:) - data(1,1) + 0.5;
data(2,:) = data(2,:) - data(2,1) + 0.5;

%%% eliminate all frames but 1 for each pen-up sequence to make it such
%%% that movement when the pen is up does not matter
j = 1; % index to go through penups
for i = 1 : size(data,2)-1
    if (data(3,i) == 1 && data(3,i+1) == 0) % the beginning of a penup sequence
        penup_start(j) = i+1;
    end
    if (data(3,i) == 0 && data(3,i+1) == 1) % the end of a penup sequence
        penup_end(j) = i;
        j = j+1;
    end
end
numberOfPenups = j - 1; % subtract 1 since the last penup ending added 1 to the count
if (numberOfPenups > 0)
    new_data = data(:,1:penup_start(1)); % the first stroke
    for i = 1 : numberOfPenups
        if (i+1 <= numberOfPenups) % there is another pen-up sequence available after the current one
            new_data = [new_data data(:,penup_end(i)+1:penup_start(i+1))];
        end
    end
    new_data = [new_data data(:,penup_end(i)+1:end)];
else
    new_data = data;
end










