function [Xw, directions,vals] = LDA(X,I,clusts)
mu = 10^-12; %epsilon to keep matrices invertible
[n,p] = size(X);
c = 1/p*sum(X,2); %global centroid
%Xc = X-repmat(c,1,p); %centered data, repmat repeats a matrix
Xw = []; %pre-allocating

for i = 1:clusts
   X_{i} = X(:,I==i);
   [~,b] = size(X_{i});
   c_{i} = 1/(b)*sum(X_{i},2);
   Xc_{i} = X_{i} - repmat(c_{i},1,b);
   Xw = [Xw Xc_{i}]; 
end

Sw = Xw*Xw';
Sw = Sw + mu*eye(size(Sw));
Sb = zeros(n,n);

for i = 1:clusts
    [~,b] = size(X_{i});
    Sb = Sb + b*(c_{i}-c)*(c_{i}-c)';
end
Sb = Sb + mu*eye(size(Sb));
A = Sw\Sb;
[directions,vals] = eigs(A,3,'LM');
%directions = real(directions); vals = real(vals);
end