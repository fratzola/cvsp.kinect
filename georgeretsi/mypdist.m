function p = mypdist(X,funct)

N = size(X,1);
count = 1;
p = zeros(1,N*(N-1)/2);
for i = 1:N-1
    for j = i+1:N
        p(count) = funct(X(i,:),X(j,:));
        count = count+1;
    end
end
        