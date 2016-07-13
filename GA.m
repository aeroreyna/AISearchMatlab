classdef GA < combinatorialSolver
    %GA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        crossoverRate = 0.9;
        mutationRate = 0.05;
    end
    
    methods
        function obj = GA(fitnessFunction, noDimensions)
            if nargin < 1
                return 
            end
            obj.fitnessFunction = fitnessFunction;
            obj.noDimensions = noDimensions;
        end
        function operators(obj)
            %select
            parents = zeros(obj.sizePopulation,1);
            for i = 1:obj.sizePopulation
                parents(i) = obj.tournament();
            end
            
            %crossover
            newPop = zeros(size(obj.population));
            for i = 1:floor(obj.sizePopulation/2)
                parent1 = obj.population(parents((i-1)*2+1),:);
                parent2 = obj.population(parents((i-1)*2+2),:);
                [child1, child2] = crossoverRandi(obj, parent1, parent2);
                newPop((i-1)*2+1,:) = child1;
                newPop((i-1)*2+2,:) = child2;
            end
            
            %mutation
            for i = 1:floor(obj.sizePopulation/2)
                for j = 1:obj.noDimensions
                    if rand < obj.mutationRate
                        newPop(i,j) = randi(obj.rangePerDimension);
                    end
                end
            end
            
            %remplace
            tempFit = obj.evalPopulation(newPop);
            obj.population = [obj.population; newPop];
            obj.fitness = [obj.fitness; tempFit];
            obj.sortPopulation()
            obj.population = obj.population(1:obj.sizePopulation,:);
            obj.fitness = obj.fitness(1:obj.sizePopulation);
        end
        function index = tournament(obj)
            temp = randi(obj.sizePopulation,1,2);
            if obj.fitness(temp(1))<obj.fitness(temp(2))
                index = temp(1);
            else
                index = temp(2);
            end
        end
        function [child1, child2] = crossover(obj, parent1, parent2)
            if rand < obj.crossoverRate
                crosI = randi(obj.noDimensions-2)+1;
                child1 = [parent1(1:crosI), parent2(crosI+1:end)];
                child2 = [parent2(1:crosI), parent1(crosI+1:end)];
            else
                child1 = parent1;
                child2 = parent2;
            end
        end
        function [child1, child2] = crossoverRandi(obj, parent1, parent2)
            if rand < obj.crossoverRate
                 temp = randi([0,1],1,obj.noDimensions)==1;
                 child1 = parent1;
                 child1(temp) = parent2(temp);
                 child2 = parent2;
                 child2(temp) = parent1(temp);
            else
                child1 = parent1;
                child2 = parent2;
            end
        end
    end
    
end