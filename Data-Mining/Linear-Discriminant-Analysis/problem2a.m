clear
%% Data Loading and Setting
load('HandWrittenDigits.mat')
[n,p] = size(X);
k1 = 0; k2 = 4; k3 = 7;
k1_label = num2str(k1);
k2_label = num2str(k2);
k3_label = num2str(k3);
data = [X(:,I==k1) X(:,I==k2)];% X(:,I==k3)];
indices = [I(I==k1) I(I==k2)];% I(I==k3)];
mu = 10^-8;
%% PCA of Handwritten Digits
data_c = 1/(length(indices))*(sum(data(:,:),2));
data_C = data - data_c*ones(1,(length(indices)));

[U,D,V] = svd(data_C);
Z = U(:,1:3)'*data_C;
%% Performing LDA
I_k1 = find(indices==k1);
X_k1 = data(:,I_k1);
I_k2= find(indices==k2);
X_k2 = data(:,I_k2);
I_k3 = find(indices==k3);
X_k3 = data(:,I_k3);

c = 1/length(indices)*sum(data,2);
c_k1 = 1/length(I_k1)*sum(X_k1,2);
c_k2 = 1/length(I_k2)*sum(X_k2,2);
c_k3 = 1/length(I_k3)*sum(X_k3,2);

X_k1_c = X_k1 - repmat(c_k1,1,length(I_k1));
X_k2_c = X_k2 - repmat(c_k2,1,length(I_k2));
X_k3_c = X_k3 - repmat(c_k3,1,length(I_k3));

Xw = [X_k1_c X_k2_c];% X_k3_c];
Sw = Xw*Xw';
Sw = Sw + mu*eye(n);
Sb = length(I_k1)*(c_k1-c)*(c_k1-c)' + length(I_k2)*(c_k2-c)*(c_k2-c)';% + ...
    %length(I_k3)*(c_k3-c)*(c_k3-c)';
Sw_inv = Sw\eye(n);
A = Sw_inv*Sb;
[directions,vals] = eig(A);
directions = real(directions); vals = real(vals);
%% Plotting First Two Principal Components of Data

figure(1)
plot(Z(1,indices == k1),Z(2, indices == k1),...
    'r.','MarkerSize',15); 
hold on
plot(Z(1,indices == k2),Z(2, indices == k2),...
    'b*','MarkerSize',15); 
%plot(Z(1,indices == k3),Z(2, indices == k3), 'g.','MarkerSize',15); 
hold off
xlabel('First Principal Component'); ylabel('Second Principal Component');
title('Principal Components of handwritten digits 0 and 4');
legend(k1_label,k2_label)%, k3_label)

%% Plotting of the Data
Xdata = vals*directions'*data; %%Transform from data space to eigenspace
figure(2)
plot(Xdata(1,indices == k1),Xdata(2, indices == k1),...
    'r.','MarkerSize',15); 
hold on
plot(Xdata(1,indices == k2),Xdata(2,indices == k2),...
    'b*','MarkerSize',15);
%plot(Xdata(1,indices == k3),Xdata(2,indices == k3), 'g.','MarkerSize',15);
hold off
title('First LDA Directions of handwritten digits 0 and 4');
xlabel('First LDA Direction'); ylabel('Second LDA Direction')
legend(k1_label,k2_label)%, k3_label)