clear, clc
AISearch = DE(@schwefel,2);
AISearch.sizePopulation = 30;
AISearch.maxNoIterations = 100;
%AISearch.graph2d();
AISearch.plotEachIterationB = false;
AISearch.plotHistoricB = false;
AISearch.plotPopulationB = true;
AISearch.plotBestSolutionB = true;

AISearch.start()
AISearch.bestSolution
AISearch.bestFitness
AISearch.plot()
AISearch.plotHistoricSolutions()
AISearch