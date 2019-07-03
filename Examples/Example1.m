pso = DE(@cuadraticFunction, 2);
pso.start()

function [y, x] = cuadraticFunction(x)
  x = x * (10 * 2) - 10; % x * (High - Low) + (Low)
  y = sum(x.^2, 2);
end