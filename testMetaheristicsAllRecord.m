clear, clc
benchmarkF = {@ackley, @branins, @griewangk, @jongs, @langermann, @michalewicz, @rastrigin, @rosenbrock, @rysunek, @schwefel};
%AIs = {@DE, @PSO, @SMS, @WOA, @CS,  @HS};
AIs = {@DA};

for b = 1:size(benchmarkF,2)
    benchmarkF{b}
    for ai = 1:size(AIs,2)
        AIs{ai}
        for i = 1:10
            AISearch = AIs{ai}(benchmarkF{b},10);
            AISearch.sizePopulation = 100;
            AISearch.maxNoIterations = 500;
            %AISearch.graph2d();
            AISearch.plotEachIterationB = false;
            AISearch.plotHistoricB = true;
            AISearch.plotPopulationB = true;
            AISearch.plotBestSolutionB = false;
            AISearch.saveRecordOnline = true;

            AISearch.start()
            %AISearch.bestSolution
            [i AISearch.bestFitness]
            %AISearch.plot()
            %AISearch.plotHistoricSolutions()
            %AISearch
        end
    end
end