function [ r, x ] = jongs( vector)
%Jong’s function
%Function is continuous, convex and unimodal
x = vector;
x = 10.24 * x - 5.12;
r = sum(x.^2);
%Test area is usually restricted to hyphercube -5.12 <= xi <= 5.12, i = 1; : : : ; n.
%Global minimum f(x) = 0 is obtainable for xi = 0, i = 1; : : : ; n.

end

