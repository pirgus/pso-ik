function [x, y, z] = get_xyz_expressions(dh_parameters, dh_transform_fn, verbose)
%GET_XYZ_EXPRESSIONS Calculates the x, y, and z positions from Denavit-Hartenberg parameters.
%
% Syntax:
%   [x, y, z] = get_xyz_expressions(dh_parameters, dh_transform_fn, verbose)
%
% Inputs:
%   dh_parameters: A matrix containing the Denavit-Hartenberg parameters.
%                  Each row represents one link, and the columns are 
%                  [a,alpha,d,theta] for each link.
%
%   dh_transform_fn: Function handle to a function that computes the 
%                    Denavit-Hartenberg transformation matrix. This 
%                    function should accept four arguments corresponding 
%                    to the four Denavit-Hartenberg parameters (a,alpha,d,theta).
%
%   verbose: A boolean flag that, when true, triggers the function to 
%            display the final transformation matrix and the expressions 
%            for position.
%
% Outputs:
%   x, y, z: The symbolic expressions for the x, y, and z coordinates of 
%            the end-effector (i.e., the position of the end-effector in 
%            the base frame).
%
    % Calculate transformation matrix from base to end-effector
    T0_ee = eye(4);
    % Apply each transformation
    for i = 1:size(dh_parameters, 1)
        T{i} = dh_transform_fn(dh_parameters(i,1), ...
            dh_parameters(i,2), ...
            dh_parameters(i,3), ...
            dh_parameters(i,4));
        T0_ee = T0_ee*T{i};
    end

    x = T0_ee(1,4);
    y = T0_ee(2,4);
    z = T0_ee(3,4);

    if verbose
        disp('final transformation matrix from base to end-effector:')
        disp(T0_ee)
        disp('expressions for position:')
        fprintf('x = %s\n', char(x))
        fprintf('y = %s\n', char(y))
        fprintf('z = %s\n', char(z))
    end

end
