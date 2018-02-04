A = [1 23 3; 3 2 6; 5 7 8];
norms = zeros(1,3);
for i = 1:3
    norms(i) = norm(A(:,i));
end
[B,I] = sort(norms);


x = 1:10;
y = sin(x);
plot(x,y,'r*-','MarkerSize',10)