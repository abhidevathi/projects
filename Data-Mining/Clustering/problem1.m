%% Generate Points
load('IrisDataAnnotated.mat')
%% K-means option
data_set     = X;                                        % Input
number_of_clusters = 3;                                  % Number of Clusters
Kmeans_iteration   = 100;                                % K-means Iteration
%% Test K-means
[cluster_centers, index]  = kmeans(data_set, number_of_clusters, Kmeans_iteration);
%% Plot Original Data (Figure 1)

Xind = [X; I];
first = find(I==1);
second = find(I==2);
third = find(I==3);

fig = figure(1);
set(fig, 'Units', 'Normalized'); % First change to normalized units.
set(fig, 'OuterPosition', [.1, .1, .65, 1]); % [xLeft, yBottom, width, height]
subplot(3,1,1)
hold on
plot(X(1,first),X(2,first), '+r')
plot(X(1,second),X(2,second), '*b')
plot(X(1,third),X(2,third), 'og')
hold off
legend('Iris setosa','Iris versacolor', 'Iris virginica');
xlabel('1st dimension'); ylabel('2nd dimension');
title('Actual Clusters')
%% Plot k-Means Data (Figure 2)

setosa_index = find(index == 1);
versa_index = find(index == 2);
virgin_index = find(index == 3);

setosa = X(:,setosa_index);
versa = X(:,versa_index);
virgin = X(:,virgin_index);

subplot(3,1,2)
hold on
plot(setosa(1,:), setosa(2,:), 'r+')
plot(versa(1,:), versa(2,:), '*b')
plot(virgin(1,:), virgin(2,:), 'og')
plot(cluster_centers(1,1),cluster_centers(2,1),'*k',...
    'MarkerSize',15)
plot(cluster_centers(1,2),cluster_centers(2,2),'*k',...
    'MarkerSize',15)
plot(cluster_centers(1,3),cluster_centers(2,3),'*k',...
    'MarkerSize',15)
hold off
legend('Iris setosa','Iris versacolor', 'Iris virginica','Centers');
xlabel('1st dimension'); ylabel('2nd dimension');
title('k-means Clustering, k = 3')

%% Plot k-Medoids Data
clear cluster_centers
clear index
tol = 100;
[medoids, index] = kmedoids(data_set, number_of_clusters, 100);
setosa_index = find(index == 1);
versa_index = find(index == 2);
virgin_index = find(index == 3);

setosa = X(:,setosa_index);
versa = X(:,versa_index);
virgin = X(:,virgin_index);

subplot(3,1,3)
hold on
plot(setosa(1,:), setosa(2,:), 'r+')
plot(versa(1,:), versa(2,:), '*b')
plot(virgin(1,:), virgin(2,:), 'og')
plot(medoids(1,1),medoids(2,1),'*k',...
    'MarkerSize',15)
plot(medoids(1,2),medoids(2,2),'*k',...
    'MarkerSize',15)
plot(medoids(1,3),medoids(2,3),'*k',...
    'MarkerSize',15)
hold off
legend('Iris setosa','Iris versacolor', 'Iris virginica','Centers');
xlabel('1st dimension'); ylabel('2nd dimension'); zlabel('4th dimension');
title('k-medoids Clustering, k = 3')