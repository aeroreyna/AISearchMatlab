classdef CS_GPU < metaheuristic_gpu
    %CS Cuckoo Search Algorithm
    %   Detailed explanation goes here
    
    properties
        emptyNestRate = 0.4;
    end
    
    methods
        function self = CS_GPU(fitnessFunction, noDimensions)
            self.algorithmName = 'CS';
            if nargin < 1
                return 
            end
            self.fitnessFunction = fitnessFunction;
            self.noDimensions = noDimensions;
        end
        
        function operators(self)
            beta = 1.5;
            sigma = 0.6966;
            u = gpuArray.rand(self.sizePopulation, self.noDimensions) * sigma;
            v = abs(gpuArray.rand(self.sizePopulation, self.noDimensions)).^1/beta;
            steep = u ./ v;
            steep_size = 0.01 * steep .* (self.population - self.bestSolutionArray());
            trial_population = self.population + steep_size .* gpuArray.rand(self.sizePopulation, self.noDimensions);
            trial_population = self.checkBoundsToroidal(trial_population);
            self.remplacePopulation(trial_population);
            
            
            nest_mask = gpuArray.rand(self.sizePopulation,1) > self.emptyNestRate;
            nests = self.population(nest_mask, :);
            nests_fit = self.fitness(nest_mask);
            random_1_solutions = self.getShuffledPopulation();
            random_1_solutions = random_1_solutions(nest_mask, :);
            random_2_solutions = self.getShuffledPopulation();
            random_2_solutions = random_2_solutions(nest_mask, :);
            trial_population = nests + gpuArray.rand(sum(nest_mask), self.noDimensions) .* (random_1_solutions - random_2_solutions);
            trial_population = self.checkBoundsToroidal(trial_population);
            tempFit = self.evalPopulation(trial_population);
            tempInx = nests_fit > tempFit;
            
            nests(tempInx,:) = trial_population(tempInx,:);
            nests_fit(tempInx) = tempFit(tempInx);
            
            self.fitness(nest_mask) = nests_fit;
            self.population(nest_mask,:) = nests;
        end
        
        function remplacePopulation(self, newPop)
            tempFit = self.evalPopulation(newPop);
            temp = tempFit < self.fitness;
            self.fitness(temp) = tempFit(temp);
            self.population(temp,:) = newPop(temp,:);
            self.updateBest()
        end

    end
    
end

