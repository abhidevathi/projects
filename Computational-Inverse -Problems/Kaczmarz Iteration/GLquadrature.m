% FUNCTION program [x,w] = GLquadrature(a,b,n)
% ----------------------------------------------------------------------------
% Program to compute the abcissae and the weights of Gauss-Legendre's n-point
% quadrature, when the lower and upper limits of the integration are given.
% This algorithm is from Numerical Recipes page 125.
% INPUT  a,b : lower and upper limits of the integration
%         n  : number of division points in the integration
% OUTPUT  x  : (n,1)-vector listing the integration points ( abscissae )
%         w  : (n,1)-vector listing the quadrature weights
% ----------------------------------------------------------------------------
% CALLS TO : None
% 15/11/90 : Pasi Yla-Oijala: Rolf Nevanlinna Institute
% ----------------------------------------------------------------------------

function [x,w] = GLquadrature(a,b,n)

tol = 1e-15 ;                            % tolerance for Newton's method
m = (n+1) / 2 ;
xm = 0.5*(b+a) ;
xl = 0.5*(b-a) ;
for i=1:m
   % approximations of the roots
   if i == m
      z = 2*tol ;                        % right value of z is zero
   else
      z = cos(pi*(i-0.25)/(n+0.5)) ;
   end
   z1 = 0 ;
   while ( abs(z-z1) >= tol )
   % Newton's method for roots of Legendre's polynomials
      p1 = 1 ; p2 = 0 ;
      for j = 1:n
         p3 = p2 ;
         p2 = p1 ;
         p1 = ((2*j-1)*z*p2-(j-1)*p3)/j ; % Legendre's polynomial at point z
      end
      pp = n*(z*p1-p2)/(z^2-1) ;   % derivative of Legendre's polynomial at z
      z1 = z ;
      z = z1-p1/pp ;                   % Newton's method
   end
   x(i) = xm-xl*z ;                    % abscissae
   x(n+1-i) = xm+xl*z ;
   w(i) = 2*xl/((1-(z^2))*(pp^2)) ;    % and weights
   w(n+1-i) = w(i) ;
end
x = x'; w = w';
% ----------------------------------------------------------------------------

