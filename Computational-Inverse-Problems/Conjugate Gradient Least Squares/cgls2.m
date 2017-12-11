function sol = cgls2(A,b,noise)

[~,n] = size(A);

x = zeros(n,1);
d(:,1) = b;
p(:,1) = A'*d(:,1);
k = 1;
r(:,1) = p(:,1);

while norm(d(:,k)) > noise && k < n
    
    dir = A*p(:,k);
    alpha(k) = norm(r(:,k))^2/norm(dir)^2;
    x(:,k+1) = x(:,k) + alpha(k)*p(:,k);
    d(:,k+1) = d(:,k) - alpha(k)*dir;
    r(:,k+1) = A'*d(:,k+1);
    beta(k) = norm(r(:,k+1))^2/norm(r(:,k))^2;
    p(:,k+1) = r(:,k+1) + beta(k)*p(:,k);
    k = k + 1;
    
end
sol = x(:,k);

end