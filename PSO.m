classdef PSO < metaheuristic
    %PSO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        velocity = []
        bestPersonal = []  % [fitness, solutions]
        velocityParam = 0.4;
        bestPersonalParam = 2;
        bestParam = 2;
        
        %Analysis
        plotSpecial = 0;
        historicBP = [];
    end
    
    methods
        function self = PSO(fitnessFunction, noDimensions)
            self.algorithmName = 'PSO';
            if nargin < 1
                return 
            end
            self.fitnessFunction = fitnessFunction;
            self.noDimensions = noDimensions;
        end
        
        function operators(self)
            if size(self.velocity,1)==0
                self.velocity = zeros(self.sizePopulation, self.noDimensions);
            end
            if size(self.bestPersonal)==0
                self.bestPersonal = [self.fitness, self.population];
                if self.plotSpecial
                    self.historicBP = zeros(self.sizePopulation, self.noDimensions, self.maxNoIterations);
                end
            end
            % atraction to the best personal solution
            pbAtraction = rand(self.sizePopulation,self.noDimensions) .* ...
                (self.bestPersonal(:,2:end)-self.population);
            
            % atraction to the best global solution
            bestAtraction = rand(self.sizePopulation,self.noDimensions) .* ...
                (repmat(self.bestSolution, self.sizePopulation, 1) - self.population);
            
            % update velocity trayectories.
            self.velocity = self.velocityParam * self.velocity + ...
                    self.bestPersonalParam * pbAtraction + ...
                    self.bestParam * bestAtraction;
            
            if self.plotSpecial
                oldPop = self.population;
            end
            % update solutions
            self.population = self.population + self.velocity;
            self.checkBoundsToroidal();
            
            % eval fitness
            self.evalPopulation();
            tempIndx = self.updateBestPersonal();
            
            %SpecialPlot for educational propouses
            if self.plotSpecial
                if(sum(tempIndx))
                    self.plotSpecialF(oldPop, pbAtraction, bestAtraction, tempIndx);
                    pause(0.1)
                end
                self.historicBP(:,:,self.actualIteration) = self.bestPersonal(:,2:end);
            end
        end
        
        function temp = updateBestPersonal(self)
            temp = self.bestPersonal(:,1) > self.fitness;
            self.bestPersonal(temp,:) = [self.fitness(temp), ...
                                        self.population(temp,:)];
            self.improvementsCount = self.improvementsCount + sum(temp);
        end
        
        function plotSpecialF(self, oldPop, pAttr, bAtrr, indx)
            if sum(indx)
                self.plotSolutions(oldPop(:,:),'or');
                hold on
                self.plotSolutions(self.population(indx,:),'og');
                plot(self.bestSolution(1),self.bestSolution(2),'om');
                self.graph2d()
                for i=1:self.sizePopulation
                    if indx(i)
                        %PlotVectors
            hold on
            vectarrow(oldPop(i,:), oldPop(i,:)+pAttr(i,:));
            hold on
            vectarrow(oldPop(i,:), oldPop(i,:)+bAtrr(i,:));
            hold on
            vectarrow(oldPop(i,:),self.population(i,:));
                    end
                end
            end
        end
    end
    
end

