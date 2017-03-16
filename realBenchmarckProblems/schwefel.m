function [ r, x ] = schwefel( vector )
%Schwefel’s function is deceptive in that the global minimum is geometrically distant,
%over the parameter space, from the next best local minima. Therefore, the
%search algorithms are potentially prone to convergence in the wrong direction.

x=vector;
x = x * 1000 - 500;
[m,n]=size(vector);
m = max(m,n);
r=418.9829*m+sum(-x.*sin(sqrt(abs(x))));
%Test area is usually restricted to hyphercube -500 <= xi <= 500, i = 1; ... ; n.
%Its global minimum f(x) = -418.9829n is obtainable for xi = 420.9687
end

