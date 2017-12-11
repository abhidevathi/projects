%%% This is the Conjugate Gradient Least Squares Algorithm, taken from
%%% Erkki Somersalo's Notes. It solves the normal equations A'*A*x = A'*b.

function [norms,x] = CGLS(A,b,noise)
    
    [~,n] = size(A);
    x = zeros(n,1); 
    d = b; % Discrepancy Vector, for start, it is b because b - A(0) = b;
    r = A'*b; % residual error A'b - A'Ax = A'(b - Ax) = A'(b - A(0)) = A'b;
    p = r; % Search Directions
    t = A*p; % To save the matrix multiplication so we don't do it again.
    j = 1; % Iteration Variable
    MAXITER = 1000; % Max number of iterations to be safe
    tau = 1.2; % Safety Factor
    norms = zeros(MAXITER,1);
    norms(1) = Inf;
    
    while(norms(j) > tau*noise && j < MAXITER)
        
        alpha = (r'*r)/(t'*t);
        x = x + alpha*p;
        d = d - alpha*t;
        rnew = A'*d; % Matrix Multiplication #1
        beta = (rnew'*rnew)/(r'*r);
        p = rnew + beta*p;
        t = A*p; % Matrix Multiplication #2 
        r = rnew;
        j = j + 1;
        norms(j) = norm(d);
    end

end