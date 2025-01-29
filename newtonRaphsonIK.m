function q = newtonRaphsonIK(x_des, q0, tol, max_iter, robot)
    % x_des: Desired end-effector pose
    % q0: Initial guess for joint angles
    % tol: Tolerance for convergence
    % max_iter: Maximum number of iterations

    q = q0; % Initialize joint angles
    for iter = 1:max_iter
        e = errorFunction(q(:, 3), x_des, robot); % Compute error
        if norm(e) < tol
            break; % Convergence achieved
        end
        J = computeJacobian(q, robot); % Compute Jacobian
        dq = pinv(J) * e; % Update joint angles (use pseudo-inverse for robustness)
        q = q + dq;
    end
end