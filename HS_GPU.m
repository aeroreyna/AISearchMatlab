classdef HS_GPU < metaheuristic_gpu
    %HS Harmony Search of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Default Parameters [0.9, 0.5, 0.01] 10.1016/j.protcy.2012.10.032
        newMelodyRate = 0.9;
        pitchAdjustRate = 0.5;
        stepAdjust = 0.01;
    end
    
    methods
        function self = HS_GPU(fitnessFunction, noDimensions)
            self.algorithmName = 'HS';
            if nargin < 1
                return 
            end
            self.fitnessFunction = fitnessFunction;
            self.noDimensions = noDimensions;
        end
        
        function operators(self)
            trial_population = gpuArray.rand(self.sizePopulation, self.noDimensions);
            new_melody_probability = gpuArray.rand(self.sizePopulation, self.noDimensions);
            pitch_adjust_probability = gpuArray.rand(self.sizePopulation, self.noDimensions);
            pitch_adjustments = gpuArray.rand(self.sizePopulation, self.noDimensions) * self.stepAdjust;
            
            knwon_melodies = self.getShuffledPopulation();
            
            trial_population(new_melody_probability < self.newMelodyRate) = knwon_melodies(new_melody_probability < self.newMelodyRate);
            trial_population(pitch_adjust_probability < self.pitchAdjustRate) = pitch_adjustments(pitch_adjust_probability < self.pitchAdjustRate);
            trial_population = self.checkBoundsToroidal(trial_population);
            
            trial_fitnesses = self.evalPopulation(trial_population);
            
            %keep the best
            self.population = [self.population; trial_population];
            self.fitness = [self.fitness; trial_fitnesses];
            self.sortPopulation()
            self.population = self.population(1:self.sizePopulation, :);
            self.fitness = self.fitness(1:self.sizePopulation);
        end
    end
    
end

