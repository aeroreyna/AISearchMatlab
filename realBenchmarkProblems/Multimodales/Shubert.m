function [ y,x ] = Shubert( x)
%Shubert Function
%   [-10 10 -10 10]
x = x*20-10;
s1 = 0; 
s2 = 0;
for i = 1:5;   
    s1 = s1+i*cos((i+1)*x(1)+i);
    s2 = s2+i*cos((i+1)*x(2)+i);
end
y = s1*s2;
%  Search domain: -10 < xi < 10, i = 1, 2.
%  Number of local minima: several local minima.
%  The global minima: 18 global minima  f(x*) = -186.7309.
end

