function random_configs = get_random_position(joint_limits)
    random_configs = zeros(1, length(joint_limits));
    for i = 1:length(joint_limits)
        random_config = (joint_limits)*rand;
        random_configs(i) = random_config;
    end
end