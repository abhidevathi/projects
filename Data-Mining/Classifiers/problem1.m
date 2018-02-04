%% PCA Classification of HandWrittenDigits Data
%  Abhi Devathi, dxd310
%% Loading the Data And Determining Success Rates
tic;
ranks = 5:5:80;
load('HandWrittenDigits.mat')
corrects_og = PCAClassifier(X, I, ranks);
clear X I
load('HandWrittenDigitsTestset.mat')
corrects_test = PCAClassifier(X, I, ranks);
%% Plotting the Success Rates
figure(1)
plot(ranks, corrects_og)
xlabel('Number of Features'); ylabel('Percent Correct');
title('Correctly Identified Digits against rank k decomposition');
hold on
plot(ranks, corrects_test,'r')
hold off
legend('Original Digits', 'Test Digits')
axis([0 80 0.8 1])

toc