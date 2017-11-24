load('TrueTarget.mat')
X = Target; clear Target
[n1, n2] = size(X);
x = X(:);

% Sparse Diagonal Matrix
C1 = [ones(n1,1) -2*ones(n1,1) ones(n1,1);];
L1 = spdiags(C1, [-1 0 1], n1, n1); % Creating a sparse matrix

l2 = zeros(n2,1);
l2(1) = -2; l2(2) = 1;
L2 = toeplitz(l2);
bigL2 = kron(eye(n1),L2);
diff = bigL2*x;