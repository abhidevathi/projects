function [norms, x] = CGLSHeatDown(N,b,noise,P)

h = 1/N;
D = 0.1; % Heat diffusion coefficient
aux = zeros(N,1);
aux(1) = -2;
aux(2) = 1;
L = toeplitz(aux);
rhs = @(t,u) (D/h^2)*(L*u);
tspan = linspace(0, 1, N)';



x = zeros(N,1); 
d = P*b; % Discrepancy Vector, for start, it is b because Pb - P*A(0) = Pb;
% r = A'P'*b; % residual error A'P'b - A'P'Ax = A'P'(b - Ax) = A'P'(b - A(0)) = A'P'b;
[~,r] = ode15s(rhs,tspan,P'*d);
r = r(end,:)';
p = r; % Search Directions
% t = PA*p; % To save the matrix multiplication so we don't do it again.
[~, t] = ode15s(rhs,tspan,p);
t = t(end,:)'; t = P*t;
j = 1; % Iteration Variable
MAXITER = 100; % Max number of iterations to be safe
tau = 1.2; % Safety Factor
norms = zeros(MAXITER,1);
norms(1) = Inf;

while(norms(j) > tau*noise*norm(b) && j < MAXITER)

    alpha = norm(r)^2/norm(t)^2;
    x = x + alpha*p;
    d = d - alpha*t;
    
    [~,rnew] = ode15s(rhs,tspan,P'*d); rnew = rnew(end,:)'; % This is A'*d
    beta = norm(rnew)^2/norm(r)^2;
    p = rnew + beta*p;
    
    [~, t] = ode15s(rhs,tspan,p); t = t(end,:)'; % A*p
    t = P*t;
    r = rnew;
    j = j + 1;
    norms(j) = norm(d);
end



end

