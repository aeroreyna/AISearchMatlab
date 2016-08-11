function [ y,x ] = Schwefel( x )
%Schwefel Function
%   [-500 500 -500 500]
x = x*1000-500;
[aux1,aux2]=size(x);
if(aux1>=aux2)
    n = aux1;
else
    n= aux2;
end
s = sum(-x.*sin(sqrt(abs(x))));
y = 418.9829*n+s;
%  Search domain: -500 < xi < 500, i = 1, 2, . . . , n.
%  Number of local minima: several local minima.
% global minimum
% f(x) = 0
% 
% x(i) = 420.90687, i=1:n 
end

