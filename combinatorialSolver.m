classdef combinatorialSolver < metaheuristic
    %COMBINATORIALSOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bitsPerDimension = 2;
        rangePerDimension = [0, 1];
    end
    
    methods
        function initialPopulation(obj, sizePopulation, noDimensions)
            % Method that start a new random population, it could use the
            % object propierties, or well assing new properties of
            % population size and/or number of dimensions.
            if nargin == 1
                sizePopulation = obj.sizePopulation;
                noDimensions = obj.noDimensions;
            elseif nargin == 2
                obj.sizePopulation = sizePopulation;
                noDimensions = obj.noDimensions;
            else
                obj.sizePopulation = sizePopulation;
                obj.noDimensions = noDimensions;
            end
            obj.population = randi(obj.rangePerDimension, sizePopulation, noDimensions);
            if size(obj.initialSolutions,1) ~= 0
                if size(obj.initialSolutions,2) ~= obj.noDimensions || size(obj.initialSolutions,1) > obj.sizePopulation
                    error('Initial custom population do not have the right dimensions');
                end
                obj.population(1:size(obj.initialSolutions,1),:) = obj.initialSolutions;
            end
        end
    end
    
end