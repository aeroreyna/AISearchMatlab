function [ r, x ] = rosenbrock( vector )
%Rosenbrock's function
%also known as banana function or the second function of De Jong.
%The global optimum lays inside a long, narrow, parabolic shaped flat valley.
%To find the valley is trivial, however convergence to the global optimum is difficult
x = vector;
x = x * 4.0960 - 2.048; %ajusta el vector al rango
[m,n]=size(vector);
r=0;

for i=1:max(m,n)-1
    r = r + 100*(x(i+1)-x(i)^2)^2+(1-x(i))^2;
end

%Test area is usually restricted to hyphercube -2.048 <= xi <= 2.048, i = 1; ... ; n.
%Its global minimum equal f(x) = 0 is obtainable for xi, i = 1; ... ; n.
end
