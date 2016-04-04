function [] = main(rho)
%MAIN Summary of this function goes here
%   Detailed explanation goes here

%%% Parameters to generate the dataset - default values are set to the same
%%% ones as in the paper
d=100; % total number of features
d_rel=50; % number of relevant features
num_instances=2000; % number of instances desired 
num_lambdas=100;

M=100;  % number of bootstrap samples to use to estimate stability

%% We generate the dataset using the parameters given above
[data,labels,trueRelevantSet] = generateDataset(num_instances,d,d_rel,rho); %% the variable trueRelevantSet is a binary vector with the set of true relevant features
labels(labels==-1)=0; %% make the labels 0 and 1 so that it can be used with the lassoglm function...

%%% We run the experiments presented in the paper
[error,av_error,logloss,av_logloss,num_lambdas,lambdas,stabilities,hat_pf,A,featureSet]=experiment(data,labels,M,num_lambdas);
%%% to plot the figures in the paper
plotResults(av_error,av_logloss,lambdas,stabilities,hat_pf);

end

