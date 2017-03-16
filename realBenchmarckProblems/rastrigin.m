function [ r, x ] = rastrigin( vector )
%Rastrigin’s function is based on the function of De Jong with the addition of cosine
%modulation in order to produce frequent local minima.

[m n] = size(vector);
n = max(n,m);
x=vector;
x = x * 10.24 - 5.12;
r= 10*n + sum(x.^2-10*cos(2*pi*x));

%Test area is restricted to hyphercube -5.12 <= xi <= 5.12, i = 1;... ; n. 
%Its global minimum f(x) = 0 is obtainable for xi = 0, i = 1; ... ; n.
end

