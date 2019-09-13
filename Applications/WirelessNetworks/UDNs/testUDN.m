rng(10)
%% Base Network Instance
net = defaultUDN(); % Network and problem Parameters 
net = initUDN(net); % Cells and Users positions, and SNR Calculation

%% PreCalculation for the Resource Allocation
net = association(net);
net = reqChannels(net);

%% Visualization
%plotNetwork(net);

%% Resource Allocation
ffs = channelAllocationFF(net);
ffs.CBA(zeros(size(net.cells_active,1), 1)+0.01);

% Random Cell Allocation7
a = [];
best = -inf;
bestx = [];
tic
for i=1:10000
    x = rand(size(net.cells_active,1),1);
    c = -ffs.CBA(x);
    if(c > best)
        c = best;
        bestx = x;
    end
end
[f, uc] = ffs.CBA(x);
toc
Capacity = sum(uc)
figure
hist(uc, 100)

tic
AISearch = SMS(@ffs.CBA, size(net.cells_active,1));
AISearch.sizePopulation = 100;
AISearch.maxNoIterations = 100;
AISearch.stripFitnessCalls = true;
AISearch.start();
AISearch.bestFitness
toc
[f, uc] = ffs.CBA(AISearch.bestSolution);
Capacity = sum(uc)
figure
hist(uc, 100)