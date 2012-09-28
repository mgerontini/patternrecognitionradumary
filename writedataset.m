c = DrawCharacter;
existeight = exist('eight','var');

if existeight == 1
    eight(size(eight)+1,:) = {c};
    eight
else 
  eight= {c};
end

if size(eight,1) == 20
    
    save('dataset/eight','eight');
end