clear, clc


for i=1:30
AISearch = HS(@rastrigin,30);
AISearch.sizePopulation = 100;
AISearch.maxNoIterations = 500;
%AISearch.graph2d();
AISearch.plotEachIterationB = false;
AISearch.plotHistoricB = true;
AISearch.plotPopulationB = true;
AISearch.plotBestSolutionB = false;
AISearch.saveRecordOnline = false;

AISearch.start()
AISearch.bestSolution
AISearch.bestFitness
%AISearch.plot()
%AISearch.plotHistoricSolutions()
%AISearch
end