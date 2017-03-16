classdef knapsack < handle
    %KNAPSACK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        noItems = 10;
        prices  = [];
        weights = [];
        rangePrices = 50;
        rangeWeights = 50;
        maxWeight = 70;
    end
    
    methods
        function obj = knapsack(noItems, range, maxWeight)
            if nargin > 0
                obj.noItems = noItems;
                obj.rangePrices = range;
                obj.rangeWeights = range;
                obj.maxWeight = maxWeight;    
            end
            obj.randomValues();
        end
        function randomValues(obj)
            obj.prices  = randi(obj.rangePrices,1,obj.noItems);
            obj.weights = randi(obj.rangeWeights,1,obj.noItems);
        end
        function f = fitness(obj, x)
            x = x==1;
            err = 1 + max(0, sum(obj.weights(x)) - obj.maxWeight);
            f = -sum(obj.prices(x))/err;
        end
        function [p,w] = testValues(obj, x)
            x = x==1;
            p = sum(obj.prices(x));
            w = sum(obj.weights(x));
        end
        
    end
    
end
