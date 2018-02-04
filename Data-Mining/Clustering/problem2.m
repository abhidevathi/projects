%% Load Data and Index Vectors
tic;
load('BiopsyDataAnnotated.mat');

%% Do k-Medoids for k = 2 (malignant and benign)

data = X;
correct = I;
K = 2;
tol = 100;
n = 10;
ns = num2str(n);
sensitivities = zeros(1,n);
specificities = zeros(1,n);
for i = 1:n
    [medoids,guessed] = kmedoids(data, K, tol);
    guessed = guessed - ones(1,length(guessed));
    match = sum(guessed == correct);
    if (match < length(I)/2)
        guessed = ones(1,length(guessed)) - guessed;
        match = sum(guessed == correct);
    end

    benign_index = find(I==0); benign_correct = I(benign_index);
    benign_guessed = guessed(benign_index);
    malign_index = find(I==1); malign_correct = I(malign_index);
    malign_guessed = guessed(malign_index);

    sensitivities(i) = sum(malign_guessed == malign_correct)/length(malign_index);
    specificities(i) = sum(benign_guessed == benign_correct)/length(benign_index);
end
%% Plot the sensitivities and specificities
sensitivities = [sensitivities mean(sensitivities)];
specificities = [specificities mean(specificities)];
figure(1)
subplot(2,1,1)
bar(1:n+1, sensitivities, 'r')
title(strcat('Sensitivities for', ' ', ns, ' random k-medoids'))
xlabel('nth iteration of k-medoids')
ylabel('Sensitivity')
subplot(2,1,2)
bar(1:n+1, specificities, 'b')
title(strcat('Specificities for', ' ', ns, ' random k-medoids'))
xlabel('nth iteration of k-medoids')
ylabel('Specificity')