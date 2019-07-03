clear, clc

addpath('realBenchmarkProblems')

%benchmarkF = {@ackley, @branins, @griewangk, @jongs, @langermann, @michalewicz, @rastrigin, @rosenbrock, @rysunek, @schwefel};
%AIs = {@DE, @PSO, @SMS, @WOA, @CS,  @HS};

tic
AISearch = PSO(@schwefel,10);
AISearch.sizePopulation = 10000;
AISearch.maxNoIterations = 1000;
%AISearch.graph2d();
AISearch.plotEachIterationB = false;
AISearch.plotHistoricB = true;
AISearch.plotPopulationB = false;
AISearch.plotBestSolutionB = false;

AISearch.start()
AISearch.bestSolution
AISearch.bestFitness
toc
AISearch.plot()

tic
AISearch = PSO_GPU(@schwefel,10);
AISearch.sizePopulation = 10000;
AISearch.maxNoIterations = 1000;
%AISearch.graph2d();
AISearch.plotEachIterationB = false;
AISearch.plotHistoricB = true;
AISearch.plotPopulationB = false;
AISearch.plotBestSolutionB = false;

AISearch.start()
AISearch.bestSolution
AISearch.bestFitness
toc
hold on
AISearch.plot()