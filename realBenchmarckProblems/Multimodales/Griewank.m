function [ y,x ] = Griewank( x)
%Griewank Function
%   Detailed explanation goes here
%,[-600 600 -600 600]
x = x*1200-600;
[aux1,aux2]=size(x);
if(aux1>=aux2)
    n = aux1;
else
    n= aux2;
end
fr = 4000;
s = 0;
p = 1;
for j = 1:n; s = s+x(j)^2; end
for j = 1:n; p = p*cos(x(j)/sqrt(j)); end
y = (s/fr)-p+1;
%  Search domain: -600 < xi < 600, i = 1, 2, . . . , n.
%  Number of local minima: several local minima.
%  The global minima: x* =  (0, …, 0), f(x*) = 0.
end

