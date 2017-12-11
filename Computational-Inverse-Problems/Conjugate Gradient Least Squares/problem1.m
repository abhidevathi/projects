%% Setting Up Laplace Transform

% Data Vector %
m = 50;
ints = (1:m)';
s = 10.^(-1 + 2*(ints - 1)/(m - 1)); % discretization for s

% Laplace Transform, calculated analytically
Lu = @(s) (1./(2.*s.^2)).*(2 - 3.*exp(-s)+exp(-3*s));
b0 = Lu(s); % noiseless exact data

% Discretization %
a = 0; T = 5;%  bound on discretization
n = 60; % number of points
[t, w] = GLquadrature(a, T, n);

% This matrix computes the Linear transform to the Laplace Transform 
A = repmat(w',m,1).*exp(-s*t'); % one-liner Hell yeah!

%% Testing with CGLS
u = @(t) t.*(0 <= t & t < 1) + (3/2 - t/2).*(1 <= t & t < 3);
ut = u(t);

sigmas = [5*10^-3 10^-5 0];
for i = 1:length(sigmas)
    sigma = sigmas(i);
    b = b0 + sigma*rand(size(b0));
    [errors,x] = CGLS(A,b,sigma);
    figure()
    subplot(2,1,1)
    hold on
    plot(t,x,'LineWidth',2)
    plot(t,ut,'LineWidth',2)
    hold off
    legend('CGLS','Original')
    title(['Noise = ' num2str(sigma)],'FontSize',18)
    subplot(2,1,2)
    loglog(errors, 'LineWidth', 2)
    xlabel('Iteration','FontSize',18)
    ylabel('Residual')
    if i == 1
        print('Laplace_5e-3','-dpng')
    else
        print(['Laplace_', num2str(sigma)],'-dpng')
    end
end
%% Looking at Singular Values

figure()
semilogy(svd(A).^2,'ro-','LineWidth',3)
title('Singular Values of Normal Equations','FontSize',20)
print('SingVals','-dpng')
