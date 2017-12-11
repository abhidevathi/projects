% Backward Heat Equation Using Conjugate Gradient Least Squares %

%% Initialization

% First we initialize a box car function as our initial value for a fine
% discretization of N = 350
N = 350;
tspan = linspace(0, 1, N)';
box = @(t) 1*(1/3 < t & t < 2/3);
u0 = box(tspan);
figure()
plot(tspan,u0, 'LineWidth',3)
title('Original Boxcar Function', 'FontSize',20)
print('boxcar','-dpng')
%%% Setting up the Heat Equation
h = 1/N;
D = 0.1; % Heat diffusion coefficient
aux = zeros(N,1);
aux(1) = -2;
aux(2) = 1;
L = toeplitz(aux); % 2nd order Differential Operator

rhs = @(t,u) (D/h^2)*(L*u); % Heat Equation

%%% Forward Propagation
[time,u] = ode15s(rhs,tspan,u0);

%%% Pick off the final solution to solve the Inverse Problem
u = u(end,:)';
figure()
plot(time,u,'LineWidth',3)
%% Change the Size of the Discretization

%%% Interpolation Matrix
n = 100; % Size of new discretization

P = interpolation(n,N); % Function that creates a matrix to transform from
                        % one discretization to another, based on number of
                        % points you need.

tsmall = P*tspan;
usmall = P*u;
%%% Adding 0.1% of the MaxVal Noise to the noiseless vector

u(1) = 0;
u(end) = 0;
unoise = usmall + 0.001*max(usmall)*randn(size(usmall));

figure()
plot(tsmall,unoise,'r-', 'LineWidth',3)
title('Noisy Final', 'FontSize',20)
print('noisyfinal','-dpng')
%% Reverse Propagation

%%% Use the variable 'unoise' as the initial value
[norms,x] = CGLSHeat(n,unoise,tsmall,0.001);
figure()
subplot(2,1,1)
hold on
plot(tsmall,x,'r-','LineWidth',3)
plot(tsmall,box(tsmall),'b-','LineWidth',3)
hold off
legend('CGLS Solution','True Solution')
subplot(2,1,2)
plot(norms,'LineWidth',3)
title('Residuals','FontSize',20)
print('problem2final','-dpng')
