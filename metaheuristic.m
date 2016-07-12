classdef metaheuristic < handle
    %METAHEURISTIC by aeroreyna, made with <3 & science
    %   Detailed explanation goes here
    % always goes to minimization
    % consider that all the variables have a range [0-1], adjustments of
    % this has to be done in the fitness function.
    
    properties
        sizePopulation = 30;
        noDimensions = 1;
        population = [];            %size = (sizePop, NoDim)
        fitness = [];               %size = (sizePop, 1)
        bestSolution = [];
        bestFitness = inf;
        fitnessFunction;
        numberOfFunctionCalls = 0;
        maxNoIterations = 100;
        actualIteration = 0;
    end
    
    %this properties are for data visualization
    properties
        historicBestSolution = [];
        historicBestFitness = [];
        eachIterationFunction;
        customPlotFunction;
    end
    
    methods (Abstract)
        operators(obj)
    end
    
    methods
        function obj = metaheuristic(fitnessFunction, noDimensions)
            if nargin < 1
                return 
            end
            obj.fitnessFunction = fitnessFunction;
            obj.noDimensions = noDimensions;
        end
        
        function start(obj)
            if size(obj.fitnessFunction,1) == 0
                error('There is no fitness function attached to this process');
            end
            if size(obj.population,1) == 0
                obj.initialPopulation();
                obj.evalPopulation();
            end
            if size(obj.fitness,1) == 0
                obj.evalPopulation();
            end
            
            obj.historicBestSolution = zeros(obj.maxNoIterations, obj.noDimensions);
            obj.historicBestFitness = zeros(obj.maxNoIterations, 1);
            obj.updateBest();
            
            for i=1:obj.maxNoIterations
                obj.actualIteration = i;
                obj.operators();
                obj.updateBest();
                obj.historicBestSolution(i,:) = obj.bestSolution;
                obj.historicBestFitness(i,:) = obj.bestFitness;
            end
        end
        
        function initialPopulation(obj, sizePopulation, noDimensions)
            % Method that start a new random population, it could use the
            % object propierties, or well assing new properties of
            % population size and/or number of dimensions.
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
        
        function fit = evalPopulation(obj, population)
            % This method evual the fitness of the population, or well the
            % solution pass thorught the argument. If no argument it send
            % then the fitness of all the population is store in the
            % fitness propertie of this object.
            if nargin == 1
                population = obj.population;
            end
            fit = zeros(size(population,1),1);
            for i=1:size(population,1)
                fit(i) = obj.fitnessFunction(population(i,:));
            end
            if nargin == 1
                obj.fitness = fit;
            end
        end
        
        function sortPopulation(obj)
            % Sort the population using the fitness value, the order is
            % assendent. Sort the fitness array as well.
            temp = sortrows([obj.fitness, obj.population], 1);
            obj.fitness = temp(:,1);
            obj.population = temp(:,2:end);
        end
        
        function updateBest(obj)
            % update the best know so far solution and it's fitness.
            [bestFitTemp, bestIndex] = min(obj.fitness);
            if bestFitTemp < obj.bestFitness
                obj.bestSolution = obj.population(bestIndex,:);
                obj.bestFitness = bestFitTemp;
            end
        end
        
        function plot(obj)
            plot(obj.historicBestFitness);
        end
        
        function solutions = checkBounds(obj, solutions)
            if nargin == 1
                solutions = obj.population;
            end
            solutions(solutions>1)=1;
            solutions(solutions<0)=0;
            if nargin == 1
                obj.population = solutions;
            end
        end
    end
    
end

