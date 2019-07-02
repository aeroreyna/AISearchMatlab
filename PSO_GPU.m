classdef PSO_GPU < metaheuristic_gpu
    %PSO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        velocity = []
        bestPersonal = []  % [fitness, solutions]
        velocityParam = 0.97;
        bestPersonalParam = 0.4;
        bestParam = 0.5;
    end
    
    methods
        function self = PSO_GPU(fitnessFunction, noDimensions)
            self.algorithmName = 'PSO';
            if nargin < 1
                return 
            end
            self.fitnessFunction = fitnessFunction;
            self.noDimensions = noDimensions;
        end
        
        function operators(self)
            if size(self.velocity,1)==0
                self.velocity = gpuArray.zeros(self.sizePopulation, self.noDimensions);
            end
            if size(self.bestPersonal)==0
                self.bestPersonal = [self.fitness, self.population];
            end
            % atraction to the best personal solution
            pbAtraction = gpuArray.rand(self.sizePopulation,self.noDimensions) .* ...
                (self.bestPersonal(:,2:end)-self.population);
            
            % atraction to the best global solution
            bestAtraction = gpuArray.rand(self.sizePopulation,self.noDimensions) .* ...
                (repmat(self.bestSolution, self.sizePopulation, 1) - self.population);
            
            % update velocity trayectories.
            self.velocity = self.velocityParam * self.velocity + ...
                    self.bestPersonalParam * pbAtraction + ...
                    self.bestParam * bestAtraction;
            
            % update solutions
            self.population = self.population + self.velocity;
            self.checkBoundsToroidal();
            
            % eval fitness
            self.evalPopulation();
            tempIndx = self.updateBestPersonal();
        end
        
        function temp = updateBestPersonal(self)
            temp = self.bestPersonal(:,1) > self.fitness;
            self.bestPersonal(temp,:) = [self.fitness(temp), ...
                                        self.population(temp,:)];
            self.improvementsCount = self.improvementsCount + sum(temp);
        end
    end
    
end

