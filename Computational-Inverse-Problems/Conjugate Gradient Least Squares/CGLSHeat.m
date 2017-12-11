%%% This is the Conjugate Gradient Least Squares Algorithm, taken from
%%% Erkki Somersalo's Notes. It solves the normal equations A'*A*x = A'*b.


%%% n is the size of discretization
%%% b is the initial value
%%% noise is the magnitude of noise we wish to use
function [norms,x] = CGLSHeat(n,b,tspan,noise)
    % Heat equation by method of lines
    
    h = 1/n;
    D = 0.1; % Heat diffusion coefficient
    aux = zeros(n,1);
    aux(1) = -2;
    aux(2) = 1;
    L = toeplitz(aux);

    rhs = @(t,u) (D/h^2)*(L*u);
    
    x = zeros(n,1); 
    d = b; % Discrepancy Vector, for start, it is b because b - A(0) = b;
    % r = A'*b; % residual error A'b - A'Ax = A'(b - Ax) = A'(b - A(0)) = A'b;
    [~,r] = ode15s(rhs,tspan,b);
    r = r(end,:)';
    p = r; % Search Directions
    % t = A*p; % To save the matrix multiplication so we don't do it again.
    [~, t] = ode15s(rhs,tspan,p);
    t = t(end,:)';
    j = 1; % Iteration Variable
    MAXITER = 100; % Max number of iterations to be safe
    tau = 1.2; % Safety Factor
    norms = zeros(MAXITER,1);
    norms(1) = Inf;
    
    while(norms(j) > tau*noise && j < MAXITER)
        
        alpha = norm(r)^2/norm(t)^2;
        x = x + alpha*p;
        d = d - alpha*t;
        [~,rnew] = ode15s(rhs,tspan,d); % This is A'*d
        rnew = rnew(end,:)';
        beta = norm(rnew)^2/norm(r)^2;
        p = rnew + beta*p;
        [~, t] = ode15s(rhs,tspan,p); % A*p
        t = t(end,:)';
        r = rnew;
        j = j + 1;
        norms(j) = norm(d);
    end

end

