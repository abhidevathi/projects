function D = entropy(A,B)

[n,p] = size(A);
D = 0;
for i = 1:n
    for j = 1:p
        D = D + A(i,j)*log(A(i,j)/B(i,j)) - A(i,j) + B(i,j);
    end
end

end