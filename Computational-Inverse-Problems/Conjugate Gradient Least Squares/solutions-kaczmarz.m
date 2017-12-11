%% Data Vector
m = 50;
ints = (1:m)';
s = 10.^(-1 + 2*(ints - 1)/(m - 1)); % discretization for s

% Laplace Transform, calculated analytically
Lu = @(s) (1./(2.*s.^2)).*(2 - 3.*exp(-s)+exp(-3*s));
b0 = Lu(s); % noiseless exact data
%% Discretization
a = 0; T = 5;%  bound on discretization
n = 60; % number of points
[t, w] = GLquadrature(a, T, n);
% (iii) computing the forward matrix using Matlab Commands
A = repmat(w',m,1).*exp(-s*t'); % one-liner Hell yeah!

% Singular Values
figure()
semilogy(svd(A), 'bo-', 'LineWidth',1.5)
title('Singular Values of A, Log Scale')
print('Singular Values', '-dpng')
%% Plotting the True Function 
u = @(t) t.*(0 <= t & t < 1) + (3/2 - t/2).*(1 <= t & t < 3);
ut = u(t);
resid = b0 - A*ut;
relerr = norm(resid)/norm(b0);
% Original
figure();
plot(t,ut,'LineWidth',8)
title('Original Function', 'fontsize', 15)
print('Piecewise', '-dpng')


% Laplace Transformation
figure()
hold on
plot(s,b0,'b-', 'LineWidth', 3)
plot(s,A*ut,'ro', 'LineWidth', 3)
hold off
leg = legend('Analytic','Linear Transform');
leg.FontSize = 13;
print('Comparison', '-dpng')
%% Minimum Norm Solution
u_poop = A\b0; % using matlab's commands on TRUE data
figure()
hold on
plot(t,u_poop,'LineWidth',3)
plot(t,ut,'LineWidth',3)
hold off
legend('Poop','True')
print('Poop Solution', '-dpng')
% Clearly this is very bad
%% Kaczmarz Iterative Solver, Noiseless
[errors,u_kac] = Kaczmarz(A,b0,0);
figure()
hold on
plot(t,ut,'bo-')
plot(t,u_kac,'ro-')
plot(t, abs(u_kac - ut), 'ko-')
hold off
leg = legend('True','Kaczmarz', 'Residual');
leg.FontSize = 13;
print('Noiseless Solution','-dpng')

figure()
hold on
plot(log(errors),'b-','LineWidth',3)
hold off
title('Residual Plot'); ylabel('Log Rel Err'); xlabel('k-th Iteration');
print('Residuals-Noiseless','-dpng')
%% Kaczmarz Iterative Solver, Noised
tic
powers = -6:-2;

sigma = 10.^(powers);
plots = length(powers);
figure()
for i = 1:length(powers)
b = b0 + sigma(i)*randn(size(b0));
noiselev = sigma(i)*sqrt(m);

[errors,u_kac] = Kaczmarz(A,b,noiselev);
subplot(plots,2,2*i-1)
hold on
plot(t,ut,'b-','LineWidth',2.5)
plot(t,u_kac,'r-','LineWidth',2.5)
hold off
title(strcat('Noise = ',num2str(sigma(i))), 'FontSize', 15)
leg = legend('True','Kaczmarz');
leg.FontSize = 14;


subplot(plots,2,2*i)
hold on
plot(log(errors),'b-','LineWidth',2.5)
hold off
% title(strcat('Noise = ',num2str(sigma(i))),'FontSize', 7)
ylabel('Log Rel Err'); xlabel('k-th iteration');
xt = get(gca, 'XTick');
set(gca, 'FontSize', 15);
end
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);

print('Iteration','-dpng')
toc