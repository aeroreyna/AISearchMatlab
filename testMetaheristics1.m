clear, clc
AISearch = SMS(@schwefel,10);
AISearch.sizePopulation = 100;
AISearch.maxNoIterations = 500;

AISearch.start()
AISearch.bestSolution
AISearch.bestFitness
AISearch.plot()