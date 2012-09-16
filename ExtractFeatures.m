% Feature extraction for character recognition
% Input: 3xN matrix containing x,y,b values
% Output: a column vector of extracted features
function [features,featureVector] = ExtractFeatures(data)
featureVector = PreprocessData(data);

%%% extract the directions for the feature vector %%%
%%% N = 0 , NE = 1, E = 2, ES = 3, S = 4, WS = 5, W = 6, WN = 7
count = 2;
L = 0;
ind = 1;
prev_x = 0;
prev_y = 0;
N = size(featureVector(1,:));
features= [];
segment_size = 0;
e = 0.001; % error rate
ind_start = 1;
N = 0;
EN = 0;
E = 0;
ES = 0;
S = 0;
WS = 0;
W = 0;
WN = 0;
first_zero = 0;
zer = 0;
size_v = size(featureVector,2)
pen_ups = sum(featureVector(3,:)==0)
end_ = 0;
start_ = 0;
x_penup = 0;
y_penup = 0;
x_pendown = 0;
y_pendown = 0;
features(3:4,1:size_v-1) = 0;
while count <= size_v
    
    prev_x =  featureVector(1,count-1);
    prev_y =  featureVector(2,count-1);
    next_x = featureVector(1,count);
    next_y = featureVector(2,count);
    
    diff_x = next_x - prev_x;
    diff_y = next_y - prev_y;

    
    if (featureVector(3,count-1) == 0) && (first_zero > 0) % if is a pen_up and is not the first one put -1 for directions and Length rate
        features(1:2,ind) = -1;
        start_ = ind;
%         x_penup = featureVector(1,(count-1)) ;
%         y_penup = featureVector(2,(count-1)) ;
        
        if featureVector(3,count) == 1
            features(3,count) = next_x - x_penup;
            features(4,count) = next_y - y_penup;
            start_ = count;
        end
        
    elseif ((featureVector(3,count-1) == 0) && (first_zero ==0)) || (featureVector(3,count-1) == 1) %first penup or pendown fill with data direction and length rate
        
        if   (featureVector(3,count-1) == 1)
            
            first_zero == 0 ;
        end
        
        if (count - 1) == 1 %% first element
            start_ = 1;
            
        end
        
        %%%%%%%%%%%%%%% Find Direction %%%%%%%%%%%%%%
        
        
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
            
            %  features(1,ind) = 0;
            E = E + 1;
            
        elseif ((angle >20) && (angle<=75)) %northeast
            
            %  features(1,ind) = 1;
            EN = EN + 1;
            
        elseif ((angle >75) && (angle<=115)) %north
            
            %  features(1,ind) = 2;
            N = N + 1;
            
        elseif ((angle >115) && (angle<=160)) %northwest
            
            %  features(1,ind) = 3;
            WN = WN + 1;
            
        elseif ((angle >160) && (angle<=200))  %west
            
            %  features(1,ind) = 4;
            W = W + 1;
            
        elseif ((angle >200) && (angle<=250))  %southwest
            
            % features(1,ind) = 5;
            WS = WS + 1;
            
            
        elseif ((angle >250) && (angle<=290))  %S
            
            % features(1,ind) = 6;
            S = S + 1;
            
        elseif ((angle >290) && (angle<=349))  %southeast
            
            % features(1,ind) = 7;
            ES = ES + 1;
        end
        
        
        %%%%%%%%%%% END FIND DIRECTION %%%%%%%%%%%%%
        
        %%%%%%% FIND RANGE LENGTH ENCODE IT%%%%%%%%%%%%%%
        
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
        
        
        %%%%%%% END FIND RATE LENGTH %%%%%%%%%%
        
        
        if (featureVector(3,count-1) == 0) || (count == size(featureVector,2)) % if penup occur or you reach the maximum size
            
            features(2,start_:end_) = Lcode;  %NEEDS REFACTORING FOR ONE STROKE ELEMENTS
           % features(3:4,start_:end_) = 0;
            if count < size_v
                features(2,(end_+1)) = -1;
                features(1,(end_+1)) = -1;

                
            else
                features(2,(end_+1)) = Lcode;
                
            end

            L = 0;
            first_zero = first_zero + 1;
        end
        
        if pen_ups == 0  % if there is no more than one stroke
            %SEPERATE THE LINES INTO SEGMENTS AND GET THE MOST POPULAR
            %DIRECTION
            if (segment_size == 4) || (count == size(featureVector,2))
                
                popularDir = [E ; EN ; N ; WN; W; WS; S; ES]';
                [tmp , pop] = max(popularDir,[],2);
                features(1,start_:end_) =pop-1;
              %  features(3:4,start_:end_) = 0;
                N = 0;
                EN = 0;
                E = 0;
                ES = 0;
                S = 0;
                WS = 0;
                W = 0;
                WN = 0;
                start_ = end_;
                segment_size = 0;
                
            end
        elseif pen_ups>0 % if there are more than one strokes
            
            %%%TODO NEEDS DEBBUGING %%%%
            
            
            if(featureVector(3,count-1) == 0)  || ((count -1) == (size_v-1))  % get each stroke
                %  if (segment_size == 5) || (count == size(featureVector,2))
                
                if count == size_v
                    count
                end
                popularDir = [E ; EN ; N ; WN; W; WS; S; ES]'
                x_penup = featureVector(1,count-1);
                y_penup = featureVector(2,count-1);
             %   features(3,(end_+1)) = featureVector(1,count-1) - featureVector(1,count-2);
             % k1 =   features(3,(end_+1))
             %   features(4,(end_+1)) = featureVector(2,count-1) - featureVector(2,count-2);
            %  k2 =   features(4,(end_+1)) 
                
                [tmp , pop] = max(popularDir,[],2);
                pop-1
                
                
                features(1,start_:end_) = pop-1;  %FEEL THE DIRECTIONS FROM THE FIRST PENDOWN UNTIL YOU HAVE A PENUP
               % features(3:4,start_:end_) = 0;
                
                if count < size_v
                    
                    features(1,(end_+1)) = -1;

                    
                else
                    features(1,(end_+1)) = pop-1;
                end
                
                
                segment_size = 0;
                N = 0;
                EN = 0;
                E = 0;
                ES = 0;
                S = 0;
                WS = 0;
                W = 0;
                WN = 0;
                first_zero = first_zero + 1;
                %  ind_start = count - 1;
                
            end
            %  end
            
        end   %pen_ups
        
        
        segment_size = segment_size + 1;
        
    end
    
    
    count = count +1;
    end_ = end_ + 1;
    ind  = ind + 1;
    
    
end


end


