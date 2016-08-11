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
        worstFitness = -inf;
        fitnessFunction;
        numberOfFunctionCalls = 0;
        maxNoIterations = 100;
        actualIteration = 0;
    end
    
    %this properties are for data visualization
    properties
        historicBestSolution = [];  %Keeps track of best solutions
        historicBestFitness = [];   %Keeps track of best fitness
        eachIterationFunction;      %If defined, it's called at the end of each iteration
        customPlotFunction;         %If defined, it's called instead of default plot function
        plotEachIterationB = false; %Refresh plot at each iteration
        plotPopulationB    = false; %Plot the actual population
        plotBestSolutionB  = false; %Plot the actual best solution
        plotHistoricB      = true;  %Plot the historic record
        X;                          %Stores the plot data X
        Y;                          %Stores the plot data Y
        Z;                          %Stores the plot data Z
        handleHistoricPlot;
        handlePopulationPlot;
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
                %data visualization
                if obj.plotEachIterationB == true
                    if size(obj.customPlotFunction,1)~=0
                        obj.customPlotFunction(obj);
                    else
                        obj.plot();
                    end
                end
                if size(obj.eachIterationFunction,1)~=0
                    obj.eachIterationFunction(obj);
                end
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
        function updateWorst(obj)
            % update the best know so far solution and it's fitness.
            [worstFitTemp, ~] = max(obj.fitness);
            if worstFitTemp > obj.worstFitness
                obj.worstFitness = worstFitTemp;
            end
        end
        
        function plot(obj)
            if obj.plotHistoricB == true
                if size(obj.handleHistoricPlot,1) == 0
                    obj.handleHistoricPlot = figure;
                end
                figure(obj.handleHistoricPlot.Number);
                hold off
                plot(obj.historicBestFitness);
            end
            if obj.plotPopulationB == true
                if size(obj.handlePopulationPlot,1) == 0
                    obj.handlePopulationPlot = figure;
                end
                figure(obj.handlePopulationPlot.Number);
                hold off
                obj.graph2d()
                hold on
                obj.plotSolutions(obj.population);
            end
            if obj.plotBestSolutionB == true
                if size(obj.handlePopulationPlot,1) == 0
                    obj.handlePopulationPlot = figure;
                    obj.graph2d()
                    hold on
                end
                obj.plotSolutions(obj.bestSolution,'or');
            end
            drawnow
        end
        
        function plotSolutions(~, solutions, properties)
            if size(solutions,2) == 1
                error('only two dimensions are allow to plot')
            end
            if size(solutions,2) > 2 
                solutions = solutions(:,1:2);
            end
            if nargin == 2
                properties='ob';
            end
            for i=1:size(solutions,1)
                plot(solutions(i,1),solutions(i,2),properties);
            end
        end
        
        function [X,Y,Z] = getGraphData(obj, fitnessFunc)
            if size(obj.X,1) == 0 || size(obj.Y,1) == 0 || size(obj.Z,1) == 0
                x=0:1/50:1;
                y=x;
                [X,Y]=meshgrid(x,y);
                [row,col]=size(X);
                Z = zeros(row,col);
                for l=1:col
                    for h=1:row
                        Z(h,l)=fitnessFunc([X(h,l),Y(h,l)]);
                    end
                end
                obj.X = X;
                obj.Y = Y;
                obj.Z = Z;
            else
                X = obj.X;
                Y = obj.Y;
                Z = obj.Z;
            end
        end
        
        function graph3d(obj,fitnessFunc)
            if nargin == 1
                if size(obj.fitnessFunction,1) == 0
                    error('Fitness function is empty');
                end
                fitnessFunc = obj.fitnessFunction;
            end
            [x,y,z] = obj.getGraphData(fitnessFunc);
            mesh(x,y,z);
        end
        
        function graph2d(obj,fitnessFunc)
            if nargin == 1
                if size(obj.fitnessFunction,1) == 0
                    error('Fitness function is empty');
                end
                fitnessFunc = obj.fitnessFunction;
            end
            [x,y,z] = obj.getGraphData(fitnessFunc);
            contour(x,y,z,5);
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

