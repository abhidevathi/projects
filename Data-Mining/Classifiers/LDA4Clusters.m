function [Q,vals] = LDA4Clusters(X,I)
mu = 10^-10;


[~,p] = size(X);
c = 1/p*sum(X,2);

I1 = I == 1; X1 = X(:,I1); [~,p1] = size(X1); c1 = 1/(p1)*sum(X1,2);
I2 = I == 2; X2 = X(:,I2); [~,p2] = size(X2); c2 = 1/(p2)*sum(X2,2);
I3 = I == 3; X3 = X(:,I3); [~,p3] = size(X3); c3 = 1/(p3)*sum(X3,2);
I4 = I == 4; X4 = X(:,I4); [~,p4] = size(X4); c4 = 1/(p4)*sum(X4,2);

X1c = X1 - repmat(c1,1,p1); X2c = X2 - repmat(c2,1,p2);
X3c = X3 - repmat(c3,1,p3); X4c = X4 - repmat(c4,1,p4);

Xw = [X1c X2c X3c X4c];


Sw = Xw*Xw';
Sw = Sw + mu*eye(size(Sw));
Sb = p1*(c1-c)*(c1-c)' + p2*(c2-c)*(c2-c)' + ...
     p3*(c3-c)*(c3-c)' + p4*(c4-c)*(c4-c)';
 Sb = Sb + mu*eye(size(Sb));
A = Sw\Sb;
[Q,vals] = eigs(A,3,'LM');

end