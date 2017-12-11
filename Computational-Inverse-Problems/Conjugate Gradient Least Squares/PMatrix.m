
function [P] = PMatrix(k,N)
%PMatrix Summary of this function goes here
%   k = number of points to skip for new discretization
%   N = original discretization

% First start off with the identity: discretization does not change

P = eye(N);
% Now, we find the number of points we can get.
points = k:k:N;
P = P(points,:);

end

