clear, clc
AISearch = WOA(@schwefel,50);
AISearch.sizePopulation = 300;
AISearch.maxNoIterations = 1000;
%AISearch.graph2d();
AISearch.plotEachIterationB = false;
AISearch.plotHistoricB = true;
AISearch.plotPopulationB = false;
AISearch.plotBestSolutionB = false;

AISearch.start()
AISearch.bestSolution
AISearch.bestFitness
AISearch.plot()
%AISearch.plotHistoricSolutions()
%AISearch