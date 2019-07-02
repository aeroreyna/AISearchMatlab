classdef DE_GPU < metaheuristic_gpu
    %DE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        crossoverRate = 0.7;
        diferrentialWeight = 0.5;
    end
    
    methods
        function self = DE_GPU(fitnessFunction, noDimensions)
            self.algorithmName = 'DE';
            if nargin < 1
                return 
            end
            self.fitnessFunction = fitnessFunction;
            self.noDimensions = noDimensions;
        end
        
        function operators(self)
            % DE implementation.
            %randomTrio1 = reshape(self.getShuffledPopulation(), [], 3, self.noDimensions);
            %randomTrio2 = reshape(self.getShuffledPopulation(), [], 3, self.noDimensions);
            %randomTrio3 = reshape(self.getShuffledPopulation(), [], 3, self.noDimensions);
            %mutationTrios = [randomTrio1; randomTrio2; randomTrio3];
            %vector1 = squeeze(mutationTrios(:,1,:));
            %vector2 = squeeze(mutationTrios(:,2,:));
            %vector3 = squeeze(mutationTrios(:,3,:));
            
            vector1 = self.getShuffledPopulation();
            vector2 = self.getShuffledPopulation();
            vector3 = self.getShuffledPopulation();
            
            trial_population = self.population * 1;
            doners = vector1 + self.diferrentialWeight * (vector2 - vector3);
            crossoverProbs = gpuArray.rand(self.sizePopulation, self.noDimensions);
            trial_population(crossoverProbs < self.crossoverRate) = doners(crossoverProbs < self.crossoverRate);
            
            trial_population = self.checkBoundsToroidal(trial_population);
            trial_fitnesses = self.evalPopulation(trial_population);
            
            self.population(self.fitness > trial_fitnesses, :) = trial_population(self.fitness > trial_fitnesses, :);
            self.fitness(self.fitness > trial_fitnesses) = trial_fitnesses(self.fitness > trial_fitnesses);
        end
    end
    
end

