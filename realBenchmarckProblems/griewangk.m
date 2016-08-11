function [ r, x ] = griewangk( vector )
%Griewangk’s function is similar to the function of Rastrigin. It has 
%many widespread local minima regularly distributed.
x = vector;
x = 1200 * x -600;
[m,n]=size(vector);
r=1 + 1/4000*sum(x.^2);
r2=1;
for i=1:max(m,n)
    r2 = r2 * cos(x(i)/sqrt(i));
end
r = r - r2;

%Test area is usually restricted to hyphercube -600 <=xi<= 600, i = 1;...; n.
%Its global minimum equal f(x) = 0 is obtainable for xi = 0, i = 1;...;n.
end

