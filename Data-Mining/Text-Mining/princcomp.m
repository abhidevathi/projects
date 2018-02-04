function Z = princcomp(A,bool)
[~,p] = size(A);
if bool == 'centered'
    c = 1/p*sum(A,2);
    A = A - repmat(c,1,p);
end
[U,~,~] = svd(A);
Z = U'*A;
end