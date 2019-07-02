function [ r, x ] = ackley( vector )
%ACKLEY Summary of this function goes here
%   Detailed explanation goes here
x= vector;
x = 65.5360 * x - 32.768;
[m n] = size(x);
n = max(m,n);
a=20;
b=0.2;
c=2*pi;
r = -a*exp(-b*sqrt(1/n*sum(x.^2)))-exp(1/n*sum(cos(x.*c)))+a+exp(1);
%It is recommended to set a = 20, b = 0:2, c = 2PI. Test area is usually restricted to
%hyphercube -32.768<=xi<=32.768, i = 1;...; n. Its global minimum f(x) = 0
%is obtainable for xi = 0, i = 1;...; n.
end

