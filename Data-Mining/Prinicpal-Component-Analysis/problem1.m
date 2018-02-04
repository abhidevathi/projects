load ModelReductionData
        figure(1);
        subplot(2,2,1);
        plot(X(2,:),X(4,:),'k.');
        axis('equal');
        xlabel('2nd Feature'); ylabel('4th Feature');
        title('2nd row by 4th')
        

        subplot(2,2,2);
        plot(X(1,:),X(4,:),'k.');
        axis('equal'); 
        xlabel('1st Feature'); ylabel('4th Feature');
        title('1st row by 4th')
    

        subplot(2,2,3);
        plot(X(2,:),X(5,:),'k.');
        axis('equal');
        xlabel('2nd Feature'); ylabel('5th Feature');
        title('2nd row by 5th')
        

        subplot(2,2,4);
        plot(X(1,:),X(2,:),'k.');
        axis('equal');
        xlabel('1st Feature'); ylabel('2nd Feature');
        title('1st row by 2nd')
        
print -depsc Projections.eps

%%center the columns of Xc
[n,p] = size(X);
x_c = 1/p*(sum(X(:,:),2));
Xc = X - x_c*ones(1,p);

[U,S,Vt] = svd(Xc);
D = diag(S);

figure(2)
semilogy(D, 'k.', 'MarkerSize', 40)
set(gca,'FontSize',20)
title('SingularValues')
print -depsc SingularValues.eps

Z3 = U(:,1:3)'*Xc;

figure(3)
subplot(3,1,1)
plot(Z3(1,:),Z3(2,:),'k.')
xlabel('First Principal Component'); ylabel('2nd');
subplot(3,1,2)
plot(Z3(2,:),Z3(3,:),'k.')
xlabel('Second Principal Component'); ylabel('3rd');
subplot(3,1,3)
plot(Z3(1,:),Z3(3,:),'k.')
xlabel('First Principal Component'); ylabel('3rd');
print -depsc FirstPrincipalComponents.eps

% figure(4)
% scatter3(Z3(1,:), Z3(2,:), Z3(3,:), 'r.');
% print -depsc ThreeDimensionalPCA.eps