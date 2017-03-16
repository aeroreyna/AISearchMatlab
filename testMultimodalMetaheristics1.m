clear, clc

AISearch = MSMS(@DeJongs5,2);
AISearch.sizePopulation = 100;
AISearch.maxNoIterations = 500;
AISearch.plotEachIterationB = false;
AISearch.plotHistoricB = false;
AISearch.plotPopulationB = true;
AISearch.plotBestSolutionB = false;
MO = multimodalOptimization(AISearch);
AISearch.eachIterationFunction = @MO.diversity;

AISearch.start()
AISearch.bestSolution
AISearch.bestFitness
AISearch.cleanMemory()
AISearch.numberOfFunctionCalls
AISearch.memory
AISearch.plot()
MO.plotDiversity()