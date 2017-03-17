classdef onlineRecords < handle
    %ONLINERECORDS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        user = '';
        logged = false;
    end
    
    properties (Access = private)
        key = '';
        api = 'https://api.mlab.com/api/1/databases/metaheuristics/';
        apiKey = '&apiKey=POsU-OzCAPo67RrFszoJvg85MVuUU0Ji';
        logApi = 'collections/usersApi?q={"user":"'
    end
    
    methods
        function obj = onlineRecords()
            if exist('setting.mat', 'file') == 2
                load('setting.mat');
                if size(user,1) ~= 0
                    obj.logIn(user, key)
                end
            end
        end
        function logIn(obj, user, key)
            userInfo = webread([obj.api obj.logApi user '"}' obj.apiKey]);
            if(strcmp(key, userInfo.key))
                obj.user = user;
                obj.key = key;
                obj.logged = true;
                save('setting.mat', 'user', 'key')
            else
                warn 'Wrong user information, try to load again.'
            end
        end
        function logOut(obj)
            user = '';
            key = '';
            save('setting.mat', 'user', 'key');
            logged = false;
            obj.user = user;
            obj.key = key;
        end
        function addRecord(obj, algorithm, benchmark, bestFitness, bestSolution, dimensions, iterations, populationSize)
            %date
            %user
            dateStr = datestr(datetime('now'));
            url = [obj.api 'collections/records/?' obj.apiKey];
            options = weboptions('RequestMethod', 'post', 'MediaType','application/json');
            data = struct('user', obj.user, 'algorithm', algorithm, 'benchmark', ...
                benchmark, 'bestFitness', bestFitness, 'bestSolution', bestSolution, ...
                'dimensions', dimensions, 'iterations', iterations, 'populationSize', populationSize, 'date', dateStr);
            r = webwrite(url, data, options);
        end
    end
    
end

