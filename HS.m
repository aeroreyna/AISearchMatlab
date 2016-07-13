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
            if nargin < 1
                return 
            end
            obj.fitnessFunction = fitnessFunction;
            obj.noDimensions = noDimensions;
        end
        
        function operators(obj)
            for i = 1:obj.sizePopulation
                newSolution = zeros(1,obj.noDimensions);
                for j = 1:obj.noDimensions
                    if obj.newMelodyRate < rand
                        newSolution(j)=rand; %random
                    else
                        a = randi(obj.sizePopulation); 
                        newSolution(j)=obj.population(a,j); %memory armony
                        if obj.pitchAdjustRate < rand %pitch asjustment
                            newSolution(j) = newSolution(j) + obj.stepAdjust * randn;
                        end
                    end
                end
                newSolution = obj.checkBounds(newSolution);
                tempFit = obj.evalPopulation(newSolution);
                if tempFit < obj.fitness(end)
                    obj.fitness(end) = tempFit;
                    obj.population(end,:) = newSolution;
                end
                obj.sortPopulation();
            end
        end
    end
    
end

