figure(1)
for k = 1:6
    A = X{k};
    Z = princcomp(A,'centered');
    subplot(2,3,k)
    plot(Z(1,:),Z(2,:),'r.')
    xlabel('First Principal Component')
    ylabel('Second Principal Component')
    title(strcat('Frequencies', ' k = ', num2str(k)))
end