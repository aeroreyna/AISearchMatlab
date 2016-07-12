clear, clc
AISearch = HS(@schwefel,2);
AISearch.sizePopulation = 30;
AISearch.maxNoIterations = 100;

AISearch.start()
AISearch.bestSolution
AISearch.bestFitness
AISearch.plot()