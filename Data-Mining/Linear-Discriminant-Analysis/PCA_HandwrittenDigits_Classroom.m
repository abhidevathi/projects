% This is the example of using PCA to analyze the handwritten digits

load HandwrittenDigits X I
% Pick one digit of each type, and plot it as a black and white image
figure(1)
for j = 1:10
    Ij = find(I == j-1);
    for ell = 1:5
       xj = X(:,Ij(ell)); % Take the first one and plot it
       subplot(5,10,(ell-1)*10 + j)
       imagesc(reshape(xj,16,16)')
       colormap(1-gray);
        axis('square')
        axis('off')
    end
end

% Pick one digit and analyze the corresponding data set

k = 1;
I_k = find(I == k);
X_k = X(:,I_k);
% PCA
[U,D,V] = svd(X_k);
d = diag(D);
figure(2)
semilogy(d,'k.','MarkerSize',10)
set(gca,'FontSize',20)

% Plotting the first five feature vectors

figure(4)
for k = 1:10
    I_k = find(I == k-1);
    X_k = X(:,I_k);
    % PCA
    [U,D,V] = svd(X_k);
    for ell = 1:5
        subplot(5,10,(ell-1)*10 + k)
        imagesc(reshape(U(:,ell),16,16)')
        colormap(gray);
        axis('square')
        axis('off')
    end
end
    





