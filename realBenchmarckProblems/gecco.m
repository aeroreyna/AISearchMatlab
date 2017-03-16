function [ r, x ] = gecco( vector )
%Griewangk’s function is similar to the function of Rastrigin. It has 
%many widespread local minima regularly distributed.
x = vector;
x = 10 * x -5;
r = geccoBenchmarks(x',11);
end
