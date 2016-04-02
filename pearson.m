function [similarity] = pearson(s1,s2)
%%% computes the pearson's correlation coefficient between s1 and s2
%%% identical to the corr function in Matlab except that it does not return NaN
    d=length(s1); %%% the total number of features
    ki=sum(s1); %%  number of features selected in s1
    kj=sum(s2); %%  number of features selected in s2
    expR=(ki*kj)/d; %% the expected size of the intersection when the selection is random
    pi=ki/d; 
    pj=kj/d;
    upsiloni=sqrt(pi*(1-pi));
    upsilonj=sqrt(pj*(1-pj));
    r=sum((s1+s2)==2); %% size of the intersection between ri and rj
    similarity=(r-expR)/(d*upsiloni*upsilonj);
	%%% for the underteminate forms...
	if (ki==d && kj==d) || (ki==0 && kj==0) %% Identical sets, similarity=1
		similarity=1;
	end
    if isnan(similarity) %% otherwise similarity=0 
		similarity=0;
    end
end

