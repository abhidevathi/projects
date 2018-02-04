load('HandwrittenDigits.mat')

k1 = 0; k2 = 1; k3 = 3; k4 = 7;

nums = [k1 k2 k3 k4];

I1 = I == k1;
X_1 = X(:,I1);
[U,~,~] = svd(X_1);
residuals = zeros(5,5);
figure(1)
for i = 1:5
    Uk = U(:,1:5*i); Zk = Uk'*X;
    
    for j = 1:5
        x_j = 0;
        for k = 1:(5*i)
            x_j = x_j+Z(k,j)*U(:,k);
        end
        subplot(5,5,(i-1)*5 + j)
        imagesc(reshape(x_j,16,16)')
        colormap(gray);
        axis('square')
        axis('off');
        residuals(i,j) = norm(X_1(:,j) - x_j);
    end
end 
print -depsc digits_0.eps

figure(2)
I1 = find(I == k2);
X_1 = X(:,I1);
[U,D,V] = svd(X_1);
residuals = zeros(5,5);

for i = 1:5
    Ur = U; Dr = D(1:5*i,1:5*i); Vr = V(1:5*i,:);
    Z = Dr*Vr;
    for j = 1:5
        x_j = 0;
        for k = 1:(5*i)
            x_j = x_j+Z(k,j)*U(:,k);
        end
        subplot(5,5,(i-1)*5 + j)
        imagesc(reshape(x_j,16,16)')
        colormap(gray);
        axis('square')
        axis('off');
        residuals(i,j) = norm(X_i(:,j) - x_j);
    end
end 

figure(3)
I_i = I == k3;
X_i = X(:,I_i);
[U,D,V] = svd(X_i);
residuals = zeros(5,5);

for i = 1:5
    Ur = U; Dr = D(1:5*i,1:5*i); Vr = V(1:5*i,:);
    Z = Dr*Vr;
    for j = 1:5
        x_j = 0;
        for k = 1:(5*i)
            x_j = x_j+Z(k,j)*U(:,k);
        end
        subplot(5,5,(i-1)*5 + j)
        imagesc(reshape(x_j,16,16)')
        colormap(gray);
        axis('square')
        axis('off');
        residuals(i,j) = norm(X_i(:,j) - x_j);
    end
end 

figure(4)
I_i = find(I == k4);
X_i = X(:,I_i);
[U,D,V] = svd(X_i);
residuals = zeros(5,5);

for i = 1:5
    Ur = U; Dr = D(1:5*i,1:5*i); Vr = V(1:5*i,:);
    Z = Dr*Vr;
    for j = 1:5
        x_j = 0;
        for k = 1:(5*i)
            x_j = x_j + Z(k,j)*U(:,k);
        end
        subplot(5,5,(i-1)*5 + j)
        imagesc(reshape(x_j,16,16)')
        colormap(gray);
        axis('square')
        axis('off');
        residuals(i,j) = norm(X_i(:,j) - x_j);
    end
end 

figure(5)
ks = 5:5:25;
plot(ks,residuals(:,1));
hold on
plot(ks,residuals(:,2));
plot(ks,residuals(:,3));
plot(ks,residuals(:,4));
plot(ks,residuals(:,5));
hold off

