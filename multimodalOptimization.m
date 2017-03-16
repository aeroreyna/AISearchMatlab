classdef multimodalOptimization < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        historicDiversity = [];
        AISearch;
    end
    
    methods
        function obj = multimodalOptimization(AISearch)
            obj.AISearch = AISearch;
        end
        function diversity(obj,AISearch)
            if size(obj.historicDiversity,1)==0
                obj.historicDiversity = zeros(1, AISearch.maxNoIterations);
            end
            obj.historicDiversity(AISearch.actualIteration) = ...
                AISearch.diversity();%AISearch.memory(:,1:end-1));
        end
        function plotDiversity(obj)
            figure
            plot(obj.historicDiversity)
        end
    end
    
end

