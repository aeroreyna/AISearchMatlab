clear, clc
NoItems = 300;
range = 50;
maxW = range / 10 * NoItems ;
k = knapsack(NoItems,range,maxW);
AISearch = GA(@k.fitness,NoItems);
AISearch.sizePopulation = 100;
AISearch.maxNoIterations = 500;

AISearch.start()
AISearch.bestSolution
AISearch.bestFitness
[price, weight] = k.testValues(AISearch.bestSolution)
AISearch.plot()