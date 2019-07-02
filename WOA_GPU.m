classdef WOA_GPU < metaheuristic_gpu
    %WOA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        random_pop_dim = [];
    end
    
    methods
        function self = WOA_GPU(fitnessFunction, noDimensions)
            self.algorithmName = 'WOA';
            if nargin < 1
                return 
            end
            self.fitnessFunction = fitnessFunction;
            self.noDimensions = noDimensions;
        end
        function operators(self)
            t  = self.actualIteration;
            a  =  2 - t * ((2) / self.maxNoIterations); % a decreases linearly fron 2 to 0 in Eq. (2.3)
            % a2 linearly dicreases from -1 to -2 to calculate t in Eq. (3.12)
            a2 = -1 + t *((-1) / self.maxNoIterations);
            % Update the Position of search agents 
            
            if(size(self.random_pop_dim,1)==0)
                self.random_pop_dim = gpuArray.zeros(self.sizePopulation, self.noDimensions);
                for i = 1:self.noDimensions
                    self.random_pop_dim(:,i) = randperm(self.sizePopulation);
                end
            else
                self.random_pop_dim = self.random_pop_dim(randperm(self.sizePopulation), :);
            end
            
            r1 = gpuArray.rand(1, self.sizePopulation);
            r2 = gpuArray.rand(1, self.sizePopulation);
            A = abs(2 * a * r1 - a);   % Eq. (2.3) in the paper
            A2 = repmat(A', 1,self.noDimensions);
            C = 2 * r2;                     % Eq. (2.4) in the paper
            b = 1;                          % parameters in Eq. (2.5)
            l = (a2-1)*gpuArray.rand(1, self.sizePopulation)+1; % Eq. (2.5)
            l = repmat(exp(b*l') .* cos(l'*2*pi), 1, self.noDimensions);
            p = gpuArray.rand(1, self.sizePopulation) < 0.5; % p in Eq. (2.6)
            
            distance2Leader = abs(self.bestSolution - self.population);
            tial_population = distance2Leader .* l + self.bestSolution; % Eq. (2.5)
            
            X_rand = self.population(self.random_pop_dim);
            D_X_rand = abs(C * X_rand - self.population);
            A_population = X_rand - A2 .* D_X_rand;
            
            D_Leader = abs(C' * self.bestSolution - self.population);
            nonA_population = self.bestSolution - A2 .* D_Leader;
            
            A_population(abs(A)<1, :) = nonA_population(abs(A)<1, :);
            
            tial_population(p, :) = A_population(p, :);
            
            self.population = self.checkBoundsToroidal(tial_population);
            self.evalPopulation();
            self.updateBest();
        end
    end
    
end

