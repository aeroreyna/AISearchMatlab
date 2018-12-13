classdef DA < metaheuristic
    %WOA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        DeltaX_R = [];
    end
    
    methods
        function obj = DA(fitnessFunction, noDimensions)
            obj.algorithmName = 'DA';
            if nargin < 1
                return 
            end
            obj.fitnessFunction = fitnessFunction;
            obj.noDimensions = noDimensions;
        end
        function operators(obj)
            %locals translations
            dim = obj.noDimensions;
            Max_iteration = obj.maxNoIterations;
            SearchAgents_no = obj.sizePopulation;
            X = obj.population;
            
            ub = ones(1,dim);
            lb = ones(1,dim)*0;

            %The initial radius of gragonflies' neighbourhoods
            r = (ub-lb)/10;
            Delta_max = (ub-lb)/10;

            % 
            % Fitness=zeros(1,SearchAgents_no); obj.fitness
            if obj.actualIteration == 1
                DeltaX = rand(obj.sizePopulation, obj.noDimensions);
                obj.updateWorst();
            else
                DeltaX = obj.DeltaX_R;
            end

            iter = obj.actualIteration;

            r = (ub-lb)/4+((ub-lb)*(iter/Max_iteration)*2);

            w = 0.9-iter*((0.9-0.4)/Max_iteration);

            my_c = 0.1-iter*((0.1-0)/(Max_iteration/2));
            if my_c<0
                my_c=0;
            end

            s = 2*rand*my_c; % Seperation weight
            a = 2*rand*my_c; % Alignment weight
            c = 2*rand*my_c; % Cohesion weight
            f = 2*rand;      % Food attraction weight
            e = my_c;        % Enemy distraction weight

            Food_fitness = obj.bestFitness;
            Food_pos = obj.bestSolution;
            Enemy_fitness = obj.worstFitness;
            Enemy_pos = obj.worstSolution;
            

            for i = 1:SearchAgents_no
                index=0;
                neighbours_no=0;

                Neighbours_DeltaX = [];
                Neighbours_X = [];
                %find the neighbouring solutions
                for j=1:SearchAgents_no
                    Dist2Enemy = norm( X(i, :) - X(j, :) );
                    if (all(Dist2Enemy<=r) && all(Dist2Enemy~=0))
                        index=index+1;
                        neighbours_no = neighbours_no + 1;
                        Neighbours_DeltaX(index, :) = DeltaX(j, :);
                        Neighbours_X(index, :) = X(j, :);
                    end
                end

                % Seperation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Eq. (3.1)
                S = zeros(1, dim);
                if neighbours_no > 1
                    for k = 1:neighbours_no
                        S = S + (Neighbours_X(k, :) - X(i, :));
                    end
                    S = -S;
                else
                    S = zeros(1, dim);
                end

                % Alignment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Eq. (3.2)
                if neighbours_no > 1
                    A = sum(Neighbours_DeltaX)/neighbours_no;
                else
                    A = DeltaX(i, :);
                end

                % Cohesion%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Eq. (3.3)
                if neighbours_no > 1
                    C_temp = sum(Neighbours_X)/neighbours_no;
                else
                    C_temp = X(i, :);
                end

                C = C_temp - X(i, :);

                % Attraction to food%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Eq. (3.4)
                Dist2Food = norm(X(i,:) - Food_pos); %atraction best
                if all(Dist2Food <= r)
                    F = Food_pos - X(i,:);
                else
                    F = 0;
                end

                % Distraction from enemy%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Eq. (3.5)
                Dist2Enemy = norm(X(i,:) - Enemy_pos);
                if all(Dist2Enemy <= r)
                    Enemy = Enemy_pos + X(i,:);
                else
                    Enemy = zeros(1, dim);
                end
                

                if any(Dist2Food > r)
                    if neighbours_no > 1
                        for j = 1:dim
                            DeltaX(i, j) = w*DeltaX(i, j) + rand*A(1, j) + rand*C(1, j) + rand*S(1, j);
                            if DeltaX(i, j) > Delta_max(j)
                                DeltaX(i, j) = Delta_max(j);
                            end
                            if DeltaX(i, j) < -Delta_max(j)
                                DeltaX(i, j) = -Delta_max(j);
                            end
                            X(i, j) = X(i, j) + DeltaX(i, j);
                        end
                    else
                        % Eq. (3.8)
                        X(i, :) = X(i, :) + obj.Levy(dim) .*X(i, :);
                        DeltaX(i, :) = 0;
                    end
                else
                    for j = 1:dim
                        % Eq. (3.6)
                        DeltaX(i, j)=(a*A(1, j) + c*C(1, j) + s*S(1, j) + f*F(1, j) + e*Enemy(1, j)) + w*DeltaX(i, j);
                        if DeltaX(i, j)>Delta_max(j)
                            DeltaX(i, j)=Delta_max(j);
                        end
                        if DeltaX(i, j)<-Delta_max(j)
                            DeltaX(i, j)=-Delta_max(j);
                        end
                        X(i, j)=X(i, j)+DeltaX(i, j);
                    end 
                end

                %Flag4ub=X(:,i)>ub';
                %Flag4lb=X(:,i)<lb';
                %X(:,i)=(X(:,i).*(~(Flag4ub+Flag4lb)))+ub'.*Flag4ub+lb'.*Flag4lb;
            end
            obj.DeltaX_R = DeltaX;
            obj.population = X;
            obj.checkBounds();
            obj.evalPopulation();
            obj.updateBest();
            obj.updateWorst();
        end
        
        function o = Levy(~, d)
            beta = 3/2;
            %Eq. (3.10)
            sigma = (gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
            u = randn(1,d)*sigma;
            v = randn(1,d);
            step = u./abs(v).^(1/beta);

            % Eq. (3.9)
            o = 0.01*step;
        end
    end
    
end

