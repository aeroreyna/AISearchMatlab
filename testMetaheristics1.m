clear, clc
AISearch = CS(@schwefel,10);
AISearch.sizePopulation = 70;
AISearch.maxNoIterations = 1000;

AISearch.start()
AISearch.bestSolution
AISearch.bestFitness
AISearch.plot()