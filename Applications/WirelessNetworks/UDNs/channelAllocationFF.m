function r = channelAllocationFF(net)
    r = {};
    r.matrixFF = @matrixFF;
    r.ICA = @ICA;
    r.UBA = @UBA;
    r.CBA = @CBA;
    net.cells_users = {net.cell_association{net.cells_active}};
    firstUserCell = cellfun(@(v)v(1), net.cells_users);
    
    firstUserCell_GPU = gpuArray(firstUserCell);
    firstUserCell_GPU = repmat(firstUserCell_GPU', 1, net.NoChs);
    
    function fitness = fitnessFunction(usersCapacity)
        %fitness = -sum(usersCapacity) / (1 + sum(net.users_r > usersCapacity));
        fitness = -sum(usersCapacity);
    end
    function [fitness, C] = matrixFF(x)
        C = zeros(size(x,1), 1);
        for n=1:size(x,2) 
          usersInx = x(:,n) == 1; %list of users using channel n
          cellsInx = net.association(usersInx); %cells attending these users
          signalsRx      = net.signal_user_cell(usersInx, cellsInx); %max size of QxQ
          DessiredSingal = diag(signalsRx)';
          Interference   = sum(signalsRx, 1) - DessiredSingal;
          C(usersInx)    = C(usersInx)' + net.Ch_b *...
                           log2(1 + DessiredSingal ./ (net.Noise + Interference));
        end
        fitness = fitnessFunction(C);
    end
    function [fitness, cells_capacity_i] = bigMatrixFF(cell_ch)
        active_Q = size(net.cells_users,2);
        dummies = ~cell_ch .* repmat(firstUserCell_GPU', 1, net.NoChs);
        notDummies = reshape(~dummies, active_Q,1,[]);
        notDummies2 = permute(notDummies, [2,1,3]);
        all_selected_users = (dummies + cell_ch);
        temp_signal_user_cell = net.signal_user_cell(:, net.cells_active); % Filter unactive cells
        temp = temp_signal_user_cell(all_selected_users(:), :); % Get active users perceived signals of all cells
        signals_matrix = reshape(temp', active_Q, active_Q, []);           % Divided into PopSize square matrices
        signals_matrix = signals_matrix .* notDummies .* notDummies2;      % Eliminates dummy users
        big_eye = repmat(eye(active_Q), 1, 1, net.NoChs);
        signals_users = sum(signals_matrix .* big_eye, 2);
        interference = sum(signals_matrix, 2) - signals_users;             % Everybody interference is the sum of all signals, minus the desired one.
        cells_capacity_i = squeeze(net.Ch_b * log2(1 + signals_users./(net.Noise + interference)));
        %temp = [reshape(cell_ch, [],1), reshape(cells_capacity_i, [], 1)];
        %temp = temp(temp(:,1)~=0,:);
        fitness = sum(sum(cells_capacity_i));
    end
    function [fitness, usersCapacity, X] = ICA(x)
        %transform x to X
        if max(max(x))<=1
            x = ceil(x * net.NoChs);
        end
        cell_ch = zeros(net.Q, net.NoChs);
        X = zeros(net.U, net.NoChs);
        index = 1;
        for user = 1:size(net.required_channels, 1)
            chs = x(index: index + net.required_channels - 1);
            index = index + net.required_channels;
            cell  = net.association(user);
            chs   = chs(~cell_ch(cell, chs)); %Filter used channels in the cell
            cell_ch(cell, chs) = user;
            X(user, chs) = 1;
        end
        %evaluate
        [fitness, usersCapacity] = matrixFF(X);
    end
    function [fitness, usersCapacity, X] = UBA(x) %NEED TO ADD RING OPERATION
        %transform x to X
        if max(max(x))<=1
            x = ceil(x * net.NoChs);
        end
        cell_ch = zeros(net.Q, net.NoChs);
        X = zeros(net.U, net.NoChs);
        for user = 1:size(net.required_channels, 1)
            chs = x(user):x(user) + net.required_channels(user) - 1;
            if(chs(end) > net.NoChs)
                chs = mod(chs, net.NoChs); %RING STYLE
                chs(chs==0) = net.NoChs;
            end
            cell  = net.association(user);
            chs   = chs(~cell_ch(cell, chs)); %Filter used channels in the cell
            cell_ch(cell, chs) = user;
            X(user, chs) = 1;
        end
        %evaluate
        [fitness, usersCapacity] = matrixFF(X);
    end
    function [fitness, usersCapacity, X] = CBA(x)
        %transform x to X
        if max(max(x))<=1
            x = ceil(x * net.NoChs);
        end
        active_Q = size(net.cells_users,2);
        cell_ch = zeros(active_Q, net.NoChs);
        X = zeros(net.U, net.NoChs);
        for c = 1:active_Q
            initial = x(c);
            users = net.cells_users{c};
            for i = 1:size(users, 1)
                chs = initial:initial + net.required_channels(users(i)) - 1;
                initial = initial + net.required_channels(users(i));
                if(chs(end) > net.NoChs)
                    chs = mod(chs, net.NoChs); %RING STYLE
                    chs(chs==0) = net.NoChs;
                end
                chs = chs(~cell_ch(c, chs)); %Dont allow overflow
                cell_ch(c, chs) = users(i);
                X(users(i), chs) = 1;
            end
        end
        %evaluate
        tic
        [fitness, usersCapacity] = bigMatrixFF(cell_ch);
        fitness
        toc
        tic
        [fitness, usersCapacity] = matrixFF(X);
        fitness
        toc
    end
end
