function net = defaultUDN()
    net = {};
    
    % net Parameters
    net.Macro_power = 46;   % DBm
    net.Femto_power = 24;   % DBm
    net.Path_loss = -3;
    net.Bandwidth = 200e6;  % MHz
    net.NoChs = 1000;
    net.Noise = 1e-10;      % Watts
    net.Limit_snir = 6.3096;% 8dbs
    net.Area_square = 200;  % Mts

    % Problem Parameters
    net.Q = 200;            % cells
    net.U = 500;            % users
    net.D_fcs = 13;         % Min distance between cells
    net.D_u_c = 3.0;        % Min distance users-cell
    net.Demands_range = [10e6, 50e6]; %Mbps
    net.I_thr = 1e-8;       % Watts
end

