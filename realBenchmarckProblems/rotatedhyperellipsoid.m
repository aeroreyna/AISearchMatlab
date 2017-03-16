function [ r, x ] = rotatedhyperellipsoid( vector )
%Rotatedhyperellipsoid function
%Function is continuous, convex and unimodal
x = vector;
x = x * 131.0720 - 65.536;
[m,n]=size(vector);
r=0;
for i=1:max(m,n)
    r = r + sum(x(1:i).^2);
end

%Test area is usually restricted to hyphercube -65:536 <= xi <= 65:536, i = 1; : : : ; n.
%Global minimum f(x) = 0 is obtainable for xi = 0, i = 1; : : : ; n.
end

