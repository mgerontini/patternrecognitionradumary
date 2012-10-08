function [ class] = getClass( lP)

[val ind] = max(lP,[],2);

class = getClassFromInd(ind);
end





