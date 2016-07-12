classdef CS < metaheuristic
    %CS Cuckoo Search Algorithm
    %   Detailed explanation goes here
    
    properties
        emptyNestRate = 0.4;
    end
    
    methods
        function obj = CS(fitnessFunction, noDimensions)
            if nargin < 1
                return 
            end
            obj.fitnessFunction = fitnessFunction;
            obj.noDimensions = noDimensions;
        end
        
        function operators(obj)
            beta=3/2;
            sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
            
            newPop = zeros(size(obj.population));
            %Leví flight
            for i=1:obj.sizePopulation
                s = obj.population(i,:);
                u = randn(size(s))*sigma;
                v = randn(size(s));
                step = u./abs(v).^(1/beta);    
                stepsize = 0.01 * step .*(s - obj.bestSolution);
                s = s + stepsize .* randn(size(s));
                newPop(i,:) = s;
            end
            newPop = obj.checkBounds(newPop);
            obj.remplacePopulation(newPop);
            
            % A fraction of worse nests are discovered with a probability pa
            % Discovered or not -- a status vector
            K=rand(size(obj.population)) > obj.emptyNestRate;

            stepsize = rand * (obj.population(randperm(obj.sizePopulation),:)-...
                               obj.population(randperm(obj.sizePopulation),:));
            newPop = obj.population + stepsize.*K;
            newPop = obj.checkBounds(newPop);
            obj.remplacePopulation(newPop);
        end
        
        function remplacePopulation(obj, newPop)
            tempFit = obj.evalPopulation(newPop);
            temp = tempFit < obj.fitness;
            obj.fitness(temp) = tempFit(temp);
            obj.population(temp,:) = newPop(temp,:);
            obj.updateBest()
        end

    end
    
end

