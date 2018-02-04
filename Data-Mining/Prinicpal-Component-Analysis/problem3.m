load('IrisData.mat')
[n,p] = size(X);

figure(1)

    subplot(2,3,1)
    plot(X(1,:),X(2,:), 'k.');
    title('Rows 1 and 2')

    subplot(2,3,2);
    plot(X(1,:),X(3,:), 'k.');
    title('Rows 1 and 3')

    subplot(2,3,3);
    plot(X(1,:),X(4,:), 'k.');
    title('Rows 1 and 4')

    subplot(2,3,4);
    plot(X(2,:),X(3,:),'k.');
    title('Rows 2 and 3')

    subplot(2,3,5);
    plot(X(2,:),X(4,:),'k.');
    title('Rows 2 and 4')

    subplot(2,3,6);
    plot(X(3,:),X(4,:),'k.');
    title('Rows 3 and 4')

x_c = 1/p*(sum(X(:,:),2));
Xc = X - x_c*ones(1,p);
print -depsc 2d_projections.eps

[U,S,Vt] = svd(Xc);
D = diag(S);
figure(2)

plot(D, 'k.', 'MarkerSize', 40)
set(gca,'FontSize',20)
title('SingularValues')
print -depsc IrisSingularValues.eps
