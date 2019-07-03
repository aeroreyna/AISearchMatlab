function [ r, x ] = griewangk( vector )
%Griewangk’s function is similar to the function of Rastrigin. It has 
%many widespread local minima regularly distributed.
x = 1200 * vector -600;
D = size(vector, 2);
r = 1 + 1/4000 * sum(x.^2, 2) - prod(cos(x)./ sqrt(1:D), 2);
%Test area is usually restricted to hyphercube -600 <=xi<= 600, i = 1;...; n.
%Its global minimum equal f(x) = 0 is obtainable for xi = 0, i = 1;...;n.
end

