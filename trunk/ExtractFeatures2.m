% Feature extraction for character recognition
% Input: 3xN matrix containing x,y,b values
% Output: the feature vectors of the normalized data: first row is the
% direction of the pen
function features = ExtractFeatures2(data)
data = preprocessData(data); % normalize the data

%%%% FIND THE DIRECTION FOR EVERY FRAME %%%%
for i = 1 : size(data, 2)-1
    differenced_data(:,i) = data(1:2,i+1) - data(1:2,i);
end
for i = 1 : size(differenced_data,2)
    features(1,i) = rad2deg(atan2(differenced_data(2,i),differenced_data(1,i))); % calculate the angle of the pen movement
end

%%%% DETERMINE HOW MANY STROKES THE CHARACTER HAS %%%%
strokes = 1;
i = 0;
while (i < size(data,2))
    i = i+1;
    if (data(3,i) == 0) % the pen is lifted
        strokes = strokes + 1;
        while (data(3,i) == 0)
            i = i+1; % go to the next pen down
        end
    end
    
end

%%%% CASE OF MULTIPLE STROKES %%%%
