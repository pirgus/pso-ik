function r_config = generate_r_config(joints_limits)
    r_config = zeros(1, length(joints_limits));
    for i = 1:length(joints_limits)
%         rand * 2 - 1 -> returns a random value in the [-1, 1] interval
        r_config(i) = joints_limits(i)*(rand*2-1);
    end
end