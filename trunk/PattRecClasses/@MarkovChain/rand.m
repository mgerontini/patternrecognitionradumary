function S=rand(mc,T)
%S=rand(mc,T) returns a random state sequence from given MarkovChain object.
%
%Input:
%mc=    a single MarkovChain object
%T= scalar defining maximum length of desired state sequence.
%   An infinite-duration MarkovChain always generates sequence of length=T
%   A finite-duration MarkovChain may return shorter a sequence,
%   if the END state was reached before T samples.
%
%Result:
%S= integer row vector with random state sequence,
%   NOT INCLUDING the END state,
%   even if encountered within T samples
%If mc has INFINITE duration,
%   length(S) == T
%If mc has FINITE duration,
%   length(S) <= T
%
%---------------------------------------------
%Code Authors:
%---------------------------------------------

A = mc.TransitionProb;
q = mc.InitialProb;
[~, initialState] = histc(rand(1,1),[0;cumsum(q(:))/sum(q)]);
S(1) = initialState;
switch (size(A,2) == size(A,1))
    case 1
        for i = 1 : T-1
            row = A(S(i),:);
            [~, S(i+1)] = histc(rand(1,1),[0;cumsum(row(:))/sum(row)]);
        end
    case 0
        for i = 1 : T-1
            row = A(S(i),:);
            [~, number] = histc(rand(1,1),[0;cumsum(row(:))/sum(row)]);
            if (number == size(A,2))
                break
            end
            S(i+1) = number;
        end
end




