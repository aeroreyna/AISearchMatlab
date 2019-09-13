function h = plotNetwork(net)
    h = figure;
    hold on
    NoBs = size(net.cells_positions, 1);
    for i = 1:NoBs
        amp = 30;
        if(net.cells_power(i) > 10)
            amp = 40;
        end
        dTemp = norm(net.cells_positions(i, :)) / 500;
        color = [i/NoBs, dTemp, 1-i/NoBs ];
        %Draw Cell Circle
        circles(net.cells_positions(i, 1), net.cells_positions(i, 2), ...
            log2(1 + net.cells_power(i)) * amp, 'facecolor',color, ...
            'facealpha',0.2,'edgecolor','none');
        %Draw Users Associated
        users = net.association == i;
        plot(net.users_pos(users,1), net.users_pos(users,2), '.', 'Color', ...
            color, 'markersize', 12);
        %drawnow;
        %pause(0.01);        
    end
    %Draw Users without Service
    users = net.required_channels == 0;
    plot(net.users_pos(users,1), net.users_pos(users,2), '.', 'Color', ...
        [0,0,0] , 'markersize', 12);  
end

