load('HandWrittenDigits.mat')
data = X;
indices = I;
X = [X(:,I==0) X(:,I==6) X(:,I==9)];
I = [I(I==0) I(I==6) I(I==9)];
clusts = 3;
mu = 10^-3; %epsilon to keep matrices invertible
[n,p] = size(X);
c = 1/p*sum(X,2); %global centroid
Xc = X-repmat(c,1,p); %centered data, repmat repeats a matrix
Xw = []; %pre-allocating
S = zeros(n,n);

for i = 1:clusts
   X_{i} = X(:,I==i);
   [~,b] = size(X_{i});
   c_{i} = 1/(b)*sum(X_{i},2);
   Xc_{i} = X_{i} - repmat(c_{i},1,b);
   for j = 1:b
       S = S + (X_{i}(:,j)-c_{i})*(X_{i}(:,j)-c_{i})';
   end
   Xw = [Xw Xc_{i}]; 
end

Sw = Xw*Xw';
Sw = Sw + mu*eye(size(Sw));
Sb = zeros(n,n);

for i = 1:clusts
    [~,b] = size(X_{i});
    Sb = Sb + b*(c_{i}-c)*(c_{i}-c)';
end
%Sb = Sb + mu*eye(size(Sb));
%Sbchol = chol(Sb);
Sw_inv = Sw\eye(n,n);
[U,D,V] = svd(Sb);
D2 = diag(sqrt(D(1,1)),sqrt(D(2,2)));
Sb_half = U(:,1:2)*D2*U(:,1:2)';
A = Sb_half*Sw_inv*Sb_half;
B = Sw\Sb;
%A = (1/2)*(A + A'); 
[directions,vals] = eigs(A,3);


[directions1,vals1] = eigs(B,3);
%directions = real(directions); vals = real(vals);
