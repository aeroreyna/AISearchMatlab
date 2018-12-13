classdef onlineRecords < handle
    %ONLINERECORDS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    properties (Access = private)
        logged = false;
        key = '';
        api = 'https://metaheuristicsapi.herokuapp.com/';
        apiKey = '&apiKey=';
        logApi = 'users/'
    end
    
    methods
        function obj = onlineRecords()
            if(strcmp(getenv('METAAPIKEY'),'') ~= 1)
                obj.logIn(getenv('METAAPIKEY'))
            end
        end
        function logIn(obj, apiKey)
            apiKeyStr = [obj.apiKey apiKey];
            result = webread([obj.api obj.logApi '?'  apiKeyStr]);
            if(strcmp(result, 'ok'))
                obj.apiKey = apiKeyStr;
                obj.logged = true;
                setenv('METAAPIKEY', apiKey);
            else
                warning('Wrong user information, try to load again.');
            end
        end
        function logOut(obj)
            obj.logged = false;
            obj.apiKey = '&apiKey=';
        end
        function r = isLogIn(obj)
            r = obj.logged;
        end
        function r = addRecord(obj, algorithm, benchmark, bestFitness, bestSolution, dimensions, iterations, populationSize)
            if(obj.logged)
                dateStr = datestr(datetime('now'));
                url = [obj.api 'records/?' obj.apiKey];
                options = weboptions('RequestMethod', 'post', 'MediaType','application/json');
                data = struct('algorithm', algorithm, 'benchmark', ...
                    benchmark, 'bestFitness', bestFitness, 'bestSolution', bestSolution, ...
                    'dimensions', dimensions, 'iterations', iterations, 'populationSize', populationSize, 'date', dateStr);
                try
                    r = webwrite(url, data, options);
                catch ME
                    ME
                    warning('Fallo la comunicación con el servidor.');
                end
            else
                warning('Wrong user information, try to load again.');
            end
        end
    end
    
end

