function net = reqChannels(net)
    % Calculate Required Channels
    bits_needed = ceil(net.users_r ./ net.Ch_b);
    bits_per_ch = floor(log2(1 + net.user_signal ./ (net.Noise + net.I_thr)));    %probably not needed
    required_channels = ceil(bits_needed ./ bits_per_ch');
    required_channels(required_channels==inf) = 0; %Users without service
    net.required_channels = required_channels;
end

