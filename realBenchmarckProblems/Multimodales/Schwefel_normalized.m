function [ y,x ] = Schwefel_normalized( x )
%Schwefel Function
%   [-500 500 -500 500]
x = x*1000-500;
[aux1,aux2]=size(x);
if(aux1>=aux2)
    n = aux1;
else
    n= aux2;
end
s=0;
for ii=1:n
    s = s+(-x(ii).*sin(sqrt(abs(x(ii)))));
end
y = s/n;
%  Search domain: -500 < xi < 500, i = 1, 2, . . . , n.
%  Number of local minima: several local minima.
% global minimum
% f(x) = 0
% 
% x(i) = 420.90687, i=1:n 
end

