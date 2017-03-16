classdef DE < metaheuristic
    %DE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        crossoverRate = 0.7;
        diferrentialWeight = 0.5;
        
        %Analysis
        plotSpecial = 0;
    end
    
    methods
        function obj = DE(fitnessFunction, noDimensions)
            if nargin < 1
                return 
            end
            obj.fitnessFunction = fitnessFunction;
            obj.noDimensions = noDimensions;
        end
        
        function operators(obj)
            % DE implementation.
            F = obj.diferrentialWeight;
            for i=1:obj.sizePopulation
                selectedPop = obj.selectNDifferentSolutions(5);
                selectedDIm = randi(obj.noDimensions);
                solutionBase = obj.population(selectedPop(1),:);
                for j = 1:obj.noDimensions
                    if j == selectedDIm || rand > obj.crossoverRate
                        %original formula was candidate=a+f*(b-c)
                        %solutionBase(j) =obj.population(selectedPop(2))+...
                        %    F*(obj.population(selectedPop(3),j) - ...
                        %       obj.population(selectedPop(4),j));
                        solutionBase(j) = solutionBase(j) + ...
                            F*(obj.population(selectedPop(2),j) - ...
                               obj.population(selectedPop(3),j)) + ...
                            F*(obj.population(selectedPop(4),j) - ...
                               obj.population(selectedPop(5),j));
                    end
                end
                solutionBase(solutionBase > 1) = 1;
                solutionBase(solutionBase < 0) = 0;
                tempFit = obj.evalPopulation(solutionBase);
                if tempFit < obj.fitness(selectedPop(1))
                    if obj.plotSpecial
                        obj.plotSpecialF(selectedPop, solutionBase)
                    end
                    obj.improvementsCount = obj.improvementsCount + 1;
                    obj.fitness(selectedPop(1)) = tempFit;
                    obj.population(selectedPop(1),:) = solutionBase;
                end
            end
        end
        
        function plotSpecialF(obj, selectedPop, newOne)
            origen = obj.population(selectedPop(1),:);
            obj.plot()
            hold on
            vectarrow(obj.population(selectedPop(3),:),obj.population(selectedPop(2),:));
            hold on
            vectarrow(obj.population(selectedPop(5),:),obj.population(selectedPop(4),:));
            hold on
            vectarrow(origen,newOne);
            hold on
            plot(newOne(1),newOne(2), 'om');
            pause(0.05)
        end
        
        function indexes = selectNDifferentSolutions(obj,N)
            indexes = randperm(obj.sizePopulation,N);
            %indexes = temp(1:N);
        end
    end
    
end

