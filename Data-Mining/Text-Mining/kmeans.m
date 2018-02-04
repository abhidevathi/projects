%Abhi Devathi
%dxd310
%k - means algorithm
function[centers, indices] = kmeans(X, K, MAX_ITER)
centers = X(:,ceil(rand(K,1)*size(X,2)));
DAL = zeros(K+2,size(X,2));

iter = 0;
while(iter < MAX_ITER)
    for i = 1:size(X,2)
        for j = 1:K
            DAL(j,i) = norm(X(:,i) - centers(:,j),2);
        end
        [Dist, clust] = min(DAL(1:K,i));
        DAL(K+1,i) = clust;
        DAL(K+2,i) = Dist;
    end
    
    for i = 1:K
        A = DAL(K+1,:) == i;
        centers(:,i) = mean(X(:,A),2);
    end
    iter = iter + 1;
end
indices = DAL(K+1,:);
end