classdef metaheuristic < handle
    %METAHEURISTIC by aeroreyna, made with <3 & science
    %   Detailed explanation goes here
    % always goes to minimization
    
    properties
        sizePopulation = 30;
        noDimensions = 1;
        population = [];            %size = (sizePop, NoDim)
        fitness = [];               %size = (sizePop, 1)
        bestSolution = [];
        bestFitness = [];
        fitnessFunction;
        numberOfFunctionCalls = 0;
    end
    
    %this properties are for data visualization
    properties
        historicBestSolution = [];
        historicBestFitness = [];
        eachIterationFunction;
        customPlotFunction;
    end
    
    methods
        function obj = metaheuristic(fitnessFunction, noDimensions)
            if nargin < 1
                return 
            end
            obj.fitnessFunction = fitnessFunction;
            obj.noDimensions = noDimensions;
        end
        function initialPopulation(obj, sizePopulation, noDimensions)
            if nargin == 1
                sizePopulation = obj.sizePopulation;
                noDimensions = obj.noDimensions;
            elseif nargin == 2
                obj.sizePopulation = sizePopulation;
                noDimensions = obj.noDimensions;
            else
                obj.sizePopulation = sizePopulation;
                obj.noDimensions = noDimensions;
            end
            obj.population = rand(sizePopulation, noDimensions);
        end
        function evalPopulation(obj, population)
            if nargin == 1
                population = obj.population;
            end
            fit = zeros(1,size(population,1));
            for i=1:size(population,1)
                fit(i) = obj.fitnessFunction(population(i,:));
            end
            obj.fitness = fit;
        end
        function sortPopulatin(obj)
            temp = sortrows([obj.fitness, obj.population], 1);
            obj.fitness = temp(:,1);
            obj.population = temp(:,2:end);
        end
        function updateBest(obj)
            [bestFitTemp, bestIndex] = min(obj.fitness);
            if bestFitTemp < obj.bestFitness
                obj.bestSolution = obj.population(bestIndex,:);
                obj.bestFitness = bestFitTemp;
            end
        end
    end
    
end

