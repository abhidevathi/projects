tic;
clear;
%% Computing WH Factorization for k = 5,10,20;
load('HandWrittenDigits.mat')
k1 = 0; k2 = 4; k3 = 9;
data = [X(:,I==k1) X(:,I==k2)];
ind = [I(I==k1) I(I==k2)];
[n,p] = size(data);
tol = 10^-3; %Tolerance for relative difference in ANLS Algorithm

[W5_k1,H5_k1,norms5_k1] = MULT_UPT(data(:,ind==k1),5,tol);     X5_k1 = W5_k1*H5_k1;
[W10_k1,H10_k1,norms10_k1] = MULT_UPT(data(:,ind==k1),10,tol); X10_k1 = W10_k1*H10_k1;
[W20_k1,H20_k1,norms20_k1] = MULT_UPT(data(:,ind==k1),20,tol); X20_k1 = W20_k1*H20_k1;

[W5_k2,H5_k2,norms5_k2] = MULT_UPT(data(:,ind==k2),5,tol);     X5_k2 = W5_k2*H5_k2;
[W10_k2,H10_k2,norms10_k2] = MULT_UPT(data(:,ind==k2),10,tol); X10_k2 = W10_k2*H10_k2;
[W20_k2,H20_k2,norms20_k2] = MULT_UPT(data(:,ind==k2),20,tol); X20_k2 = W20_k2*H20_k2;
%% Computing SVD to plot feature vectors for each Factorization
[U5_k1,D5_k1,~] = svd(X5_k1);
Z5 = U5_k1(:,1:5)'*D5_k1;

[U10_k1,D10_k1,~] = svd(X10_k1);
Z10 = U10_k1(:,1:5)'*D10_k1;

[U20_k1,D20_k1,~] = svd(X20_k1);
Z20 = U20_k1(:,1:5)'*D20_k1; 

[U5_k2,D5_k2,~] = svd(X5_k2);
[U10_k2,D10_k2,~] = svd(X10_k2);
[U20_k2,D20_k2,~] = svd(X20_k2);
%% Plotting Feature Vectors
% Too bad that this is hardcoded. :P
for j = 1:2
    if (j == 1)
        figure(j)
        % Each loop plots the feature vectors in the column of the figure
        % The first is U1, then U2...and so on. 
        for ell = 1:5
            subplot(5,3,3*ell-2)
            imagesc(reshape(W5_k1(:,ell),16,16)');
            colormap(gray); axis('square'); axis('off');
        end
        for ell = 1:5
            subplot(5,3,3*ell-1)
            imagesc(reshape(W10_k1(:,ell),16,16)');
            colormap(gray); axis('square'); axis('off');
        end
        for ell = 1:5
            subplot(5,3,3*ell)
            imagesc(reshape(W20_k1(:,ell),16,16)');
            colormap(gray); axis('square'); axis('off');
        end
    end
    if (j==2)
        figure(j)
        for ell = 1:5
            subplot(5,3,3*ell-2)
            imagesc(reshape(W5_k2(:,ell),16,16)');
            colormap(gray); axis('square'); axis('off');
        end
        for ell = 1:5
            subplot(5,3,3*ell-1)
            imagesc(reshape(W10_k2(:,ell),16,16)');
            colormap(gray); axis('square'); axis('off');
        end
        for ell = 1:5
            subplot(5,3,3*ell)
            imagesc(reshape(W20_k2(:,ell),16,16)');
            colormap(gray); axis('square'); axis('off');
        end
    end
end

A = W5_k2(:,5)*H5_k2(5,:);
%% Template for plotting Handwritten Digits Data
% for k = 1:10
%     I_k = find(I == k-1);
%     X_k = X(:,I_k);
%     % PCA
%     [U,D,V] = svd(X_k);
%     for ell = 1:5
%         subplot(5,10,(ell-1)*10 + k)
%         imagesc(reshape(U(:,ell),16,16)')
%         colormap(gray);
%         axis('square')
%         axis('off')
%     end
% end
%% Plotting Residuals
figure(3)
semilogy(norms5_k1, 'r-')
hold on
semilogy(norms10_k1, 'b-')
semilogy(norms20_k1, 'g-')
hold off
xlabel('t-th iteration'); ylabel('log(residual)');
legend('k = 5', 'k = 10', 'k = 20')
title('Residuals for Digit k1 = 0')
axis([1 600 tol tol*10^5])

figure(4)
semilogy(norms5_k2, 'r-')
hold on
semilogy(norms10_k2, 'b-')
semilogy(norms20_k2, 'g-')
hold off
xlabel('t-th iteration'); ylabel('log(residual)');
legend('k = 5', 'k = 10', 'k = 20')
title('Residuals for Digit k2 = 4')
axis([1 600 tol tol*10^5])
toc