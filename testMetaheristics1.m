clear, clc
AISearch = DE(@Rastrigin,30);
AISearch.sizePopulation = 500;
AISearch.maxNoIterations = 1000;
%AISearch.graph2d();
AISearch.plotEachIterationB = false;
AISearch.plotHistoricB = false;
AISearch.plotPopulationB = true;
AISearch.plotBestSolutionB = true;

AISearch.start()
AISearch.bestSolution
AISearch.bestFitness
AISearch.plot()