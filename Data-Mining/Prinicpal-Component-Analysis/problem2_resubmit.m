load('HandwrittenDigits.mat')

k1 = 0; k2 = 1; k3 = 3; k4 = 7;
nums = [k1 k2 k3 k4];
residuals = zeros(5,5);
for l = 1:length(nums)
    digit = num2str(nums(l));
    Il = I == nums(l);
    Xl = X(:,Il);
    [U,~,~] = svd(Xl);
    figure(l)
    for i = 1:5
    Uk = U(:,1:5*i); Zk = Uk'*Xl; % Rank k approximation of each digit
        for j = 1:5
            xj = Uk*Zk(:,j);
            residuals(i,j) = norm(Xl(:,j) - xj,2);
            subplot(5,5,(i-1)*5 + j)
            imagesc(reshape(xj,16,16)');
            colormap(1-gray); % 0 is white, 1 is black
            axis('square')
            axis('off');
        end
    end
    figure(length(nums) + l)
    for j = 1:5
        hold all
        plot(5:5:25,residuals(:,j))
        xlabel('Number of Feature Vectors')
        ylabel('Residual')
        title(strcat('Residuals for ',' ', digit))
    end
    legend('1st Sample', '2nd', '3rd', '4th','5th')
    hold off
end