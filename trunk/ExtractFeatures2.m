% Feature extraction for character recognition
% Input: 3xN matrix containing NORMALIZED xyb values
% Output: the feature vectors of the normalized data: first row is the
% direction of the pen, second row is length of stroke, third and fourth
% row are offsets between the beginning of the new stroke and ending of the
% previous stroke


function features = ExtractFeatures2(data)
%%%% FIND THE DIRECTION FOR EVERY FRAME %%%%
for i = 1 : size(data, 2)-1
    differenced_data(:,i) = data(1:2,i+1) - data(1:2,i); % contains delta_x and delta_y
end
for i = 1 : size(differenced_data,2)
    % calculate the angle of the pen movement on every frame, this will be
    % the 1st feature; note that some 0-mean noise is added to avoid long
    % stretches of constant values
    if (data(3,i) ~= 0) % only calculate a direction when the pen is down, else set a direction of -500 (the angle is between -180 and 180, so -500 is not a valid angle)
        features(1,i) = rad2deg(atan2(differenced_data(2,i),differenced_data(1,i))) + randn(1,1); % add some noise to avoid 0 variance
    else
        features(1,i) = -500;
    end
end

%%%% DETERMINE HOW MANY STROKES THE CHARACTER HAS AND PUT EACH STROKE INTO
%%%% IT'S OWN CELL IF THE CHARACTER HAS MORE THAN 1 STROKE%%%%
j = 1; % index over the current stroke
stroke_begin(j) = 1; % the index of the beginning of the 1st stroke
for i = 1 : size(data,2)-1
    if (data(3,i) == 1 && data(3,i+1) == 0) % the end of a stroke
        stroke_end(j) = i;
        j = j+1;
    end
    if (data(3,i) == 0 && data(3,i+1) == 1) % the beginning of a stroke
        stroke_begin(j) = i+1;
    end
end
stroke_end(j) = size(data,2); % the last frame is always a pen-down, so it will be the end of the last stroke
numberOfStrokes = j; % the total number of strokes
for i = 1 : numberOfStrokes
    stroke{i} = data(:,stroke_begin(i):stroke_end(i)); % each stroke gets its own cell of dimensions 3xN
end

%%%%% FIND THE LENGTH OF EVERY STROKE, IN THE CASE OF A MULTIPLE STROKE
%%%%% CHARACTER AND ADD IT AS THE 2ND FEATURE
%%%%% ALSO ADD THE X AND Y OFFSETS FOR STROKES 2,3...
if (numberOfStrokes > 1)
    for i = 1 : numberOfStrokes
        total_movement = sum(stroke{i}(:,2:end) - stroke{i}(:,1:end-1),2); % 3x1 matrix of the total deviation on the x and y axis (3rd value will be 0, unimportant)
        lengthOfStroke(i) = sqrt(total_movement(1)^2+total_movement(2)^2); % the length of the i-th stroke; the values are typically between 0.05 and 0.43 for a diagonal over the whole drawing area
    end
    
    for i = 1 : numberOfStrokes
        for j = stroke_begin(i) : stroke_end(i)
            features(2,j) = lengthOfStroke(i) + 0.01*randn(1,1); % add a bit of noise to have some variance between values for frames in the same stroke
            if (i ~= 1) % not the first stroke
                features(3:4,j) = data(1:2,stroke_begin(i))-data(1:2,stroke_end(i-1)); % this is the x-offset between where the current stroke begins and where the previous one ended
            else
                features(3:4,j) = 0.1*randn(1,1); % for the first stroke there is no offset, so we just put in a little 0-mean noise, instead of having 0 everywhere.
            end
        end
    end
end
%%%% TREAT THE CASE OF A SINGLE STROKE CHARACTER %%%%
if (numberOfStrokes == 1)
    for i = 1 : size(differenced_data,2)
        features(2,i) = sqrt(differenced_data(1,i)^2+differenced_data(2,i)^2); % the length of a single frame
    end
    features(2,i+1) = features(2,i); % this is because the differenced data is 1 frame shorter than the normal data
    features(3:4,:) = [differenced_data(1:2,:) differenced_data(1:2,end)]; % offset is taken for each frame, in the case of a single stroke character
end





