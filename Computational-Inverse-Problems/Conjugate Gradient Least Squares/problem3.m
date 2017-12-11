%%% Downsizing the Problem


% We need to create a matrix P_k that picks every kth data point in a
% vector. To create this matrix, it needs to dimension n x [n/s], where []
% denotes the greatest integer below the argument
N = 100;
h = 1/N;
D = 0.1; % Heat diffusion coefficient
aux = zeros(N,1);
aux(1) = -2;
aux(2) = 1;
L = toeplitz(aux);
rhs = @(t,u) (D/h^2)*(L*u);
tspan = linspace(0, 1, N)';
box = @(t) 1*(1/3 < t & t < 2/3);
u0 = box(tspan);

%%% Forward Propagation
[time,u] = ode15s(rhs,tspan,u0);
%%% Pick off the final solution to solve the Inverse Problem
b = u(end,:)';
%% Varying k

% Let's use a tiny bit of noise
noise = 1e-5;
b = b + noise*rand(size(b));

ks = [2 5 10 20];

for i = 1:length(ks)
    k = ks(i);
    P = PMatrix(k,N);
    [norms,x] = CGLSHeatDown(N,b,noise,P);
    figure()
    subplot(2,1,1)
    hold on
    plot(tspan,x,'r-','LineWidth',3)
    plot(tspan,u0,'b-','LineWidth',3)
    hold off
    legend('CGLS Solution','True Solution')
    text(0.45,0.3,['k = ' num2str(k)],'FontSize',20)
    subplot(2,1,2)
    plot(norms,'LineWidth',3)
    xlabel('Iteration Number','FontSize',17);
    ylabel('Norm of Residual','FontSize',17);
    print(strcat('downsample_k',num2str(k)),'-dpng')
end

%% Random Selection of Integers
ints = sort(randi(100,1,5));
P = eye(N);
P = P(ints,:);
[norms,x] = CGLSHeatDown(N,b,noise,P);
    figure()
    subplot(2,1,1)
    hold on
    plot(tspan,x,'r-','LineWidth',3)
    plot(tspan,u0,'b-','LineWidth',3)
    hold off
    legend('CGLS Solution','True Solution')
    text(0.42,0.3,'random','FontSize',20)
    subplot(2,1,2)
    plot(norms,'LineWidth',3)
    xlabel('Iteration Number','FontSize',17);
    ylabel('Norm of Residual','FontSize',17);
    print('downsample_random','-dpng')
