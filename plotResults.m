function [] = plotResults(av_error,av_logloss,lambdas,stabilities,hat_pf)
% PLOTS THE FIGURES AS IN THE PAPER

close all; %% Closes all figures opened in Matlab first

%%%% FIGURE 5

%%%% PLOT Negative log-likelihood against lambda
figure();
hold on
xlabel('\lambda','FontSize', 20);
ylabel('Negative log-likelihood','FontSize', 20);
title('OOB Negative log-likelihood vs \lambda','FontSize', 15);
plot(lambdas,av_logloss,'b-x','markersize',15,'markerFace','blue','LineWidth',2);
set(gca,'fontsize',20);

%%%% Now stability against lambda
figure();
hold on
xlabel('\lambda','FontSize', 20);
ylabel('Stability','FontSize', 20);
title('Stability vs \lambda','FontSize', 20);
plot(lambdas,stabilities,'b-x','markersize',15,'markerFace','blue','LineWidth',2);
set(gca,'fontsize',20);


%%% FIGURE 6

%%%% PLOTTING STABILITY AGAINST the negative log-likelihood
%%%% OR MSE (when target variable is categorical)
figure();
xlabel('Negative log-likelihood','FontSize', 20);
ylabel('Stability','FontSize', 20);
title('Stability vs OOB Negative log-likelihood','FontSize',15);
hold on;
plot(av_logloss,stabilities,'b-x','markersize',15,'markerFace','blue','LineWidth',2);
set(gca,'fontsize',20);
hold off;
%%%% PLOTTING THE PARETO FRONT OF THE PREVIOUS PLOT
[paretoIndices,logloss_pareto,stability_pareto]=getPareto(av_logloss,stabilities);
figure(); %% now only plotting the pareto front of those
hold on;
xlabel('Negative log-likelihood','FontSize', 20);
ylabel('Stability','FontSize', 20);
title('Pareto Front: Stability vs OOB Negative log-likelihood','FontSize', 15);
plot(logloss_pareto,stability_pareto,'b-x','markersize',15,'markerFace','blue','LineWidth',2);
set(gca,'fontsize',20);
hold off;


%%% TO Print the set of optimal values of lambda along with their corresponding logloss and stability
paretoIndices
disp('---- OPTIMAL LAMBDAS')
lambdas(paretoIndices)
disp('---- OPTIMAL LOG LOSS')
logloss_pareto'
disp('---- OPTIMAL STABILITY')
stability_pareto


%%%%%%%% FIGURE 7
%%%%%%%% TO PLOT THE PROBABILITIES OF SELECTION for lambdas(point)

%% UNCOMMENT THIS AND FIRST PICK UP THE VALUE OF THE VARIABLE 'POINT' you want to make the plot for

% point=60; %%% CHANGE THE VALUE HERE DEPENDING ON the value of \lambda you want to plot it for 
% if point>length(lambdas)
%     error('plotResults function: the variable point must be set less or equal to the number of lambda value ');
% end
% figure();
% hold on;
% x1=50.5;
% y1=get(gca,'ylim');
% set(gca,'fontsize',20)
% plot([x1 x1],y1,'r','LineWidth', 2); %%% draws the vertical red line
% l=length(hat_pf(point,:));
% plot(1:l,hat_pf(point,:),'bo','markersize',7,'markerFace','blue');
% ylabel('$$\hat{p}_f$$','Interpreter','Latex')
% xlabel('Feature f');
% set(gca,'OuterPosition',[+0.01 0 1 1]);


end

