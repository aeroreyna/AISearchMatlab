# Fitness Functions

In theory, a fitness function provide a numerical value that indicates the fitness (adaptation) of any given solution.
This fitness value indicates to the algorithms how "good" a solution is in comparison with the other solutions in the current population or those previously evaluated in the iterative process.

Metaheuristic algorithms are usually designed to operates as block boxes, i.e., the characteristics specifics of the problem are not considered in their implementation and with some few changes these can be applied from one optimization problem to another.
In this sense, the fitness function is the only contact these algorithms have with the optimization problem itself, and thus the importance of structuring an appropriated fitness function.

For the case of the AISearch toolbox implementation, the optimization is always considered a minimization problem, meaning that the best solution is such with the lowest fitness value.
A maximization problem can be transform to a minimization by multiplying the fitness value to $-1$ before returning it.

Also, the fitness function should expect a single input, which is an two dimensional matrix of solutions, in which the first dimension (rows) represent each one of the solutions and the second (cols) represent the dimensionality of the problem $D$.
All the solutions in the input that the algorithm offers are bounds in the limits of [0, 1], thus is responsibility of this function to scale them to their proper values [^1].
Finally the fitness function is expected to return two values, a vector of the fitness values of each solution, and the scaled solutions into the corresponded bounds.
The second output is only of interest for the problem to solve, any of the algorithms uses this information.


For example, considering the case of the cuadratic function $\sum_{i=1}^D x_i^2$ in the region where $x_i \in [-10, 10] \;\forall i$. The following fitness function can be formulated:

```matlab
pso = DE(@cuadraticFunction, 2);
pso.start()

function [y, x] = cuadraticFunction(x)
  x = x * (10 * 2) - 10; % x * (High - Low) + (Low)
  y = sum(x.^2, 2);
end
```

In this function the input x is scaled to the proper boundaries, and then evaluated over the equation, in which the sum is carried over the second dimension of the input.

This type of [benchmark functions](../realBenchmarkProblems) can be easily [vectorized](Vectorization.md), however the case might be on which a iterative process has to be carried over the $N$ solutions in the input matrix, like:

```matlab
function [y, x] = cuadraticFunction(x)
  x = x * (10 * 2) - 10; % x * (High - Low) + (Low)
  N = size(x,1);
  y = zeros(N, 1);
  for i = 1:N
    y[i] = sum(x[i,:].^2, 2);
  end
end
```



[^1]: Using the bound of [0,1] in the algorithms ease their implementation, producing a cleaner code. It, also separates the algorithm logic from the problem logic. This might no be the best implementation in other languages due to the precision in the float point used.
