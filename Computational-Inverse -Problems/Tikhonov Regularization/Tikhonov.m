function [x,g_alpha] = Tikhonov(A,b,alpha)


[U,D,V] = svd(A);
d = diag(D);
r = sum(d > 1e-9);
[~,n] = size(A);
x = zeros(n,1);
for j = 1:r
    x = x + d(j)/(d(j)^2 + alpha)*(U(:,j)'*b)*V(:,j);
end

g_alpha = norm(A*x - b)^2;

end