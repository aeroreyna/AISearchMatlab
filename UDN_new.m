function [users_capacity_result, allocation_matrix, cells_positions, cells_power, users_pos, users_r] = UDN_new()
    %%Utility Functions
    DBm_to_watts = @(x) 10^(x/10) /1000;

    %%Network Parameters
    Macro_power = 46;  % DBm
    Macro_power_watts = DBm_to_watts(Macro_power);
    Femto_power = 24;  % DBm
    Femto_power_watts = DBm_to_watts(Femto_power);
    Path_loss = -3;
    Bandwidth = 200e6;
    Channels = 1000;
    Ch_b = Bandwidth / Channels;
    Noise = 1e-10;
    limit_snir = 6.3096;  % 8dbs
    Area_square = 100;  % meters

    %%Problem Paramters
    Q = 200;                        %cells
    U = 400;                        %users
    D_fcs = 10;                     %min distance between cells
    D_u_c = 3.0;
    Demands_range = [10e6, 20e6];
    I_t = 1e-8;
    
    population_size = 19999;
    iterations = 100;

    %%Model
    % Femtocells positions
    X = gpuArray.linspace(-Area_square, Area_square, floor(Area_square*2/D_fcs));
    [X, Y] = meshgrid(X, X);
    fc_positions = [reshape(X, [], 1), reshape(Y, [], 1)];
    rand_index = gpuArray.randperm(size(fc_positions, 1));
    fc_positions = fc_positions(rand_index(1:Q-1), :);
    fc_power = gpuArray.ones(Q-1, 1) * Femto_power_watts;
    % Macrocell at index 0
    cells_positions = [[0, 0]; fc_positions];                                   %cells_positions
    cells_power = [Macro_power_watts; fc_power];                                %cells_power

    % Users Positions
    users_pos = gpuArray.rand(U, 2) * 2 * Area_square - Area_square;            %users_positions
    users_r = gpuArray.rand(U, 1) * (Demands_range(2) - Demands_range(1)) + Demands_range(1);

    %%Distance and Gains Calculations
    dist_cell_user = gpuArray.zeros(U, Q);
    for i = 1:size(users_pos,1)
        user_pos = repmat(users_pos(i, :), Q, 1);
        dist_cell_user(i, :) = sqrt(sum(cells_positions - user_pos, 2).^2);
    end
    dist_cell_user(dist_cell_user < D_u_c) = D_u_c; % Minimal distance between users and cells

    signal_user_cell = dist_cell_user.^Path_loss .* repmat(cells_power', U, 1) ./ Channels;  % flat power
    [user_signal, association] = max(signal_user_cell');
    bits_needed = ceil(users_r ./ Ch_b);
    bits_per_ch = floor(log2(1 + user_signal ./ (Noise + I_t)));    %probably not needed
    required_channels = ceil(bits_needed ./ bits_per_ch');
    required_channels(required_channels==inf) = 0;                  %Users without service

    %%SOME_Optimization_code_variables
    big_eye = [];
    
    %%Allocation
    allocation_matrix = gpuArray.zeros(U, Channels);
    current_ch = 1;
    association_temp = association * 1;
    users_capacity_result = gpuArray.zeros(U,1);
    while(sum(sum(association_temp)))
        remainded_users = sum(sum(association_temp>0))
        current_ch
        [cells_active_users, cells_active_index] = hist(association_temp,unique(association_temp));
        association_expanded = gpuArray.zeros(Q, max(cells_active_users));
        if(cells_active_index(1)==0)
            cells_active_users = cells_active_users(2:end);
            cells_active_index = cells_active_index(2:end);
        end
        for i = 1:Q
            temp_user_idx = find(association_temp==i);
            association_expanded(i, 1:size(temp_user_idx, 2)) = temp_user_idx;
        end
        association_expanded = association_expanded(cells_active_index, :);
        
        if size(cells_active_users, 2) ~= 1
            AISearch = HS_GPU(@fitness_function_new, size(cells_active_users,2));
            AISearch.sizePopulation = population_size;
            AISearch.maxNoIterations = iterations;
            AISearch.start()
            [~, x2, ~] = fitness_function_new(AISearch.bestSolution);
        else
            x2 = 1;
        end
        

        association_expanded_selected = association_expanded(find(x2),:);
        users_to_allocate_indx = gpuArray.ones(size(association_expanded_selected,1), 1);
        users_to_allocate = association_expanded_selected(sub2ind(size(association_expanded_selected), 1:size(association_expanded_selected,1), users_to_allocate_indx'));
        while(sum(users_to_allocate))
            users_mask = find(users_to_allocate);
            users_capacity_2 = capacity_selected_users(users_to_allocate(users_mask));
            required_channels = ceil(users_r(users_to_allocate(users_mask))' ./ users_capacity_2);
            for ch = current_ch:current_ch+min(required_channels)
                allocation_matrix(users_to_allocate(users_mask), ch) = 1;
            end
            current_ch = current_ch + min(required_channels);
            if(current_ch > Channels)
                warning('channels exhausted');
            end
            users_capacity_result(users_to_allocate(users_mask)) = users_capacity_2 * min(required_channels);
            users_r(users_to_allocate(users_mask)) = users_r(users_to_allocate(users_mask))' - users_capacity_2 * min(required_channels);
            users_r(users_r<0) = 0;
            fullfilled_users = gpuArray.zeros(size(association_expanded_selected,1),1) ~= 0;
            fullfilled_users(users_mask) = users_capacity_result(users_to_allocate(users_mask))> users_r(users_to_allocate(users_mask));
            users_to_allocate_indx(fullfilled_users) = users_to_allocate_indx(fullfilled_users) + 1;
            users_to_allocate = association_expanded_selected(sub2ind(size(association_expanded_selected), 1:size(association_expanded_selected,1), users_to_allocate_indx'));
        end  
        fullfilled_users = users_capacity_result > users_r;
        association_temp(fullfilled_users) = 0; %remove cells fullfilled
    end
    
    allocation_matrix
    sum(users_capacity_result)
    
    function [fitness, x2, users_capacity_i] = fitness_function_new(x)
        x2 = floor(x .* (cells_active_users + 1));
        x3 = x2*1;
        x3(x3==0) = 1;                                                          % Adds dummy users to maintain dimensionality
        selected_index = x2~=0;
        selected_index_2 = reshape(repmat(selected_index, 1, size(x2,2))', size(x2,2), size(x2,2), []);
        
        all_select_users = association_expanded(sub2ind(size(association_expanded), repmat(1:size(x3,2), size(x3,1), 1), x3));
        all_selected_cells = association(reshape(all_select_users,[], 1));
        all_selected_cells = reshape(all_selected_cells, size(all_select_users,1), size(all_select_users,2));
        
        temp_signal_user_cell = signal_user_cell(:, all_selected_cells(1,:));   % Filter unactive cells
        
        temp = temp_signal_user_cell(reshape(all_select_users',[], 1),:)';      % Get active users perceived signals of all cells
        temp_signal = reshape(temp, size(temp,1), size(x2,2), []);              % Divided into PopSize square matrices
        
        signals_matrix = temp_signal .* selected_index_2;                       % Eliminates dummy users
        
        if(size(x2,1) == population_size)        % Allocated big memories is time consuming, save it on global variable
            if(size(big_eye,1) ~= size(x2,2))
                big_eye = repmat(eye(size(x2,2)),1,1,size(x2,1));
            end
            signals_users = sum(signals_matrix .* big_eye, 1);
        else
            signals_users = sum(signals_matrix .* repmat(eye(size(x2,2)),1,1,size(x2,1)), 1);
        end
        
        interference = sum(signals_matrix, 1) - signals_users;                  % Everybody interference is the sum of all signals, minus the desired one.
        
        users_capacity = squeeze(Ch_b * log2(1 + signals_users./(Noise)));
        users_capacity_i = squeeze(Ch_b * log2(1 + signals_users./(Noise + interference)));
        
        eff_sharing = users_capacity_i ./ users_capacity;
        eff_sharing(isnan(eff_sharing)) = 0;                                    % Eliminates NaN resulting of dummy users spaces
        
        fitness = -sum(users_capacity_i) .* sum(eff_sharing) ./ sum(users_capacity_i ~= 0);
        fitness = fitness';
        
    end
    function [users_capacity_i, users_capacity, selected_cells] = capacity_selected_users(selected_users)
        selected_cells = association(selected_users);
        users_signals = signal_user_cell(sub2ind(size(signal_user_cell), selected_users, selected_cells));
        interference_matrix = signal_user_cell(selected_users, selected_cells);
        interference_users = sum(interference_matrix,2)';
        users_capacity = Ch_b * log2(1 + users_signals./(Noise));
        users_capacity_i = Ch_b * log2(1 + users_signals./(Noise + interference_users - users_signals));
    end
end
