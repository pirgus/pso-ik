function J = computeJacobian(fk_func, q)
    % Compute the Jacobian matrix numerically
    epsilon = 1e-6; % Small perturbation
    n = length(q);
    J = zeros(3, n);
    current_pos = fk_func(q);

    for i = 1:n
        q_perturbed = q;
        q_perturbed(i) = q_perturbed(i) + epsilon;
        perturbed_pose = fk_func(q_perturbed);

        J(:, i) = (perturbed_pose - current_pos) / epsilon;
    end
end