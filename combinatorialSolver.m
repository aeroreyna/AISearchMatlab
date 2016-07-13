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
        end
    end
    
end