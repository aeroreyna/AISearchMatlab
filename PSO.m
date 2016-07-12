classdef PSO < metaheuristic
    %PSO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        velocity = []
        bestPersonal = []  % [fitness, solutions]
        velocityParam = 0.9;
        bestPersonalParam = 0.3;
        bestParam = 0.4;
    end
    
    methods
        function obj = PSO(fitnessFunction, noDimensions)
            if nargin < 1
                return 
            end
            obj.fitnessFunction = fitnessFunction;
            obj.noDimensions = noDimensions;
        end
        
        function operators(obj)
            if size(obj.velocity,1)==0
                obj.velocity = zeros(obj.sizePopulation, obj.noDimensions);
            end
            if size(obj.bestPersonal)==0
                obj.bestPersonal = [obj.fitness, obj.population];
            end
            % atraction to the best personal solution
            pbAtraction = rand(obj.sizePopulation,obj.noDimensions) .* ...
                (obj.bestPersonal(:,2:end)-obj.population);
            
            % atraction to the best global solution
            bestAtraction = rand(obj.sizePopulation,obj.noDimensions) .* ...
                (repmat(obj.bestSolution, obj.sizePopulation, 1) - obj.population);
            
            % update velocity trayectories.
            obj.velocity = obj.velocityParam * obj.velocity + ...
                    obj.bestPersonalParam * pbAtraction + ...
                    obj.bestParam * bestAtraction;
            
            % update solutions
            obj.population = obj.population + obj.velocity;
            obj.checkBounds();
            
            % eval fitness
            obj.evalPopulation();
        end
        
        function updateBestPersonal(obj)
            temp = obj.bestPersonal(:,1) < obj.fitness;
            obj.bestPersonal(temp,:) = [obj.fitness(temp), ...
                                        obj.population(temp,:)];
        end
    end
    
end

