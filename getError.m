function [error] = getError(preds,Y)
%GETERROR Summary of this function goes here
%   Detailed explanation goes here
if length(preds)~=length(Y)
	error('getError function: input arguments preds and Y must be arrays of same length.');
end

Ypreds=preds>0.5;
error=mean(Ypreds~=Y);
end

