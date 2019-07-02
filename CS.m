classdef CS < metaheuristic
    %CS Cuckoo Search Algorithm
    %   Detailed explanation goes here

    properties
        emptyNestRate = 0.4;
    end

    methods
        function self = CS(fitnessFunction, noDimensions)
            self.algorithmName = 'CS';
            if nargin < 1
                return
            end
            self.fitnessFunction = fitnessFunction;
            self.noDimensions = noDimensions;
        end

%         function operatorsSerial(self)
%             beta=3/2;
%             sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
% 
%             newPop = zeros(size(self.population));
%             %Lev� flight
%             for i=1:self.sizePopulation
%                 s = self.population(i,:);
%                 u = randn(size(s))*sigma;
%                 v = randn(size(s));
%                 step = u./abs(v).^(1/beta);
%                 stepsize = 0.01 * step .*(s - self.bestSolution);
%                 s = s + stepsize .* randn(size(s));
%                 newPop(i,:) = s;
%             end
%             newPop = self.checkBoundsToroidal(newPop);
%             self.remplacePopulation(newPop);
% 
%             % A fraction of worse nests are discovered with a probability pa
%             % Discovered or not -- a status vector
%             K=rand(size(self.population)) > self.emptyNestRate;
% 
%             stepsize = rand * (self.population(randperm(self.sizePopulation),:)-...
%                                self.population(randperm(self.sizePopulation),:));
%             newPop = self.population + stepsize.*K;
%             newPop = self.checkBoundsToroidal(newPop);
%             self.remplacePopulation(newPop);
%         end

        function operators(self)
            beta = 1.5;
            sigma = 0.6966;
            u = rand(self.sizePopulation, self.noDimensions) * sigma;
            v = abs(rand(self.sizePopulation, self.noDimensions)).^1/beta;
            steep = u ./ v;
            steep_size = 0.01 * steep .* (self.population - self.bestSolutionArray());
            trial_population = self.population + steep_size .* rand(self.sizePopulation, self.noDimensions);
            trial_population = self.checkBoundsToroidal(trial_population);
            self.remplacePopulation(trial_population);


            nest_mask = rand(self.sizePopulation,1) > self.emptyNestRate;
            nests = self.population(nest_mask, :);
            nests_fit = self.fitness(nest_mask);
            random_1_solutions = self.getShuffledPopulation();
            random_1_solutions = random_1_solutions(nest_mask, :);
            random_2_solutions = self.getShuffledPopulation();
            random_2_solutions = random_2_solutions(nest_mask, :);
            trial_population = nests + rand(sum(nest_mask), self.noDimensions) .* (random_1_solutions - random_2_solutions);
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
