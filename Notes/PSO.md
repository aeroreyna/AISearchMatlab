---
  bibliography: notes.bib
---

# Particle Swarm Optimization

PSO is the third most popular metaheuristic algorithm, by number of citations as shown in the [AISearch GitHub Page](https://aisearch.github.io/#/).
A big part of its popularity is due to the simplicity of its inspiration and equations.

In a nutshell, PSO is based on the idea of a group of individuals which moves follows the direction of the group leader (current best solution) and their own experienced trajectory (personal best solution).

PSO has three meta-parameters that adjust the search process:

  1. Previous Velocity Weight $w_v$ (Default: 0.4)
  2. Personal Best Attraction Weight $c_1$ (Default: 2)
  3. Global Best Attraction Weight $c_2$ (Default: 2)

These defaults parameters are proposed by Marini and Walczak (2015)[^1].

In this way the operators of PSO can be expressed in a simplified way as:

```matlab
%           (Random atraction to the personal best solution)
pbAtraction = rand .* self.bestPersonal - self.population;

%              (Random atraction to the best global solution)
bestAtraction = rand .* self.bestSolution - self.population;

% update velocity trajectories.
velocity = velocityParam * velocity + ...       %inertia
           bestPersonalParam * pbAtraction + ...%personal best
           bestParam * bestAtraction;           %global best

% update solutions
population = population + velocity;
```

## In depth

Different form most evolutionary approaches PSO do not apply any type of elitism to maintain "good" solutions in the population.
This means that the solutions are permanently modified by the resultant velocity of each individual, even if such change produce an inferior fitness value.
In the other hand, PSO implements a memory that records the best personal solution encounter by each individual, which maintains the potential "good" solutions to be explore.
Another mechanism that convey exploitation is the attraction to the global best solution, which act as an unified force over all the individuals to this solution.

The algorithm converge when all the solutions have a best personal solution between the same local optimal neighborhood.
In this case, due to the lack of stronger random exploration methods, further iterations will only perform exploitation over the converged area.
This behavior can be seen in the resulting plots of the [Example 1](../Examples/SimplePSO.m), when a small velocity weight is chosen `pso.velocityParam = 0.1;`.

![](../Examples/PSO_evolution.gif){width=50%}

## Known Disadvantages

PSO is kwon to converge prematurely, which implies that it is likely to get trap on local optimal.

Due to the several memory requirements (personal best and velocity) it application on GPU is limited by lower population sizes than other algorithms.

[^1]: Marini, Federico, and Beata Walczak. 2015. “[Particle Swarm Optimization (PSO). A Tutorial.](https://doi.org/10.1016/j.chemolab.2015.08.020)” Chemometrics and Intelligent Laboratory Systems 149 (December). Elsevier BV: 153–65.
