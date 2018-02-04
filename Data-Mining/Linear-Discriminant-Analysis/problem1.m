tic;
%% Load Data
load('WineData.mat')

%% Plot Principal Components of Original Data
[n,p] = size(X);
c = 1/p*(sum(X,2));
Xc = X - repmat(c,1,p);
[U,D,V] = svd(Xc);
Z = U(:,1:3)'*Xc;
figure(1)
plot(Z(1,I==1),Z(2,I==1),'r.','MarkerSize',15)
hold on
plot(Z(1,I==2),Z(2,I==2),'b.','MarkerSize',15)
plot(Z(1,I==3),Z(2,I==3),'g.','MarkerSize',15)
hold off
title('First Two Principal Components of WineData');
xlabel('First Component'); ylabel('Second Component');
legend('Cultivar 1','Cultivar 2','Cultivar 3');
%axis([10 50 -1 4])
%% LDA projections

[Xw, directions,vals] = LDA(X,I,3);
Xlda = vals*directions'*X;

figure(2)
plot(Xlda(1,I==1),Xlda(2,I==1),'r.','MarkerSize',15)
hold on
plot(Xlda(1,I==2),Xlda(2,I==2),'b.','MarkerSize',15)
plot(Xlda(1,I==3),Xlda(2,I==3),'g.','MarkerSize',15)
hold off
title('LDA Directions 1 and 2')
xlabel('Direction 1'); ylabel('Direction 2');
legend('Cultivar 1','Cultivar 2','Cultivar 3');

figure(3)
subplot(1,2,1)
plot(Xlda(1,I==1),Xlda(3,I==1),'r.','MarkerSize',15)
hold on
plot(Xlda(1,I==2),Xlda(3,I==2),'b.','MarkerSize',15)
plot(Xlda(1,I==3),Xlda(3,I==3),'g.','MarkerSize',15)
hold off
title('LDA Directions 1 and 3')
xlabel('Direction 1'); ylabel('Direction 3')
legend('Cultivar 1','Cultivar 2','Cultivar 3');

subplot(1,2,2)
plot(Xlda(2,I==1),Xlda(3,I==1),'r.','MarkerSize',15)
hold on
plot(Xlda(2,I==2),Xlda(3,I==2),'b.','MarkerSize',15)
plot(Xlda(2,I==3),Xlda(3,I==3),'g.','MarkerSize',15)
hold off
title('LDA Directions 2 and 3')
xlabel('Direction 2'); ylabel('Direction 3')
legend('Cultivar 1','Cultivar 2','Cultivar 3');
%axis([10 50 -1 4])
toc