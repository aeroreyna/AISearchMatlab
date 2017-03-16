function [ y,x ] = Rastrigin( x )
%Rastrigin Function
%   Detailed explanation goes here
%[-5.12 5.12 -5.12 5.12]
x = x*10.24-5.12;
[aux1,aux2]=size(x);
if(aux1>=aux2)
    n = aux1;
else
    n= aux2;
end 
s = 0;
for j = 1:n
    s = s+(x(j)^2-10*cos(2*pi*x(j))); 
end
y = 10*n+s;


%  Search domain: -5.12 < xi < 5.12, i = 1, 2, . . . , n.
%  Number of local minima: several local minima.
%  The global minima: x* =  (0, …, 0), f(x*) = 0.
end

