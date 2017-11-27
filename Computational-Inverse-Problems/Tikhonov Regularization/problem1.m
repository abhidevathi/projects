%% Looking at the Image
load('TrueTarget.mat')
X = Target; clear Target
imagesc(X)
print('TrueTarget', '-dpng')
%% Constructing the Convolution Matrix
[n1, n2] = size(X);
N = n1*n2;
p1 = (1:n1);
p2 = (1:n2);
[P1,P2] = meshgrid(p1,p2);
P = [P2(:)';P1(:)'];
%% Computation need not be done everytime, instead use the next 

% Solve for the tolerance tau
lambda = 3;
syms tau 
tau = double(solve(exp(-tau^2/(2*lambda^2)) == 10^-3, tau > 0));

tic
A = zeros(N);

for j = 1:N
    for k = 1:N
        distnc = norm(P(:,j) - P(:,k))^2;
        if (distnc < tau) % Remove all the entries that are less than tol
            A(j,k) = exp(-distnc/(2*lambda^2));
        end
    end
end

A = sparse(A);
toc
%% Visualization of the blurring matrix.
load blurringA.mat
imagesc(A)
print('imagesc(A)','-dpng')

spy(A)
print('spy(A)','-dpng')
%% Applying the blurring and Plotting
imvec = X(:); % Image in Vector Format
x_blur = A*imvec;
X_blur = reshape(x_blur, [100, 100]);
b = x_blur;
imagesc(X_blur)
print('BlurredTarget','-dpng')
%% Constructing L
% Sparse Diagonal Matrix
C1 = [ones(n1,1) -2*ones(n1,1) ones(n1,1);];
L1 = spdiags(C1, [-1 0 1], n1, n1); % Creating a sparse matrix

l2 = zeros(n2,1);
l2(1) = -2; l2(2) = 1;
L2 = toeplitz(l2);
bigL2 = kron(eye(n1),L2);
bigL1 = kron(L1,eye(n2));

L = sparse(bigL2 + bigL1);
%% Tikhonov Regularization - Reconstruction for alpha = 1e-6
alpha = 1e-6;
noiselev = 1e-3;
noise = noiselev*randn(N,1);
r = [b; zeros(N,1)];

x_alpha = (A'*A + alpha*eye(N))\(A'*b); % reconstructed image L = I
discr = norm(x_blur - A*x_alpha);
imagesc(reshape(x_alpha, [100, 100]))
print('alpha1e-6', '-dpng')

bnoise = b + noise;
x_alpha = (A'*A + alpha*eye(N))\(A'*bnoise); % reconstructed image L = I
discr_noise = norm(x_blur - A*x_alpha);
imagesc(reshape(x_alpha, [100, 100]))
print('alpha1e-6_noise', '-dpng')
%% Reconstruction Further
tau = 1.2; % For tikhonov function, generally chosen as 
alphamin = 1e-16;
alphamax = 1e16;
discr0 = tau*norm(noise)^2;
delta = 0.001;
ddiscr = Inf;
iter = 0;
MAXITER = 10;
rnoise = sparse([bnoise;zeros(N,1)]);
solns = zeros(N,MAXITER);
ddiscrs = zeros(1,MAXITER);
alphas = zeros(1,MAXITER);
while (ddiscr > delta && iter < MAXITER)
    % Compute a regularized solution using the geometric mean
    iter = iter + 1;
    tic
    alpha = sqrt(alphamin*alphamax);
    alphas(iter) = alpha;
    % M = sparse([A; sqrt(alpha)*L]); x_alpha = M\rnoise;
    x_alpha = (A'*A + alpha*eye(N))\(A'*bnoise);
    discr = norm(bnoise - A*x_alpha);
    toc
    if discr > discr0
        alphamax = alpha;
    elseif discr <= discr0
        alphamin = alpha;
    end
    ddiscr = abs(discr - discr0);
    ddiscrs(iter) = ddiscr;
    solns(:,iter) = x_alpha;
    
end
imagesc(reshape(x_alpha,[100,100]))
print('TikhinovReconstructed','-dpng')
%%
figure(1)
for i = 1:iter
    subplot(4,2,i)
    imagesc(reshape(solns(:,i), [100, 100]))
    title(strcat('alpha =  ', num2str(alphas(i))))
end