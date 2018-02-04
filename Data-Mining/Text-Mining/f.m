%load('TDM_vary_k.mat');
%X=X{3};
X = A;
k = 6;
t = 0.001;

[medoids, I]=kmedoids(X, k, t);
return

cos=zeros(763,6);
for i=1:6
    for j=1:763
        num=X(:,j)'*X(:,I(i));
        denom=norm(X(:,j), 2)*norm(X(:,I(i)),2);
        cos(j,i)=num/denom;
    end
end

figure(1)
for i=1:6
    subplot(2,3,i);
    ind=1:6;
    ind=ind(ind~=i);
    plot(medoids{i},cos(medoids{i}, i),'r.','MarkerSize',20);
    hold on
    plot(medoids{ind(1)}, cos(medoids{ind(1)},i), 'k.', 'MarkerSize', 20);
    hold on
    plot(medoids{ind(2)}, cos(medoids{ind(2)},i), 'k.', 'MarkerSize', 20);
    hold on
    plot(medoids{ind(3)}, cos(medoids{ind(3)},i), 'k.', 'MarkerSize', 20);
    hold on
    plot(medoids{ind(4)}, cos(medoids{ind(4)},i), 'k.', 'MarkerSize', 20);
    hold on
    plot(medoids{ind(5)}, cos(medoids{ind(5)},i), 'k.', 'MarkerSize', 20);
    hold off
    xlabel('Data vector')
    ylabel('Cosine')
    title(['Cosine of angle between medoid '  num2str(i)  ' and data vectors'])
    legend(['Cluster ' num2str(i)], ['Clusters ' num2str(ind)])
end
