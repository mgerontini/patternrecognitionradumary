function R=rand(pD,nData)
%R=rand(pD,nData) returns random scalars drawn from given Discrete Distribution.
%
%Input:
%pD=    DiscreteD object
%nData= scalar defining number of wanted random data elements
%
%Result:
%R= row vector with integer random data drawn from the DiscreteD object pD
%   (size(R)= [1, nData]
%
%----------------------------------------------------
%Code Authors:
%----------------------------------------------------

if numel(pD)>1
    error('Method works only for a single DiscreteD object');
end;

% pD.ProbMass is a normalized column vector where each value represents the
% probability of emitting a number equal to its index
% for example if pD.ProbMass(3) = 0.3, there is a 0.3 chance to draw the
% number 3 from the discrete distribution

[~,R] = histc(rand(1,nData),[0;cumsum(pD.ProbMass(:))/sum(pD.ProbMass)]); 

% idea belongs to Mo Chen in the MATLAB forum
% (http://www.mathworks.com/matlabcentral/fileexchange/21912-sampling-from-
% a-discrete-distribution)

