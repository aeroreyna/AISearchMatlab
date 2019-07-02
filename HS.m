classdef HS < metaheuristic
    %HS Harmony Search of this class goes here
    %   Detailed explanation goes here

    properties
        newMelodyRate = 0.3;
        pitchAdjustRate = 0.5;
        stepAdjust = 0.01;
    end

    methods
        function obj = HS(fitnessFunction, noDimensions)
            obj.algorithmName = 'HS';
            if nargin < 1
                return
            end
            obj.fitnessFunction = fitnessFunction;
            obj.noDimensions = noDimensions;
        end

%         function operators(obj) %Serial Implementation
%             for i = 1:obj.sizePopulation
%                 newSolution = zeros(1,obj.noDimensions);
%                 for j = 1:obj.noDimensions
%                     if obj.newMelodyRate < rand
%                         newSolution(j)=rand; %random
%                     else
%                         a = randi(obj.sizePopulation);
%                         newSolution(j)=obj.population(a,j); %memory armony
%                         if obj.pitchAdjustRate < rand %pitch asjustment
%                             newSolution(j) = newSolution(j) + obj.stepAdjust * randn;
%                         end
%                     end
%                 end
%                 newSolution = obj.checkBounds(newSolution);
%                 tempFit = obj.evalPopulation(newSolution);
%                 if tempFit < obj.fitness(end)
%                     obj.fitness(end) = tempFit;
%                     obj.population(end,:) = newSolution;
%                 end
%                 obj.sortPopulation();
%             end
%         end

        function operators(self) %Vectorizeted Implementation
            trial_population = rand(self.sizePopulation, self.noDimensions);
            new_melody_probability = rand(self.sizePopulation, self.noDimensions);
            pitch_adjust_probability = rand(self.sizePopulation, self.noDimensions);
            pitch_adjustments = rand(self.sizePopulation, self.noDimensions) * self.stepAdjust;

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
