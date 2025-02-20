function [q, e] = newtonRaphsonIK(x_des, q0, tol, max_iter, robot, q_min, q_max)
    % x_des: Desired end-effector pose
    % q0: Initial guess for joint angles
    % tol: Tolerance for convergence
    % max_iter: Maximum number of iterations

    alpha = 0.2;

    q = q0(:); % Initialize joint angles
    for iter = 1:max_iter
        current_pos = forwardKinematics(q, robot, false, 'body4');
        e = x_des - current_pos;
        if norm(e) < tol
%             disp(['converged at iteration nº', num2str(iter)]);
            break; % Convergence achieved
        end
                        % this notation passes forwardKinematics as an
                        % anonymous function that, inside the
                        % computerJacobian fn, will only take q as an
                        % argument, while the other (robot, false, 'body4')
                        % will already be defined, without the need to
                        % recall them everytime
        J = computeJacobian(@(q) forwardKinematics(q, robot, false, 'body4'), q);
        dq = pinv(J) * e';
        q = q + dq * alpha;
        q = max(q_min', min(q, q_max'));
    end
end