function net = association(net)
    % User Association
    [net.user_signal, net.association] = max(net.signal_user_cell, [], 2);
    [~, net.cells_active] = hist(net.association,unique(net.association));
    net.cell_association = cell(net.Q, 1);
    for i = 1:net.Q
        net.cell_association{i} = find(net.association==i);
    end
end

