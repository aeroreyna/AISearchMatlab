classdef WOA < metaheuristic
    %WOA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        random_pop_dim = [];
    end
    
    methods
        function obj = WOA(fitnessFunction, noDimensions)
            obj.algorithmName = 'WOA';
            if nargin < 1
                return 
            end
            obj.fitnessFunction = fitnessFunction;
            obj.noDimensions = noDimensions;
        end
%         function operators(obj) %Serial Implementation from the Author
%             t  = obj.actualIteration;
%             a  =  2 - t * ((2) / obj.maxNoIterations); % a decreases linearly fron 2 to 0 in Eq. (2.3)
%             % a2 linearly dicreases from -1 to -2 to calculate t in Eq. (3.12)
%             a2 = -1 + t *((-1) / obj.maxNoIterations);
%             % Update the Position of search agents 
%             for i = 1:obj.sizePopulation
%                 r1=rand(); % r1 is a random number in [0,1]
%                 r2=rand(); % r2 is a random number in [0,1]
%                 A = 2 * a * r1 - a;  % Eq. (2.3) in the paper
%                 C = 2 * r2;          % Eq. (2.4) in the paper
%                 b = 1;               %  parameters in Eq. (2.5)
%                 l = (a2-1)*rand+1;   %  parameters in Eq. (2.5)
%                 p = rand();          % p in Eq. (2.6)
%                 for j = 1:obj.noDimensions
%                     if p < 0.5   
%                         if abs(A)>=1
%                             %Choose a random solution to be atracted to
%                             rand_leader_index = floor(obj.sizePopulation * rand()+1);
%                             X_rand = obj.population(rand_leader_index, :);
%                             D_X_rand = abs(C * X_rand(j) - obj.population(i,j)); % Eq. (2.7)
%                             obj.population(i,j) = X_rand(j) - A * D_X_rand;      % Eq. (2.8)
%                         elseif abs(A)<1
%                             %The individual is atracted to the bestSolution
%                             D_Leader=abs(C * obj.bestSolution(j) - obj.population(i,j));% Eq. (2.1) _Considero que C debe multiplicar la diferencia_
%                             obj.population(i,j) = obj.bestSolution(j) - A * D_Leader;   % Eq. (2.2)
%                         end
%                     else
%                         distance2Leader = abs(obj.bestSolution(j) - obj.population(i,j));
%                         % Eq. (2.5)
%                         obj.population(i,j) = distance2Leader * exp(b*l) * cos(l*2*pi) + obj.bestSolution(j);
%                     end
%                 end
%             end
%             obj.checkBoundsToroidal();
%             obj.evalPopulation();
%             obj.updateBest();
%         end

        function operators(self)
            t  = self.actualIteration;
            a  =  2 - t * ((2) / self.maxNoIterations); % a decreases linearly fron 2 to 0 in Eq. (2.3)
            % a2 linearly dicreases from -1 to -2 to calculate t in Eq. (3.12)
            a2 = -1 + t *((-1) / self.maxNoIterations);
            % Update the Position of search agents 
            
            if(size(self.random_pop_dim,1)==0)
                self.random_pop_dim = zeros(self.sizePopulation, self.noDimensions);
                for i = 1:self.noDimensions
                    self.random_pop_dim(:,i) = randperm(self.sizePopulation);
                end
            else
                self.random_pop_dim = self.random_pop_dim(randperm(self.sizePopulation), :);
            end
            
            r1 = rand(1, self.sizePopulation);
            r2 = rand(1, self.sizePopulation);
            A = abs(2 * a * r1 - a);   % Eq. (2.3) in the paper
            A2 = repmat(A', 1,self.noDimensions);
            C = 2 * r2;                     % Eq. (2.4) in the paper
            b = 1;                          % parameters in Eq. (2.5)
            l = (a2-1)*rand(1, self.sizePopulation)+1; % Eq. (2.5)
            l = repmat(exp(b*l') .* cos(l'*2*pi), 1, self.noDimensions);
            p = rand(1, self.sizePopulation) < 0.5; % p in Eq. (2.6)
            
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

