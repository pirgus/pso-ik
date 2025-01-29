function J = computeJacobian(q, robot)
    % Compute the Jacobian matrix numerically
    epsilon = 1e-6; % Small perturbation
    n = length(q);
    J = zeros(3, n);
    current_pose = forwardKinematics(q, robot, false, 'body4');

    for i = 1:n
        q_perturbed = q;
        q_perturbed(i) = q_perturbed(i) + epsilon;
        perturbed_pose = forwardKinematics(q_perturbed, robot, false, 'body4');
        J(:, i) = (perturbed_pose - current_pose) / epsilon;
    end
end