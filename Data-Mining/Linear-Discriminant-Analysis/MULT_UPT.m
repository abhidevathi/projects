function [W_new, H_new, nors] = MULT_UPT(X,k,tol)

[n,p] = size(X);
W_new = rand(n,k); H_new = 2*ones(k,p);
MAX_ITER = 1000;
nors = zeros(1,MAX_ITER);
eps = 10^-12;

t = 0;
nor = norm(X - W_new*H_new, 'fro');
L = eye(k);

while(nor > tol && t < MAX_ITER)
    W_old = W_new; H_old = H_new;
    Xc = W_old*H_old;
    
    temp1 = W_old'*X; temp2 = W_old'*Xc;
    for i = 1:k
        for j = 1:p
            H_new(i,j) = (temp1(i,j))/(temp2(i,j)+eps)*H_old(i,j);
        end
    end
    clear temp1; clear temp2;
    Xc = W_old*H_new;
    temp1 = X*H_new'; temp2 = Xc*H_new';
    for i = 1:n
        for j = 1:k
            W_new(i,j) = temp1(i,j)/(temp2(i,j)+eps)*W_old(i,j);
        end
    end
    
    for l = 1:k
        L(l,l) = norm(W_new,Inf);
    end
    W_new = W_new/L;
    t = t+1;
    nor = norm(W_new - W_old,'fro')/norm(W_old,'fro') + ...
        norm(H_new - H_old,'fro')/norm(H_old,'fro');
    %nor = entropy(X, W_new*H_new);
    nors(t) = nor;
end

end