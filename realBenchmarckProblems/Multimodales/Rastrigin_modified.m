function [ y,x ] = Rastrigin_modified( x )
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
% k=ones(n);
% for j = 1:n-1
%     k(j)=k(j)*k(j+1);
% end

s = 0;
k(1)=3;
k(2)=4;
for j = 1:n
    s=s+(10+9*cos(2*pi*k(j)*x(j)));
%     k=k+1;
    %s = s+(x(j)^2-10*cos(2*pi*x(j))); 
end
%y = 10*n+s;
y=s*1;


%  Search domain: -5.12 < xi < 5.12, i = 1, 2, . . . , n.
%  Number of local minima: several local minima.
%  The global minima: x* =  (0, …, 0), f(x*) = 0.
end

