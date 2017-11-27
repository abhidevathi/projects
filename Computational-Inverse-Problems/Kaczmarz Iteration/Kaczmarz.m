function [discrs,u] = Kaczmarz(A,b,noiselev)
[m,n] = size(A);
u = zeros(n,1);
k = 0; % Iteration Counter
discr = Inf; % residual
MAX_ITER = 130000; % So we don't kill our CPU
discrs = zeros(MAX_ITER,1); % store residual at each iteration 
while(k < MAX_ITER && discr > noiselev)
    for j = 1:m
        aj = A(j,:)';
        % Using the Kaczmarz Projection to compute the next solution
        u = u + (1/norm(aj))^2*(b(j) - aj'*u)*aj;
    end
    k = k+1;
    
    % Compute Relative Error of Residual
    discr = norm(b - A*u)/norm(b);
    discrs(k) = discr;
end

% Truncate so we don't get values after iteration stops
discrs = discrs(1:k); 

end