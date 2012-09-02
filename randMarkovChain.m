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

A = mc.TransitionProb; % the matrix of transition probabilities
q = mc.InitialProb; % vector of initial state probabilities
[~, initialState] = histc(rand(1,1),[0;cumsum(q(:))/sum(q)]); % generate a random initial state
% using the vector of initial state probabilities, basically a discrete
% distribution
S(1) = initialState; % put the initial state in the S vector
switch (size(A,2) == size(A,1)) % if infinite duration or finite duration
    case 1 % infinite duration (square matrix)
        for i = 1 : T-1
            row = A(S(i),:); % the transition probabilities from state S(i) to the other states
            [~, S(i+1)] = histc(rand(1,1),[0;cumsum(row(:))/sum(row)]); % select a random new state 
        end
    case 0
        for i = 1 : T-1
            row = A(S(i),:);  % the transition probabilities from state S(i) to the other states
            [~, number] = histc(rand(1,1),[0;cumsum(row(:))/sum(row)]); % select a random new state
            if (number == size(A,2)) % if the new state is the END state
                break % exit the chain
            end
            S(i+1) = number; % the new state, if it's not the END state
        end
end




