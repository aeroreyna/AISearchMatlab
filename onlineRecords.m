classdef onlineRecords < handle
    %ONLINERECORDS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    properties (Access = private)
        logged = false;
        key = '';
        api = 'https://metaheuristicsapi.herokuapp.com/';
        apiKey = '&apikey=';
        logApi = 'users/'
    end
    
    methods
        function obj = onlineRecords()
            if(strcmp(getenv('METAAPIKEY'),'') ~= 1)
                obj.logIn(getenv('METAAPIKEY'))
            end
        end
        function logIn(obj, apiKey)
            apiKey = [obj.apiKey apiKey];
            result = webread([obj.api obj.logApi '?'  apiKey]);
            if(strcmp(result, 'ok'))
                obj.apiKey = apiKey;
                obj.logged = true;
            else
                warn 'Wrong user information, try to load again.'
            end
        end
        function logOut(obj)
            obj.logged = false;
            obj.apiKey = '&apikey=';
        end
        function r = isLogIn(obj)
            r = obj.logged;
        end
        function r = addRecord(obj, algorithm, benchmark, bestFitness, bestSolution, dimensions, iterations, populationSize)
            if(obj.logged)
                dateStr = datestr(datetime('now'));
                url = [obj.api 'records/?' obj.apiKey];
                options = weboptions('RequestMethod', 'post', 'MediaType','application/json');
                data = struct('user', obj.user, 'algorithm', algorithm, 'benchmark', ...
                    benchmark, 'bestFitness', bestFitness, 'bestSolution', bestSolution, ...
                    'dimensions', dimensions, 'iterations', iterations, 'populationSize', populationSize, 'date', dateStr);
                r = webwrite(url, data, options);
            else
                warn 'Wrong user information, try to load again.'
            end
        end
    end
    
end

