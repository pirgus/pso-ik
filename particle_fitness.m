function fitness = particle_fitness(particle)
    % function to calc the particle's fitness, the distance between the end
    %-effector and the goal
    global goal robot % access global vars
    % calculates the position of the end-effector based on the joints
    % positions
    end_effector_name = strcat('body', num2str(length(particle.position)));
    end_effector_pos = forwardKinematics(particle.position, robot, false, end_effector_name);
%     
    % calculates the fitness with the norm (distance) between the
    % end-effector and the goal
    fitness = norm(end_effector_pos - goal);
end
