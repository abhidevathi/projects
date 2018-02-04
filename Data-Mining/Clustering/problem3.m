%%Load Congress Votes Data
tic;
load('CongressionalVote.mat')
%% Distance Matrix of Congressmen
[~,p] = size(X);
D = zeros(p,p);
for i = 1:p
    for j = 1:p
        xi = X(:,i); xj = X(:,j);
        n_yesno = sum(xi == 1 & xj == -1);
        n_noyes = sum(xi == -1 & xj == 1);
        n_nono = sum(xi == -1 & xj == 1);
        n_yesyes = sum(xi == 1 & xj == 1);
        dij = (n_yesno + n_noyes)/(n_yesno + n_noyes + n_yesyes + n_nono);
        D(i,j) = dij;
    end
end

%% Identify percent of congressmen that vote along party lines
n = 10;
ratio_correct = zeros(1,n);
for i = 1:n
    [medoids, guessed] = kmedoids(D,2,10);
    guessed = guessed - 1;
    match = sum(guessed == I);

    ratio_correct(i) = match/length(I);
%     if (ratio_correct(i) < 0.5)
%         guessed = 1 - guessed;
%         match = sum(guessed == I);
%     end
    %ratio_correct(i) = match/length(I);
end

figure(1)
plot(1:n,ratio_correct,'-r')
xlabel('nth iteration'); ylabel('Ratio Correctly Clustered');
title('Percent Correctly Identified Clusters');
axis([1 n 0 1]);
toc