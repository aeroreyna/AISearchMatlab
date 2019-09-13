classdef metaheuristic < handle
    % Metaheursitic Algorithms by aeroreyna
    % This implementation always considers a minimization problems
    % and that all the variables have a range [0-1], the proper
    % adjustments has to be done in the fitness function.
    
    properties
        sizePopulation = 30;
        noDimensions = 1;
        population = [];            %size = (sizePop, NoDim)
        fitness = [];               %size = (sizePop, 1)
        bestSolution = [];
        bestFitness = inf;
        worstFitness = -inf;
        worstSolution = [];
        fitnessFunction;
        numberOfFunctionCalls = 0;
        maxNoIterations = 100;
        actualIteration = 0;
        initialSolutions = [];
        stripFitnessCalls = false;
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
        improvementsCount = 0;
        bestSolutionChanges = 0;    %No of improvements 
        bestSolutionImprovers = [];  %Record of improvers
        saveRecordOnline = false;
        algorithmName = 'Unregistered';
    end
    
    properties (Access = private)
        onlineObj = 0
    end
    
    methods (Abstract)
        operators(self)
    end
    
    methods
        function self = metaheuristic(fitnessFunction, noDimensions)
            if nargin < 1
                return 
            end
            self.fitnessFunction = fitnessFunction;
            self.noDimensions = noDimensions;
            self.numberOfFunctionCalls=0;
        end
        
        function bestSolution = start(self)
            if size(self.fitnessFunction,1) == 0
                error('There is no fitness function attached to this process');
            end
            if size(self.population,1) == 0
                self.initialPopulation();
                self.evalPopulation();
            end
            if size(self.fitness,1) == 0
                self.evalPopulation();
            end
            
            self.historicBestSolution = zeros(self.maxNoIterations, self.noDimensions);
            self.historicBestFitness = zeros(self.maxNoIterations, 1);
            self.updateBest();
            
            for i=1:self.maxNoIterations
                self.actualIteration = i;
                self.operators();
                self.updateBest();
                self.historicBestSolution(i,:) = self.bestSolution;
                self.historicBestFitness(i,:) = self.bestFitness;
                %data visualization
                %disp(i)
                if self.plotEachIterationB == true
                    if size(self.customPlotFunction,1)~=0
                        self.customPlotFunction(self);
                    else
                        self.plot();
                    end
                end
                if size(self.eachIterationFunction,1)~=0
                    self.eachIterationFunction(self);
                end
            end
            %Returns the best solution with proper scale by the FitnessF.
            [~, bestSolution] = self.fitnessFunction(self.bestSolution);
        end
        
        function initialPopulation(self, sizePopulation, noDimensions)
            % Method that start a new random population, it could use the
            % selfect propierties, or well assing new properties of
            % population size and/or number of dimensions.
            if nargin == 1
                sizePopulation = self.sizePopulation;
                noDimensions = self.noDimensions;
            elseif nargin == 2
                self.sizePopulation = sizePopulation;
                noDimensions = self.noDimensions;
            else
                self.sizePopulation = sizePopulation;
                self.noDimensions = noDimensions;
            end
            self.population = rand(sizePopulation, noDimensions);
            if size(self.initialSolutions,1) ~= 0
                if size(self.initialSolutions,2) ~= self.noDimensions || size(self.initialSolutions,1) > self.sizePopulation
                    error('Initial custom population do not have the right dimensions');
                end
                self.population(1:size(self.initialSolutions,1),:) = self.initialSolutions;
            end
        end
        
        function fit = evalPopulation(self, population)
            % This method evual the fitness of the population, or well the
            % solution pass thorught the argument. If no argument it send
            % then the fitness of all the population is store in the
            % fitness propertie of this selfect.
            if nargin == 1
                population = self.population;
            end
            if self.stripFitnessCalls
                fit = zeros(size(population,1),1);
                for i=1:size(population,1)
                    fit(i) = self.fitnessFunction(population(i,:));
                end
            else
                fit = self.fitnessFunction(population);
            end
            if nargin == 1
                self.fitness = fit;
            end
            self.numberOfFunctionCalls=self.numberOfFunctionCalls+size(population,1);
        end
        
        function rp = getShuffledPopulation(self)
            randIndexing = randperm(self.sizePopulation);
            rp = self.population(randIndexing, :);
        end
        
        function bestArray = bestSolutionArray(self)
            bestArray = repmat(self.bestSolution, self.sizePopulation, 1);
        end
        
        function sortPopulation(self)
            % Sort the population using the fitness value, the order is
            % assendent. Sort the fitness array as well.
            temp = sortrows([self.fitness, self.population], 1);
            self.fitness = temp(:,1);
            self.population = temp(:,2:end);
        end
                
        function solutions = checkBounds(self, solutions)
            if nargin == 1
                solutions = self.population;
            end
            solutions(solutions>1)=1;
            solutions(solutions<0)=0;
            if nargin == 1
                self.population = solutions;
            end
        end
        
        function solutions = checkBoundsToroidal(self, solutions)
            if nargin == 1
                solutions = self.population;
            end
            solutions = solutions - floor(solutions);
            if nargin == 1
                self.population = solutions;
            end
        end
        
        function updateBest(self)
            % update the best know so far solution and it's fitness.
            [bestFitTemp, bestIndex] = min(self.fitness);
            if bestFitTemp < self.bestFitness
                self.bestSolution = self.population(bestIndex,:);
                self.bestFitness = bestFitTemp;
                self.bestSolutionChanges = self.bestSolutionChanges + 1;
                self.bestSolutionImprovers = [self.bestSolutionImprovers; self.bestSolution];
            end
        end
        function updateWorst(self)
            % update the best know so far solution and it's fitness.
            [worstFitTemp, bestIndex] = max(self.fitness);
            if worstFitTemp > self.worstFitness
                self.worstFitness = worstFitTemp;
                self.worstSolution = self.population(bestIndex,:);
            end
        end
        
        function r = diversity(self, solutions)
            %Function that messure the diversity of the population.
            if nargin == 1
                solutions = self.population;
            end
            n = size(solutions,1);
            r = 0;
            for i = 1:n-1
                for j = i+1:n
                    r = r + norm(solutions(i,:)-solutions(j,:));
                end
            end
            r = 2 * r / (n*(n-1));
        end
        
        function plot(self)
            if self.plotHistoricB == true
                if size(self.handleHistoricPlot,1) == 0
                    self.handleHistoricPlot = figure;
                end
                figure(self.handleHistoricPlot.Number);
                hold off
                plot(1:self.actualIteration, self.historicBestFitness(1:self.actualIteration));
            end
            if self.plotPopulationB == true
                if size(self.handlePopulationPlot,1) == 0
                    self.handlePopulationPlot = figure;
                end
                figure(self.handlePopulationPlot.Number);
                hold off
                self.graph2d()
                hold on
                self.plotSolutions(self.population);
            end
            if self.plotBestSolutionB == true
                if size(self.handlePopulationPlot,1) == 0
                    self.handlePopulationPlot = figure;
                    self.graph2d()
                    hold on
                end
                self.plotSolutions(self.bestSolution,'or');
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
            plot(solutions(:,1),solutions(:,2),properties);
        end
        
        function [X,Y,Z] = getGraphData(self, fitnessFunc)
            if size(self.X,1) == 0 || size(self.Y,1) == 0 || size(self.Z,1) == 0
                x=0:1/100:1;
                y=x;
                [X,Y]=meshgrid(x,y);
                [row,col]=size(X);
                Z = zeros(row,col);
                for l=1:col
                    for h=1:row
                        Z(h,l)=fitnessFunc([X(h,l),Y(h,l)]);
                    end
                end
                self.X = X;
                self.Y = Y;
                self.Z = Z;
            else
                X = self.X;
                Y = self.Y;
                Z = self.Z;
            end
        end
        
        function graph3d(self,fitnessFunc)
            if nargin == 1
                if size(self.fitnessFunction,1) == 0
                    error('Fitness function is empty');
                end
                fitnessFunc = self.fitnessFunction;
            end
            [x,y,z] = self.getGraphData(fitnessFunc);
            mesh(x,y,z);
        end
        
        function graph2d(self,fitnessFunc)
            if nargin == 1
                if size(self.fitnessFunction,1) == 0
                    error('Fitness function is empty');
                end
                fitnessFunc = self.fitnessFunction;
            end
            [x,y,z] = self.getGraphData(fitnessFunc);
            contour(x,y,z,4);
        end
        
        function plotHistoricSolutions(self)
            figure
            self.graph2d();
            hold on;
            self.plotSolutions(self.historicBestSolution)
            self.plotSolutions(self.historicBestSolution, '')
        end

    end    
end

