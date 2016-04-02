function [error,av_error,logloss,av_logloss,num_lambdas,lambdas,stabilities,hat_pf,A] = experiment(data,labels,M,num_lambdas)
% 
% 

[m,d]=size(data); % m is the number of instances in the supplied dataset and d the number of features

%% We first apply the lassoglm function to get 100 sensible values of lambda
[B,FitInfo] = lassoglm(data,labels,'binomial','NumLambda',num_lambdas); 
lambdas=FitInfo.Lambda; %% The 100 values of lambda we will use in our experiments (regularizing parameter)
num_lambdas=length(lambdas); 
clear B FitInfo; %%% clears the variables B and FitInfo not needed afterwards

%%% We initialize some arrays
hat_pf=zeros(num_lambdas,d); %%% Each row contains the observed frequencies of selection of each one of the d features
logloss=zeros(num_lambdas,M); %%% Each row corresponds to the out-of-bag negative log-likelihood on each one of the M bootstrap samples for a given lambda
error=zeros(num_lambdas,M);  %%% Each row corresponds to the out-of-bag percentage of misclassifications on each one of the M bootstrap samples for a given lambda
stabilities=zeros(1,num_lambdas); %%% The stability of the features selected for each lambda using the non-zero coefficients returned on the M bootstraps
A=zeros(num_lambdas,M,d); %%% For each regularizing parameter, the matrix A as described in the paper. A(i,:,:) gives the M feature sets for the i-th regularizing parameter

for i=1:num_lambdas %% For each regularizing parameter lambda
    i
    for j=1:M %% for each bootstrap samples
        bootInd=randsample(m,m,true); %% The indices of the examples to include in the bootstrap
        OOB=setdiff(1:m,bootInd); %% The out-of-bag indices
        bootData=data(bootInd,:); %% The bootstrap dataset
        bootLabels=labels(bootInd); %% the bootstrap labels
        [B_boot,Fit_boot]=lassoglm(bootData,bootLabels,'binomial','Lambda',lambdas(i)); %% Fits a L1-regularized logistic regression on the bootstrap dataset for a given regularizing parameter \lambda
        featureSet=B_boot~=0; %% the feature set returned (corresponding to the features associated with a coefficient different from 0)
        featureSet=featureSet';
        A(i,j,:)=featureSet; %% store the feature set in the matrix A
        %%% GET THE OOB Negative log likelihood
        OOBData=data(OOB,:); % the out-of-bag examples
        OOBLabels=labels(OOB); % the out-of-bag labels
        cnst = Fit_boot.Intercept; % the intercept of the model
        B = [cnst;B_boot]; %% coefficients + intercept
        preds = glmval(B,OOBData,'logit'); %% The predictions for every OOB example
        logloss(i,j)=getLogLoss(preds,OOBLabels); %% stores the negative log likelihood of the predictions compared with the true labels
        error(i,j)= getError(preds,OOBLabels); %% stores the percentage of misclassifications when thresholding the output of the logistic regression at 0.5
    end 
    AA=reshape(A(i,:,:),M,d); %% reshaping A just to be able to pass it to other functions
    stabilities(i)=getStability(AA,@pearson); %% Store the stability value (using Pearson's correlation coefficient) for the given regularizing parameter \lambda
    hat_pf(i,:)= mean(AA,1); %% frequencies of selection of each feature for the given regularizing parameter
end
av_logloss=mean(logloss,2); %%% The mean negative log-likelihood for each regularizing parameter \lambda over the 
av_error=mean(error,2); %%% Give the mean error (over the M OOB samples) for each lambda 


end

