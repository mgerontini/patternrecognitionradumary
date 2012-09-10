%Get preprocessed data
%it normalizes the feature vector for the size and the location
% location: substract minimum value from each non zero element
% size: divide maximum value from normalized location values.

function [new_data] = PreprocessData(data)
%%% PREPROCESSING %%%
counter = 1;
segmentx = [];
segmenty = [];
    tmpx= [];
    tmpy = [];
for i= 1:size(data(3,:),2)

    if data(3,i) ~= 0
        tmpx =[tmpx;data(1,i)];
        tmpy =[tmpy;data(1,i)];
    
    else
        if size(tmpx)~= 0 
tmpx=tmpx';
tmpy=tmpy';
        segmentx(counter,:) = tmpx(1,:)
        segmenty(counter,:) = tmpy(1,:)
        end
        tmpx = [];
        tmpy=[];
        counter = counter + 1
        
    end
end


outxNorm = segmentx - repmat(min(segmentx,[],2), 1, size(segmentx,2)) 
outyNorm = segmenty - repmat(min(segmenty,[],2), 1, size(segmenty,2)) 

  max_x = max(outxNorm,[],2)
  max_y = max(outyNorm,[],2)


    

  con = 1;
  for j= 1:size(data(3,:),2)

    if data(3,j) ~= 0
        
       data(1,j)  =  data(1,j)/max_x(con);
       data(2,j)  =  data(1,j)/max_y(con);
    
    
    else 
        con = con+1;
        continue;
    end 
        
  end
  
  

    






new_data = data;


end

