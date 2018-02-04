tic;
%% Computing WH Factorization for k = 5,10,20;
load('HandWrittenDigits.mat')
k1 = 0; k2 = 4;

data = [X(:,I==k1) X(:,I==k2)];% X(:,I==9)];
ind = [I(I==k1) I(I==k2)];% I(I==9)];
[n,p] = size(data);
tol = 0.01; %Tolerance for relative difference in ANLS Algorithm
[W5_k1k2,H5_k1k2,norms5_k1k2] = ANLS(data,5,tol);     X5_k1k2 = W5_k1k2*H5_k1k2;
[W10_k1k2,H10_k1k2,norms10_k1k2] = ANLS(data,10,tol); X10_k1k2 = W10_k1k2*H10_k1k2;
[W20_k1k2,H20_k1k2,norms20_k1k2] = ANLS(data,20,tol); X20_k1k2 = W20_k1k2*H20_k1k2;
%% Computing SVD to plot feature vectors for each Factorization
[U5_k1k2,D5_k1k2,~] = svd(X5_k1k2);
Z5 = U5_k1k2(:,1:5)'*D5_k1k2;

[U10_k1k2,D10_k1k2,~] = svd(X10_k1k2);
Z10 = U10_k1k2(:,1:5)'*D10_k1k2;

[U20_k1k2,D20_k1k2,~] = svd(X20_k1k2);
Z20 = U20_k1k2(:,1:5)'*D20_k1k2; 

%% Plotting Feature Vectors
figure(1)
for ell = 1:5
    subplot(5,3,3*ell-2)
    imagesc(reshape(W5_k1k2(:,ell),16,16)');
    colormap(gray); axis('square'); axis('off');

    subplot(5,3,3*ell-1)
    imagesc(reshape(W10_k1k2(:,ell),16,16)');
    colormap(gray); axis('square'); axis('off');
    
    subplot(5,3,3*ell)
    imagesc(reshape(W20_k1k2(:,ell),16,16)');
    colormap(gray); axis('square'); axis('off');
end
%% Plotting Residuals
figure(2)
semilogy(1:10,norms5_k1k2, 'r-')
hold on
semilogy(1:10,norms10_k1k2, 'b-')
semilogy(1:10,norms20_k1k2, 'g-')
hold off
xlabel('t-th iteration'); ylabel('log(residual)');
legend('k = 5', 'k = 10', 'k = 20')
title('Residuals for Digits 0 and 4')

%% Extracting Feature Vectors
sample = W5_k1k2(:,1);
coeff = H5_k1k2(:,1);
othercoeff = H5_k1k2(:,2);
lincomb = zeros(size(sample));
otherlincomb = zeros(size(sample));
for i = 1:length(coeff)
    lincomb = lincomb + coeff(i)*sample;
    otherlincomb = otherlincomb + othercoeff(i)*sample;
end
diff = norm(X5_k1k2(:,1) - lincomb,2);
otherdiff = norm(X5_k1k2(:,1) - otherlincomb,2);
toc