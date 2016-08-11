clear, clc
AISearch = MSMS(@Rastrigin,2);
AISearch.sizePopulation = 50;
AISearch.maxNoIterations = 100;
%AISearch.graph2d();
AISearch.plotEachIterationB = true;
AISearch.plotHistoricB = false;
AISearch.plotPopulationB = true;
AISearch.plotBestSolutionB = true;

AISearch.start()
AISearch.bestSolution
AISearch.bestFitness
AISearch.plot()