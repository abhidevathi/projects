tic;
%% Loading the Data, Pre-Allocation of Variables
load('HandWrittenDigits.mat')
Xtrain = X; Itrain = I;
[ntrain, ptrain] = size(Xtrain);
load('HandWrittenDigitsTestset.mat')
Xtest = X; Itest = I;
[ntest, ptest] = size(Xtest);
ks = 1:30; %k varies from 1 to 30, as requested in the assignment
successes_trn = zeros(size(ks));
successes_test = zeros(size(ks));
%% Distance Matrix
dists = zeros(ptrain,ptest);
for i = 1:ptrain
    for j = 1:ptest
        dists(i,j) = distance(Xtrain(:,i),Xtest(:,j));
    end
end

%% Success Rates


%% Run the knearest algorithm for both the training data and the test data
for i = 1:length(ks) 
    successes_trn(i) = knearest(Xtrain,Itrain,ks(i)); %success rate on training data
    successes_test(i) = knearest(Xtest,Itest,ks(i));  %success rate on test data
end

%% Plotting the Data
figure(1)
hold on
plot(ks, successes_trn, 'r*-','MarkerSize',15)
plot(ks, successes_test,'b*-','MarkerSize',15)
hold off
title('Success Rate of k-nearest neighbors Algorithm')
xlabel('Number of Neighbors k'); ylabel('Success Rate for given k')
legend('Training Set', 'Test Set')

toc