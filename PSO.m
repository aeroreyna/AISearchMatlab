classdef PSO < metaheuristic
    %PSO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        velocity = []
        bestPersonal = []  % [fitness, solutions]
        velocityParam = 0.97;
        bestPersonalParam = 0.4;
        bestParam = 0.5;
        
        %Analysis
        plotSpecial = 0;
        historicBP = [];
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
                obj.historicBP = zeros(obj.sizePopulation, obj.noDimensions, obj.maxNoIterations);
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
            
            if obj.plotSpecial
                oldPop = obj.population;
            end
            % update solutions
            obj.population = obj.population + obj.velocity;
            obj.checkBounds();
            
            % eval fitness
            obj.evalPopulation();
            tempIndx = obj.updateBestPersonal();
            
            %SpecialPlot for educational propouses
            if obj.plotSpecial
                if(sum(tempIndx))
                    obj.plotSpecialF(oldPop, pbAtraction, bestAtraction, tempIndx);
                    pause(0.1)
                end
                obj.historicBP(:,:,obj.actualIteration) = obj.bestPersonal(:,2:end);
            end
        end
        
        function temp = updateBestPersonal(obj)
            temp = obj.bestPersonal(:,1) > obj.fitness;
            obj.bestPersonal(temp,:) = [obj.fitness(temp), ...
                                        obj.population(temp,:)];
            obj.improvementsCount = obj.improvementsCount + sum(temp);
        end
        
        function plotSpecialF(obj, oldPop, pAttr, bAtrr, indx)
            if sum(indx)
                obj.plotSolutions(oldPop(:,:),'or');
                hold on
                obj.plotSolutions(obj.population(indx,:),'og');
                plot(obj.bestSolution(1),obj.bestSolution(2),'om');
                obj.graph2d()
                for i=1:obj.sizePopulation
                    if indx(i)
                        %PlotVectors
            hold on
            vectarrow(oldPop(i,:), oldPop(i,:)+pAttr(i,:));
            hold on
            vectarrow(oldPop(i,:), oldPop(i,:)+bAtrr(i,:));
            hold on
            vectarrow(oldPop(i,:),obj.population(i,:));
                    end
                end
            end
        end
    end
    
end

