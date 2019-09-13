function net = initUDN(net)
    %%Utility Functions
    DBm_to_watts = @(x) 10^(x/10) /1000;

    %%net Parameters
    Macro_power_watts = DBm_to_watts(net.Macro_power);
    Femto_power_watts = DBm_to_watts(net.Femto_power);
    net.Ch_b = net.Bandwidth / net.NoChs;

    %%Model
    % Femtocells positions
    X = linspace(-net.Area_square, net.Area_square, ...
        floor(net.Area_square * 2 / net.D_fcs));
    [X, Y] = meshgrid(X, X);
    fc_positions = [reshape(X, [], 1), reshape(Y, [], 1)];
    rand_index = randperm(size(fc_positions, 1));
    fc_positions = fc_positions(rand_index(1:net.Q-1), :);
    fc_power = ones(net.Q-1, 1) * Femto_power_watts;
    % Macrocell at index 0
    cells_positions = [[0, 0]; fc_positions];    %cells_positions
    cells_power = [Macro_power_watts; fc_power]; %cells_power

    % Users Positions
    users_pos = rand(net.U, 2) * 2 * net.Area_square - net.Area_square;            %users_positions
    users_r = rand(net.U, 1) * (net.Demands_range(2) - net.Demands_range(1)) + net.Demands_range(1);
    
    % Distance and Gains Calculations
    dist_cell_user = zeros(net.U, net.Q);
    for i = 1:net.U
        user_pos = repmat(users_pos(i, :), net.Q, 1);
        dist_cell_user(i, :) = sqrt(sum((cells_positions - user_pos).^2, 2));
    end
        % Minimal distance between users and cells
    dist_cell_user(dist_cell_user < net.D_u_c) = net.D_u_c; 
    
    % Gain Matrix (HERE CAN BE ADDED THE PROBABILITY OF LOS)
    signal_user_cell = dist_cell_user.^net.Path_loss .* repmat(cells_power', net.U, 1) ./ net.NoChs;  % flat power
    
    net.cells_positions = cells_positions;
    net.cells_power = cells_power;
    net.users_pos = users_pos;
    net.users_r = users_r;
    net.dist_cell_user = dist_cell_user;
    net.signal_user_cell = signal_user_cell;
end

