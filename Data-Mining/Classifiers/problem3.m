%% Loading the Data
tic;
load('ForestSpectra.mat')
I = Itype;
%% 3a: Finding the first 3 LDA Directions and Plotting
[Q,vals] = LDA4Clusters(X,I);
Z = vals'*Q'*X;
figure(1)
plot(Z(1,I==1),Z(2,I==1), 'r.', 'MarkerSize',15);
hold on
plot(Z(1,I==2),Z(2,I==2), 'b*', 'MarkerSize',7);
plot(Z(1,I==3),Z(2,I==3), 'gs', 'MarkerSize',10);
plot(Z(1,I==4),Z(2,I==4), 'k.', 'MarkerSize',15);
hold off

title('First Two LDA Directions')
xlabel('First LDA Direction'); ylabel('Second LDA Direction');
legend('Birch','Fir','Pine','Shrub')

%% Classification
clear X I
load('ForestSpectraTest.mat')
[n,p] = size(X);
I = Itype; clear Itype
Z = vals*Q'*X;
Z1 = Z(:,I==1); [~,p1] = size(Z1); c1 = 1/p1*sum(Z1,2);
Z2 = Z(:,I==2); [~,p2] = size(Z2); c2 = 1/p2*sum(Z2,2);
Z3 = Z(:,I==3); [~,p3] = size(Z3); c3 = 1/p3*sum(Z3,2);
Z4 = Z(:,I==4); [~,p4] = size(Z4); c4 = 1/p4*sum(Z4,2);

norms = zeros(1,4);
tags = zeros(size(I)); % Classification of each data point.
for i = 1:p
    norms(1) = abs(1 - dot(Z(:,i),c1)/(norm(Z(:,i))*norm(c1)));
    norms(2) = abs(1 - dot(Z(:,i),c2)/(norm(Z(:,i))*norm(c2)));
    norms(3) = abs(1 - dot(Z(:,i),c3)/(norm(Z(:,i))*norm(c3)));
    norms(4) = abs(1 - dot(Z(:,i),c4)/(norm(Z(:,i))*norm(c4)));
    
    [~,class] = min(norms);
    tags(i) = class;
end

ratio_correct = sum(tags == I)/length(I);

toc
