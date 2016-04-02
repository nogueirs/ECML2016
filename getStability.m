function [stability] = getStability(A,func)
%GETSTABILITY Summary of this function goes here
% func can be any similarity measure taking two binary strings of lengths d as an input
% This function computes the average pairwise similarities between the rows of A
% to call this function, for example: getStability(A,@pearson) will get the stability using Pearson's correlation coefficient.

M=size(A,1);
stability=0;
for i=1:M
    for j=1:M
        if i~=j
            stability=stability+func(A(i,:),A(j,:));
        end
    end
end
stability=stability/(M*(M-1));
end






