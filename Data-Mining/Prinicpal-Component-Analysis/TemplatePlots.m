% This is a small Matlab progrma producing the two figures for the latex
% template.

t = linspace(0,2*pi,1000);
x = sin(t).*sin(2*t);
y = sin(5*t).*sin(17*t);

figure(1)
plot(t,x,'b-','LineWidth',3)
set(gca,'FontSize',25)
xlabel('Time [s]','FontSize',25)
axis([0,2*pi,-1.2,1.2])
print -depsc LeftPanel.eps

figure(2)
plot(t,y,'r-','LineWidth',3)
xlabel('Time [s]','FontSize',25)
set(gca,'FontSize',25)
axis([0,2*pi,-1.2,1.2])
print -depsc RightPanel.eps

