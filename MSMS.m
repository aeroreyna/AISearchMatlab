classdef MSMS < metaheuristic
    %Multimodal SMS States of Matter Search 
    %
    
    properties
        beta  = [0.7, 0.5, 0.1]; %movements
        alpha = [0.3, 0.05, 0];  %colitions
        H     = [0.8, 0.1,  0];  %randomness
        phases= [0.5, 0.1,-0.1]; %phasesPercents
        phase = 1;               %phaseActual
        memory= [];              %solutionMemory
        maxMemory = 100;         %MaxNumberOfMemomeryEntries
        rdppi = []; 
        direction = [];
        stepPhase = [0.85 0.35 0.1];
    end
    
    methods
        function obj = MSMS(fitnessFunction, noDimensions)
            if nargin < 1
                return 
            end
            obj.fitnessFunction = fitnessFunction;
            obj.noDimensions = noDimensions;
            obj.maxMemory = 50;
        end
        function operators(obj)
            if size(obj.direction)==0
                obj.direction = zeros(size(obj.population));
            end
            if size(obj.memory,1) == 0
                obj.updateMemory();
            end
            %Local variables
            pobL = obj.population;
            dirL = obj.direction;
            
            %Movement
            a = zeros(size(obj.population,1),obj.noDimensions);
            for i = 1:obj.sizePopulation
                [ii, b] = obj.closestMemory(pobL(i,:));
                a(i,:) = (obj.memory(ii,1:end-1)-pobL(i,:))./(b+eps);
            end
            dirL = dirL * (1 - obj.actualIteration/obj.maxNoIterations)*0.5 + a;
                        
            %colition (Not nessesary, work better without it
            r = 1 * obj.alpha(obj.phase);
            for i = 1:obj.sizePopulation-1
                for j = i+1:obj.sizePopulation
                    rr = sum((pobL(i,:)-pobL(j,:)).^2);
                    if rr < r^2
                        c = dirL(i,:);
                        d = dirL(j,:);
                        dirL(i,:)=d;
                        dirL(j,:)=c;
                    end
                end
            end
            
            %update positions
            v = obj.beta(obj.phase) * dirL; 
            pobL = pobL + v * rand * obj.stepPhase(obj.phase);
            
            %random
            for i = 1:obj.sizePopulation
                if rand < obj.H(obj.phase)
                    j = randi(obj.noDimensions);
                    pobL(i,j)= rand;
                end
            end
            
            %obj.population = pobL;
            pobL = obj.checkBounds(pobL);
            %tempF = obj.evalPopulation(pobL);
            %tempFB = tempF < obj.fitness;
            %obj.population(tempFB,:) = pobL(tempFB,:);
            %obj.fitness(tempFB) = tempF(tempFB);
            obj.population = pobL;
            obj.evalPopulation();
            obj.direction = dirL;
            obj.updateMemory();
            
            %parameters adjusment
            if (1 - obj.actualIteration/obj.maxNoIterations)<obj.phases(obj.phase)
                obj.phase = obj.phase+1;
                obj.cleanMemory();
                for i=1:obj.sizePopulation
                    m = size(obj.memory,1);
                    obj.population(i,:) = obj.memory(randi(m),1:end-1);
                end
            end
        end
        
        function [index, distance] = closestMemory(obj, solution)
            solution = repmat(solution, size(obj.memory,1), 1);
            [distance, index] = min(sum((solution - obj.memory(:,1:end-1)).^2,2));
            distance = sqrt(distance)/sqrt(obj.noDimensions);
        end
        
        function updateMemory(obj)
            pobL = obj.population;
            obj.updateWorst();
            
            %FirstSolutionOnMemory
            if size(obj.memory, 1) == 0
                [~, p] = min(obj.fitness);
                obj.memory = [obj.population(p,:), obj.fitness(p)];
            end
            
            %UpdateMemory
            for i=1:obj.sizePopulation
                if obj.fitness(i) <= max(obj.memory(:,end))
                    %better than the worst on memory, so it has to included
                    %or replace colsest one in the memory
                    [ii, dd] = obj.closestMemory(pobL(i,:));
                    if rand < dd^obj.phase/sqrt(obj.noDimensions)
                        %new entry in the memory
                        obj.memory(end+1, 1:end) = [obj.population(i,:), obj.fitness(i)];
                    else
                        %considered the same optimun
                        if obj.fitness(i) <= obj.memory(ii,end)
                            %replace if better
                            obj.memory(ii, :) = [obj.population(i,:), obj.fitness(i)];
                        end
                    end
                else
                    %it still has a little chance of be an optimun
                    if rand + 0.7 <(1-(obj.fitness(i)-obj.bestFitness)/(obj.worstFitness-obj.bestFitness))
                        [~, dd] = obj.closestMemory(pobL(i,:));
                        if rand < dd^obj.phase/sqrt(obj.noDimensions)
                            %new entry
                            obj.memory(end+1, 1:obj.noDimensions+1) = [obj.population(i,:), obj.fitness(i)];
                        end
                    end
                end
            end
            
            
            
            %checkMemorySize
            if obj.maxMemory < size(obj.memory,1)
%                 obj.phase = obj.phase+1;
                obj.cleanMemory();
%                 for i=1:obj.sizePopulation
%                     m = size(obj.memory,1);
%                     obj.population(i,:) = obj.memory(randi(m),1:end-1);
%                 end
            end
        end
        
        function cleanMemory(obj)
            %Clean memory from repetition
            %This method is used only few times, so efficiency is not such
            %a problem.
            disp('cleaning memory')
            %Sort memory
            obj.memory = sortrows(obj.memory,obj.noDimensions+1);
            [m,n] = size(obj.memory);
            MemL = obj.memory(:,1:end-1);
            rdp = zeros(m,m);
            obj.rdppi = zeros(1,m);
            %find the clean radio of each entry in the memory
            for i=1:m
                for j=1:m
                    if i~= j
                        %eval all the distances between them
                        rdp(i,j) = norm(MemL(i,:)-MemL(j,:));
                    end
                end
                %sort by distance
                [~,jj] = sort(rdp(i,:));
                for j=1:m
                    temp = obj.fitnessFunction(MemL(i,:)+(MemL(jj(j),:)-MemL(i,:))*0.5);
                    obj.numberOfFunctionCalls = obj.numberOfFunctionCalls + 1;
                    if temp > max([obj.memory(jj(j),end),obj.memory(i,end)])
                        %the point between them has worst fitness, set the
                        %radio of that entry a percent of distance.
                        obj.rdppi(i) = rdp(i,jj(j))*0.85;
                        break
                    end
                end
            end
            %Clean the unwanted information.
            %this could be done with the first cicle, so innesary
            %evaluations could be ommited.
            cTemp=0;
            badInd = zeros(m,1);
            for i=1:m
                if badInd(i) == 0
                    ind = rdp(i,:) < obj.rdppi(i);
                    badInd(ind) = badInd(ind)+1;
                    cTemp = cTemp+1;
                    NewMem(cTemp,1:n) = obj.memory(i,:);
                    Newrdpi(cTemp) = obj.rdppi(i);
                end
            end
            obj.memory = NewMem;
            obj.rdppi = Newrdpi;
        end
    end
    
end

