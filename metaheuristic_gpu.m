classdef metaheuristic_gpu < metaheuristic
    % Metaheursitic Algorithms by aeroreyna
    % This implementation always considers a minimization problems
    % and that all the variables have a range [0-1], the proper
    % adjustments has to be done in the fitness function.
    
    methods
        
        function start(self)
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
            
            self.historicBestSolution = gpuArray.zeros(self.maxNoIterations, self.noDimensions);
            self.historicBestFitness = gpuArray.zeros(self.maxNoIterations, 1);
            self.updateBest();
            
            for i=1:self.maxNoIterations
                self.actualIteration = i;
                self.operators();
                self.updateBest();
                self.historicBestSolution(i,:) = self.bestSolution;
                self.historicBestFitness(i,:) = self.bestFitness;
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
            if self.saveRecordOnline
                self.uploadRecord();
            end
        end
        
        function initialPopulation(self, sizePopulation, noDimensions)
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
            self.population = gpuArray.rand(sizePopulation, noDimensions);
            if size(self.initialSolutions,1) ~= 0
                if size(self.initialSolutions,2) ~= self.noDimensions || size(self.initialSolutions,1) > self.sizePopulation
                    error('Initial custom population do not have the right dimensions');
                end
                self.population(1:size(self.initialSolutions,1),:) = self.initialSolutions;
            end
        end
        
        function fit = evalPopulation(self, population)
            if nargin == 1
                population = self.population;
            end
            fit = self.fitnessFunction(population);
            if nargin == 1
                self.fitness = fit;
            end
            self.numberOfFunctionCalls=self.numberOfFunctionCalls+size(population,1);
        end
        
        function rp = getShuffledPopulation(self)
            randIndexing = gpuArray.randperm(self.sizePopulation);
            rp = self.population(randIndexing, :);
        end

    end
    
end

