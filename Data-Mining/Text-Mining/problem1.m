%% Part A: Loading the Sequence
genseq = LoadSeq('ccrescentus.fa');
%% Part B1: Varying k
fignum = 1;
L = 300;
for k = 1:6
    A = CalcFreq(genseq,k,L);
    A = A';
    Z = princcomp(A,'centered');
    figure(fignum)
    subplot(2,3,k)
    plot(Z(1,:),Z(2,:),'r.')
    xlabel('First Principal Component')
    ylabel('Second Principal Component')
    title(strcat('Principal Components of Frequencies', ' k = ', num2str(k)))
end
fignum = fignum+1;
%% Part B2: Varying L
k = 3;
figure(fignum)
fig = 1;
for L = 100:100:300
    A = CalcFreq(genseq,k,L);
    A = A';
    Z = princcomp(A,'centered');
    subplot(1,3,fig)
    plot(Z(1,:),Z(2,:),'r.')
    xlabel('First Principal Component')
    ylabel('Second Principal Component')
    title(strcat('Principal Components of Frequencies', ' L = ',num2str(L)))
    fig = fig + 1;
end
clear fig
%% Code to Create the Document Matrix For Later Use
k = 3;
L = 300;
A = CalcFreq(genseq,k,L);
A = A';
[n,p] = size(A);
[U,D,V] = svd(A);
%% Part C: Changing String
genseq_changed = genseq(101:end);
k = 3;
L = 300;
A = CalcFreq(genseq_changed,k,L);
A = A';
Z = princcomp(A,'centered');
figure(3)
plot(Z(1,:),Z(2,:),'r.')
xlabel('First Principal Component')
ylabel('Second Principal Component')
title('Principal Components of Frequencies k = 3, L = 300')
fignum = fignum+1;
%% Part D: Cluster Plot of PCA

Z = princcomp(A,'centered');
[medoids, I] = kmeans(A,6,100);
%Zmed = princcomp(medoids,'centered');
figure(1)
hold on

plot(Z(1,I==1),Z(2,I==1),'r.','MarkerSize',10)
plot(Z(1,I==2),Z(2,I==2),'b.','MarkerSize',10)
plot(Z(1,I==3),Z(2,I==3),'g.','MarkerSize',10)
plot(Z(1,I==4),Z(2,I==4),'m.','MarkerSize',10)
plot(Z(1,I==5),Z(2,I==5),'c.','MarkerSize',10)
plot(Z(1,I==6),Z(2,I==6),'k.','MarkerSize',10)
hold off
xlabel('First Principal Component')
ylabel('Second Principal Component')
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Cluster 6')

%% Part E: NMF of Cluster Plot

clusts = 6;
[W,H,~] = MULT_UPT(A,clusts,0.0001);
c = 1/p*sum(A,2);
Wc = W - repmat(c,1,clusts);
Z_nmf = U(:,1:2)'*Wc;

%% Part F: Cosines of the Medoids
[medoids,~] = kmedoids(A,6,0.001);
cosines = zeros(p,clusts);
for i=1:clusts
    for j=1:p
        num=A(:,j)'*medoids(:,i);
        denom=norm(A(:,j))*norm(medoids(:,i));
        cosines(j,i)=num/denom;
    end
end
% Part F2: Plotting Cosines
figure(124)
add = repmat([0;1;2;3;4;5],1,p);
cosines = cosines + add';
plot(cosines)
legend('Medoid 1','Medoid 2','Medoid 3','Medoid 4','Medoid 5','Medoid 6')
