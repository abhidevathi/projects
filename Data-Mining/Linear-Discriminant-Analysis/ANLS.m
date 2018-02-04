function [W_new,H_new,nors] = ANLS(X,k, tol)
[n,p] = size(X);
W_new = rand(n,k); H_new = zeros(k,p);
MAX_ITER = 10;
nors = zeros(1,MAX_ITER);
t = 0;
nor = norm(X - W_new*H_new, 'fro');
L = eye(k);

while(nor > tol && t < MAX_ITER)
    H_old = H_new;
    W_old = W_new;
    for j = 1:p
        H_new(:,j) = lsqnonneg(W_old,X(:,j));
    end
    
    for l = 1:n
        W_new(l,:) = (lsqnonneg(H_new',X(l,:)'))';
    end
    
    for l = 1:k
        L(l,l) = norm(W_new(:,l),Inf);
    end
    W_new = W_new/L;
    H_new = L*H_new;
    %nor = norm(X - W_new*H_new, 'fro');
    nor = norm(W_new - W_old,'fro')/norm(W_old,'fro') + ...
        norm(H_new - H_old,'fro')/norm(H_old,'fro');
    nors(t+1) = nor;
    t = t+1;
end
end