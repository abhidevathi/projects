%% k-nearest algorithm
%  works only for HandWrittenDigits.mat
function success = knearest(Xtest,Itest,k)
load('HandWrittenDigits.mat')
X0 = X; I0 = I;

[~,p0] = size(X0);
[~,p] = size(Xtest);
dists = zeros(1,p0);
tags = zeros(1,p);
for i = 1:p
    for j = 1:p0
        dists(j) = distance(X0(:,j),Xtest(:,i));
    end
    [~,index] = sort(dists);
    index = index(1:k);
    firstk = I0(index);
    tags(i) = mode(firstk);
end

success = sum(tags == Itest)/length(Itest);
end