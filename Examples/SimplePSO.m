clear, clc
% This example shows how to use the pso toolbox to execute a simple
% Particle Swarm Optimization (PSO) algorithm run to optimize a benchmark
% function.

% The class PSO is a child of the class metaheuristic. To initialize the
% object two arguments are required, the fitness function and the
% dimensions of the problem. The fitness function is pass as a pointer of
% the function. For more information check the documentation.
pso = PSO(@schwefel, 2);
%pso.velocityParam = 0.1; %Uncomment this to observer a faster convergency.

% By default all the algorithms considers 30 solutions in the population
% and 100 iterations. Nevertheless this can be modified as follows:
pso.sizePopulation = 10;
pso.maxNoIterations = 100;

% This functions plots a 3D graph, this is not usually done, but in this
% example helps to the user to identify the benchmark problem. If any other
% figure was initialize at this point, this plot should be Figure 1.
pso.graph3d();

% Plot each the population at each iteration is usually disable, in order
% to get a fast execution of the algorithm. Nevertheless this can be
% usefull to analize the behaviour of the algorithms, therefore it can be
% activated by the property plotEachIterationB.
pso.plotEachIterationB = true;
% The follow lines determine if the hole population will be ploted, and if
% the best solution found so far will be mark in red too. This best
% solution may be part of the actual population or a special memory, this
% depends of the algorithm.
pso.plotPopulationB = true;
pso.plotBestSolutionB = true;

% Usually the plot of the historic best solution through the prosess is
% required, therefore this is enabled by default. 
pso.plotHistoricB = false;

% Finally this line of code execute the algorithm.
pso.start()

% We can observe the properties of the class when the algorithm is done by:
pso

% Some of the most important are the bestFitness and bestSolution, which
% represent the result of the best solution found, and it's value.
% It's nessesary to remember that all the dimensions are scope between 0
% and 1. This means that each problem fucntion scale each dimensions into
% the correct boundaries. In the benchmarck functions, the second value
% returned is the position scaled, the actual best solution.
[bestFitness, bestSolution] = pso.fitnessFunction(pso.bestSolution)