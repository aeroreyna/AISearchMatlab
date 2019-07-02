function [ y, x ] = Ackley( x )
%Ackley Function
%   Detailed explanation goes here
%[-32 32 -32 32]
[aux1,aux2]=size(x);
if(aux1>=aux2)
    n = aux1;
else
    n= aux2;
end
x = x*64-32;
a = 20; b = 0.2; c = 2*pi;
s1 = 0; s2 = 0;
for i=1:n;
   s1 = s1+x(i)^2;
   s2 = s2+cos(c*x(i));
end
y = -a*exp(-b*sqrt((1/n)*s1))-exp((1/n)*s2)+a+exp(1);

%  Search domain: ?32 ? xi ? 32, i = 1, 2, . . . , n.
%  Number of local minima: several local minima.
%  The global minimum: x* =  (0, …, 0), f(x*) = 0.

end

