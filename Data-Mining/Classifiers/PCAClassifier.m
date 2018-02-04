%% Only Works for data with 10 Clusters

%% Begin Function
function corrects = PCAClassifier(X,I,ks)
% X = the data
% I = the tags
% ks = the vector of ranks to approximate by
clusters = 10;
I0 = I==0; X0 = X(:,I0);
I1 = I==1; X1 = X(:,I1);
I2 = I==2; X2 = X(:,I2);
I3 = I==3; X3 = X(:,I3);
I4 = I==4; X4 = X(:,I4);
I5 = I==5; X5 = X(:,I5);
I6 = I==6; X6 = X(:,I6);
I7 = I==7; X7 = X(:,I7);
I8 = I==8; X8 = X(:,I8);
I9 = I==9; X9 = X(:,I9);

corrects = zeros(size(ks)); %vector for storing success rates
load('HandWrittenDigits.mat') % Training Set
Itest = zeros(size(I));
iter = 1;
norms = zeros(1,clusters); %vector to store each norm

for i = ks
    [U,~,~] = svds(X0, i); P0 = U*U'; proj0 = P0*X;
    [U,~,~] = svds(X1, i); P1 = U*U'; proj1 = P1*X;
    [U,~,~] = svds(X2, i); P2 = U*U'; proj2 = P2*X;
    [U,~,~] = svds(X3, i); P3 = U*U'; proj3 = P3*X;
    [U,~,~] = svds(X4, i); P4 = U*U'; proj4 = P4*X;
    [U,~,~] = svds(X5, i); P5 = U*U'; proj5 = P5*X;
    [U,~,~] = svds(X6, i); P6 = U*U'; proj6 = P6*X;
    [U,~,~] = svds(X7, i); P7 = U*U'; proj7 = P7*X;
    [U,~,~] = svds(X8, i); P8 = U*U'; proj8 = P8*X;
    [U,~,~] = svds(X9, i); P9 = U*U'; proj9 = P9*X;
    
    for j = 1:length(I) % For each digit sample, find the norm of the difference
                        % of the digit and the projection
        norms(1) = abs(1 - dot(X(:,j),proj0(:,j))/(norm(X(:,j))*norm(proj0(:,j)))); 
        norms(2) = abs(1 - dot(X(:,j),proj1(:,j))/(norm(X(:,j))*norm(proj1(:,j))));
        norms(3) = abs(1 - dot(X(:,j),proj2(:,j))/(norm(X(:,j))*norm(proj2(:,j))));
        norms(4) = abs(1 - dot(X(:,j),proj3(:,j))/(norm(X(:,j))*norm(proj3(:,j))));
        norms(5) = abs(1 - dot(X(:,j),proj4(:,j))/(norm(X(:,j))*norm(proj4(:,j))));
        norms(6) = abs(1 - dot(X(:,j),proj5(:,j))/(norm(X(:,j))*norm(proj5(:,j))));
        norms(7) = abs(1 - dot(X(:,j),proj6(:,j))/(norm(X(:,j))*norm(proj6(:,j))));
        norms(8) = abs(1 - dot(X(:,j),proj7(:,j))/(norm(X(:,j))*norm(proj7(:,j))));
        norms(9) = abs(1 - dot(X(:,j),proj8(:,j))/(norm(X(:,j))*norm(proj8(:,j))));
        norms(10) = abs(1 - dot(X(:,j),proj9(:,j))/(norm(X(:,j))*norm(proj9(:,j))));
        [~,digit] = min(norms);
        Itest(j) = digit - 1; %%to account for variance in digit and index
    end
    percent = sum(Itest == I)/length(I);
    corrects(iter) = percent;
    iter = iter+1;
end

end