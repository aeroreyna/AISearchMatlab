classdef SMS < metaheuristic
    %SMS States of Matter Search of this class goes here
    %   Detailed explanation goes here
    
    properties
        beta  = [0.9, 0.5, 0.1]; %movements
        alpha = [0.3, 0.05, 0];  %colitions
        H     = [0.9, 0.2,  0];  %randomness
        phases= [0.5, 0.1,-0.1]; %phasesPercents
        phase = 1;               %phaseActual
        direction = [];
        stepPhase = [0.85 0.35 0.1];
    end
    
    methods
        function obj = SMS(fitnessFunction, noDimensions)
            obj.algorithmName = 'SMS';
            if nargin < 1
                return 
            end
            obj.fitnessFunction = fitnessFunction;
            obj.noDimensions = noDimensions;
        end
        function operators(obj)
            if size(obj.direction)==0
                obj.direction = zeros(size(obj.population));
            end
            %Local variables
            pobL = obj.population;
            dirL = obj.direction;
            best = obj.bestSolution;
            
            %Movement
            best = repmat(best,obj.sizePopulation,1);
            b = sqrt(sum((best-pobL+eps).^2,2));
            b = repmat(b,1,obj.noDimensions);
            a = (best-pobL)./b;
            dirL = dirL * (1 - obj.actualIteration/obj.maxNoIterations)*0.5 + a;
                        
            %colition
            r = 1 * obj.alpha(obj.phase);
            for i = 1:obj.sizePopulation-1
                for j = i+1:obj.sizePopulation
                    rr = norm(pobL(i,:)-pobL(j,:));
                    if rr < r
                        c = dirL(i,:);
                        d = dirL(j,:);
                        dirL(i,:)=d;
                        dirL(j,:)=c;
                    end
                end
            end
            
            %update positions
            v = 1 * obj.beta(obj.phase) * dirL; 
            pobL = pobL + v * rand * obj.stepPhase(obj.phase);
            
            %random
            for i = 1:obj.sizePopulation
                if rand < obj.H(obj.phase)
                    j = randi(obj.noDimensions);
                    pobL(i,j)= rand;
                end
            end
            
            %parameters adjusment
            if (1 - obj.actualIteration/obj.maxNoIterations)<obj.phases(obj.phase)
                obj.phase = obj.phase+1;
            end
            
            obj.population = pobL;
            obj.checkBounds();
            obj.direction = dirL;
            obj.evalPopulation();
        end
    end
    
end

