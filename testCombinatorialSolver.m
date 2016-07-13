clear, clc
NoItems = 30;
k = knapsack(NoItems,50,70);
AISearch = GA(@k.fitness,NoItems);
AISearch.sizePopulation = 50;
AISearch.maxNoIterations = 100;

AISearch.start()
AISearch.bestSolution
AISearch.bestFitness
[price, weight] = k.testValues(AISearch.bestSolution)
AISearch.plot()