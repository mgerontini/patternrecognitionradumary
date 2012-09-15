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

pen_ups = sum(featureVector(3,:)==0)

while count <= size(featureVector,2)
    
    
    
    if (featureVector(3,count-1) == 0) && (first_zero > 0) % if is a pen_up and is not the first one put -1 for directions and Length rate
        features(1:2,ind) = -1;
        ind_start = ind;
           
    elseif ((featureVector(3,count-1) == 0) && (first_zero ==0)) || (featureVector(3,count-1) == 1) %first penup or pendown fill with data direction and length rate
       
   if   (featureVector(3,count-1) == 1)
        first_zero == 0 ;
   end  
   
   %%%%%%%%%%%%%%% Find Direction %%%%%%%%%%%%%%
    prev_x =  featureVector(1,count-1);
    prev_y =  featureVector(2,count-1);
    next_x = featureVector(1,count);
    next_y = featureVector(2,count);
    
    diff_x = next_x - prev_x;
    diff_y = next_y - prev_y;
    
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
        
        features(2,ind_start:ind) = Lcode;  %NEEDS REFACTORING FOR ONE STROKE ELEMENTS
       
        L = 0;
        first_zero = first_zero + 1;
    end 
        
    if pen_ups == 0  % if there is no more than one stroke
        %SEPERATE THE LINES INTO SEGMENTS AND GET THE MOST POPULAR
        %DIRECTION
        if (segment_size == 4) || (count == size(featureVector,2))
            
            popularDir = [E ; EN ; N ; WN; W; WS; S; ES]';
            [tmp , pop] = max(popularDir,[],2);
            features(1,ind_start:ind) =pop-1;
            N = 0;
            EN = 0;
            E = 0;
            ES = 0;
            S = 0;
            WS = 0;
            W = 0;
            WN = 0;
           segment_size = 0;
            
        end
    elseif pen_ups>0 % if there are more than one strokes
        
        %%%TODO NEEDS DEBBUGING %%%%
        
        if(featureVector(3,count-1) == 0)  || (count == size(featureVector,2))  % get each stroke
         %  if (segment_size == 5) || (count == size(featureVector,2))
               count
                popularDir = [E ; EN ; N ; WN; W; WS; S; ES]'
                [tmp , pop] = max(popularDir,[],2);
                features(1,ind_start:ind) =pop-1;  %FEEL THE DIRECTIONS FROM THE FIRST PENDOWN UNTIL YOU HAVE A PENUP
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
               
         end
       %  end
        
    end   %pen_ups
         
         ind_start = ind; %%PROBLEMATIC WHEN I HAVE PENUPS
         segment_size = segment_size + 1; 
         
    end
    
   
    count = count +1;
    ind = ind+1;
  
    
end


end


