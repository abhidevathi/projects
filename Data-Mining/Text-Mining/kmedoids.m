function [medoids, I_assign] = kmedoids(X,K,tol)
    [~,p] = size(X);
    MAX_ITER = 100;
    I_m = ceil(rand(1,K)*p);
    medoids = X(:,I_m);
    t = 0;
    D = zeros(p,p); %distance matrix from each vector to the other

    for i = 1:p
        for j = 1:p
            D(i,j) = norm(X(:,i)-X(:,j)); %using 1 norm for distance
        end
    end
    %Assignment
    D_m = D(:,I_m);
    [q, I_assign] = min(D_m,[],2);
    Qold = sum(q.^2);
    coh = 10^9;
    while(coh > tol && t < MAX_ITER)
        for l = 1:K
            I_{l} = find(I_assign == l);
            D_{l} = D(I_{l},I_{l});
            [~,j] = min(sum(D_{l}));
            D_m(:,l) = D(:,j);
            I_m(l) = j;
        end

        [qnew, I_assign] = min(D_m,[],2);

        Qnew = sum(qnew.^2);
        coh = abs(Qnew - Qold);
        Qold = Qnew;
        t = t+1;
    end
    medoids = X(:,I_m);
    I_assign = I_assign';
end