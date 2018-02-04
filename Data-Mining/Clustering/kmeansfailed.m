%%Abhi Devathi
%%dxd310
%k - means algorithm
load('IrisDataAnnotated.mat');
Xcopy = X;
k = 3;
tau = 10^(-5);
[X1, I1] = datasample(Xcopy,50,2,'Replace',false); Xcopy(:,I1) = [];
[X2, I2] = datasample(Xcopy,50,2,'Replace',false); Xcopy(:,I2) = [];
[X3, I3] = datasample(Xcopy,50,2,'Replace',false); 

clear Xcopy

I_1 = I(:,I1); I_2 = I(:,I2); I_3 = I(:,I3);
break
t = 0;
diff = 10^9;

while(diff > tau && t < 2)
    p1 = length(I1);
    p2 = length(I2);
    p3 = length(I3);
    X1_c = 1/p1*(sum(X1(:,:),2)); 
    X2_c = 1/p2*(sum(X2(:,:),2));
    X3_c = 1/p3*(sum(X3(:,:),2));
    for i = 1:length(X)
        dist1 = sqrt((X(:,i) - X1_c)'*(X(:,i) - X1_c));
        dist2 = sqrt((X(:,i) - X2_c)'*(X(:,i) - X2_c));
        dist3 = sqrt((X(:,i) - X3_c)'*(X(:,i) - X3_c));
        [mindist, clust] = min(dist1, dist2, dist3);
    end
    t = t + 1;
end

    