flist=dir('dataset'); % will give you list of specifed files



for ii=1:length(flist)
    if flist(ii).isdir == 0
         data{ii}=load(strcat('dataset/',flist(ii).name)); % load files in workspace
         
    end
    
end


for i = 3:length(data)
    
    img1 = floor((1-20+1)*rand+20);
    img2 = floor((1-20+1)*rand+20);
    if img1 == img2
      img2 = floor((1-20+1)*rand+20);  
    end
    figure(1);
    DisplayCharacter(data{i}.c{img1});
    figure(2);
    DisplayCharacter(data{i}.c{img2});
    hold;
    
end