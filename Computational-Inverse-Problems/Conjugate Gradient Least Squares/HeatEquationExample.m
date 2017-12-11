% Heat equation by method of lines

n = 50; % Number of intervals
h = 1/n;
D = 0.1; % Heat diffusion coefficient
aux = zeros(n-1,1);
aux(1) = -2;
aux(2) = 1;
L = toeplitz(aux);
a = 0.1;
f = zeros(n-1,1);
f(1) = a;
f(n-1) = a;

rhs = @(t,u) (D/h^2)*(L*u + f);

x = (1/n)*(1:n-1)';
u0 = a*ones(n-1,1);
I = find(x>1/3 & x <2/3);
u0(I) = 3*ones(length(I),1);

%%

figure(1)
plot([0:1/n:1],[a;u0;a],'r-','LineWidth',3)
axis([0,1,0,3.2])
set(gca,'FontSize',20)

pause

% Propagating

tspan = [0:0.02:1];

[time,u] = ode15s(rhs,tspan,u0);
%%
figure(2)
for j = 1:length(time)
    plot([0:1/n:1],[a,u(j,:),a],'k-','LineWidth',3)
    text(0.2,2,['t =' num2str(time(j))],'FontSize',20)
    axis([0,1,0,3.2])
    set(gca,'FontSize',20) 
    pause(0.1)
end

pause

% Demonstration that it does not work backwards in time

reverse_rhs = @(t,u) (-D/h^2)*(L*u + f);

tspan = [0:0.02:1];

noiselev = 1e-8;
%noiselev = 0;

noise = noiselev*randn(n-1,1);
u_final = u(end,:)' + noise;
[time,u] = ode15s(reverse_rhs,tspan,u_final);

figure(3)
cont = 0;
for j = 1:length(time)
    plot([0:1/n:1],[a,u(j,:),a],'k-','LineWidth',3)
    axis([0,1,0,3.2])
    text(0.2,2,['t =' num2str(time(j))],'FontSize',20)
    if max(u(j,:))>3 & cont == 0
        pause
        cont = 1;
    end
    set(gca,'FontSize',20) 
    pause(0.5)
    if max(u(j,:))>100
        break
    end
end