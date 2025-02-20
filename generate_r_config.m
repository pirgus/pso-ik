function r_config = generate_r_config(robot)
    r_config = zeros(1, length(robot));
    for i = 1:length(robot.Bodies)
        joints_limits = robot.Bodies{i}.Joint.PositionLimits;
        r_config(i) = joints_limits(1) + (joints_limits(2) - joints_limits(1)) * rand;
    end
    
end