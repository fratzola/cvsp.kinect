function m = chi_squared(X,Y)

m = sum(((X-Y).^2)./((X+Y)+0.000001))/2;
