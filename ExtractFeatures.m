% Feature extraction for character recognition
% Input: 3xN matrix containing x,y,b values
% Output: a column vector of extracted features
function [features,featureVector] = ExtractFeatures(data)

featureVector = PreprocessData(data);
features = [];

N = 0;
EN = 0;
E = 0;
ES = 0;
S = 0;
WS = 0;
W = 0;
WN = 0;
L = 0;


penups = sum(featureVector(3,:)==0);
pendowns = sum(featureVector(3,:)==1);
size_v = size(featureVector,2);
window = pendowns / 4;

penups_cor = [];
penupsInd = 0;
pendowns_cor = [];
first_zero = -1;
first_one = -1;
start_ = 1;

strokeInd = 1;


% x_penup = []
% y_penup = 0;
% x_pendown = 0;
% y_pendown = 0;
count  = 2;
segment_size = 0;


while count <= size_v
    
    prev_x =  featureVector(1,count-1);
    prev_y =  featureVector(2,count-1);
    next_x = featureVector(1,count);
    next_y = featureVector(2,count);
    
    diff_x = next_x - prev_x;
    diff_y = next_y - prev_y;
    
    
    
    
    if (featureVector(3,count-1) ==1) || (first_zero < 0)
        
        %%% Find direction %%%
        
        c = 0.3;
        
        tan_theta = diff_y / (diff_x+ 0.000000001);
        
        angle = atand(tan_theta);
        
        
        
        if (diff_y >=0) && (diff_x >=0)
            angle = angle;
            
        elseif (diff_y>=0)&&(diff_x<0)
            angle = 180 + angle;
            
        elseif (diff_y<=0)&&(diff_x<0)
            angle = 180 + angle;
            
        elseif (diff_y<=0)&&(diff_x>=0)
            
            angle = 360 + angle;
            
            
            
            
        end
        
        
        
        
        if ((angle >=350) && (angle<=20))   %east
            
            
            E = E + 1;
            
        elseif ((angle >20) && (angle<=75)) %northeast
            
            
            EN = EN + 1;
            
        elseif ((angle >75) && (angle<=115)) %north
            
            
            N = N + 1;
            
        elseif ((angle >115) && (angle<=160)) %northwest
            
            
            WN = WN + 1;
            
        elseif ((angle >160) && (angle<=200))  %west
            
            
            W = W + 1;
            
        elseif ((angle >200) && (angle<=250))  %southwest
            
            
            WS = WS + 1;
            
            
        elseif ((angle >250) && (angle<=290))  %S
            
            
            S = S + 1;
            
        elseif ((angle >290) && (angle<=349))  %southeast
            
            
            ES = ES + 1;
        end
        
        
        %%% Find length %%%
        % ENCODE LENGTH RATE TO 0,1,2,3
        Ltmp = sqrt(diff_x^2 + diff_y^2);
        Lcode = -1;
        L = L + Ltmp;
        if L <= 0.25 * c
            Lcode = 0;
        elseif (L <=0.5 * c) && (L > 0.25 * c)
            Lcode = 1;
        elseif (L <=0.75 * c) && (L > 0.5 * c)
            Lcode = 2;
        elseif (L >0.75 * c)
            Lcode = 3;
        end
        
        
        
        if penups ==0 % one stroke char use segments
            %SEPERATE THE LINES INTO SEGMENTS AND GET THE MOST POPULAR
            %DIRECTION
            if (segment_size == floor(window)) || (count == size(featureVector,2))
                
                % first feature direction
                popularDir = [E ; EN ; N ; WN; W; WS; S; ES]';
                [tmp , pop] = max(popularDir,[],2);
                features(1,strokeInd) = pop - 1;
                %first feature
                
                %second feature length
                features(2,strokeInd) = Lcode;
                %second feature
                
                %third and fourth feature x,y pos for pendowns
                features(3:4,strokeInd) = 0;
                %third and fourth feature
                
                %fifth feature writting stroke ratio
                features(5,strokeInd) = 0;
                %fifth feature
                
                N = 0;
                EN = 0;
                E = 0;
                ES = 0;
                S = 0;
                WS = 0;
                W = 0;
                WN = 0;
                L = 0;
                segment_size = 0;
                strokeInd = strokeInd + 1;
                
            end
            
            
        else % multistroke char
            
            if ((featureVector(3,count-1) == 0)) || (count == size(featureVector,2))
                
                
                
                first_zero = 0;
                penups_cor(1,strokeInd) = prev_x;
                penups_cor(2,strokeInd) = prev_y;
                penupsInd = size(penups_cor,2)
                % first feature direction
                popularDir = [E ; EN ; N ; WN; W; WS; S; ES]';
                [tmp , pop] = max(popularDir,[],2);
                strokeInd
                pop-1
                features(1,strokeInd) = pop - 1;
                %first feature
                
                %second feature length
                features(2,strokeInd) = Lcode;
                %second feature
                
%                 %third and fourth feature x,y pos for pendowns
%                 if size(pendowns_cor,2) ~= 0
%                 features(3,size(pendowns_cor,2)) = pendowns_cor(1,strokeInd);
%                 features(4,size(pendowns_cor,2)) = pendowns_cor(2,strokeInd);
%                 end
%                 %third and fourth feature
                
                %fifth feature writting stroke ratio
                features(5,strokeInd) = (count - start_ + 1)/pendowns;
                %fifth feature
              
                N = 0;
                EN = 0;
                E = 0;
                ES = 0;
                S = 0;
                WS = 0;
                W = 0;
                WN = 0;
                L = 0;
                
                
               strokeInd = strokeInd + 1; 
            end
            
            
            
            
            
        end
        segment_size  = segment_size + 1;
        
    else
        
        if first_zero == 0
            
            if featureVector(3,count) == 1
                first_zero
                k = size(penups,2)
                pendowns_cor (1,penupsInd) = next_x;
                pendowns_cor (2,penupsInd) = next_y;
                start_ = count;
                first_zero = -1;
                
            end
            
        end
        
        
    end % pendown
    
    count = count + 1;
    
end % while

if penups > 0 
    c = 1;
    

while c < size(penups_cor,2)
    c
    x_ = pendowns_cor(1,c) - penups_cor(1,c)
    y_ = pendowns_cor(2,c) - penups_cor(2,c)
    features(3,c+1) = x_;
    features(4,c+1) = y_;
    c = c + 1;
end
end

end