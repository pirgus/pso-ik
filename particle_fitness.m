function fitness = particle_fitness(particle)
    % function to calc the particle's fitness, the distance between the end
    %-effector and the goal
    global goal robot  % access global vars

    % calculates the position of the end-effector based on the joints
    % positions
    end_effector_pos = forward_kinematics(particle.position, robot, false);

    joint2_real_value = -(pi/2) + particle.position(2);
    penalty = 0;
    if joint2_real_value < -(pi/2) || joint2_real_value > (pi/2)
        % apply penalty when this angle is lesser than -90º or greater 90º
        % since the joint cannot achieve this position 
        penalty = abs(joint2_real_value - max(min(joint2_real_value, pi/2), -pi/2))* 100;
    end
    
    % calculates the fitness with the norm (distance) between the
    % end-effector and the goal
    fitness = norm(end_effector_pos - goal) + penalty;
end
