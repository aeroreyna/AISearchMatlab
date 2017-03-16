function [ r, x ] = hyperellipsoid( vector )
%Hyperellipsoid function
%Function is continuous, convex and unimodal
x = vector;
x = 10.24 * x - 5.12;
[m,n]=size(vector);
r=0;
for i=1:max(m,n)
    r = r + i*(x(i)^2);
end

%Test area is usually restricted to hyphercube -5.12 <= xi <= 5.12, i = 1; : : : ; n.
%Global minimum f(x) = 0 is obtainable for xi = 0, i = 1; : : : ; n.
end

