%% Setting up Discretization Parameters
function [P] = interpolation(n,N)
% n = 64; N = 250; % These values are used for debugging. 

x = linspace(0,1,n);
X = linspace(0,1,N);

%% Finding the Theta values for each xj

P = zeros(n, N); % Projection Matrix
ks = zeros(size(x)); % X(k) where k = argmax{X(k) <= x(j)} for each j.
theta_values = zeros(n,1); % Store each theta according to the formula

for j = 1:length(x)
    threshold = x(j);
    k = find(X >= threshold, 1); % find the first k where xj >= Xk
    if (k == 1)
        ks(j) = k;
    else
        ks(j) = k - 1;
    end
    theta_values(j) = (x(j) - X(ks(j)))*N; % Calculating theta.
end

%% Constructing P
for j = 1:length(x)
    theta = theta_values(j);
    k = ks(j);
    P(j,k) = 1 - theta;
    P(j,k+1) = theta;
end
%% Testing the Matrix
% difference = norm(u - P*U); % Approximation for difference between actual
                            % discretization and transformation of U to u.
end