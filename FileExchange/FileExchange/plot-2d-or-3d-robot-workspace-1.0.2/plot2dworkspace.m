function plot2dworkspace(dh_parameters, parameter_ranges, dh_transform_fn, unused_position_threshold, verbose)
%PLOT2DWORKSPACE Plots a 2D representation of the reachable workspace of a robot.
%
% Syntax:
%   plot2dworkspace(dh_parameters, parameter_ranges, dh_transform_fn, unused_position_threshold, verbose)
%
% Inputs:
%   dh_parameters: A matrix containing the Denavit-Hartenberg parameters
%                  (unknown parameters as symbolic variables)
%                  Each row represents one link, and the columns are 
%                  [a,alpha,d,theta] for each link.
%
%   parameter_ranges: A containers.Map object where the keys are the names 
%                     of the parameters (as strings), and the values are arrays 
%                     of the values that each parameter can take.
%
%   dh_transform_fn: (Optional) Function handle to a function that computes the 
%                    Denavit-Hartenberg transformation matrix. This 
%                    function should accept four arguments corresponding 
%                    to the four Denavit-Hartenberg parameters (a,alpha,d,theta).
%                    Default: @get_DH_matrix.
%
%   unused_position_threshold: (Optional) A threshold below which a position is 
%                              considered to be effectively zero. Default: 0.0001.
%
%   verbose: (Optional) A boolean flag that, when true, triggers the function to 
%            display various calculation details like the transformation matrix 
%            and more. Default: false.
%
% Outputs:
%   No outputs. The function directly plots the reachable workspace.
%
% Example:
%   dh_parameters = [0 0 d1 0; 0 -pi/2 d2 pi/2; 0 -pi/2 0 theta3; 1 0 0 0;];
%   parameter_ranges = containers.Map({'d1', 'd2', 'theta3'},{2:0.1:3, 2:0.1:3, 0:pi/20:2*pi});
%   plot2dworkspace(dh_parameters, parameter_ranges, @get_DH_matrix, 0.0001, true);
%
    arguments
        dh_parameters
        parameter_ranges
        dh_transform_fn = @get_DH_matrix
        unused_position_threshold = 0.0001
        verbose = false % Whether to log various calculation details like the transformation matrix and more.
    end

    validate_inputs(dh_parameters, parameter_ranges);
    [x,y,z] = get_xyz_expressions(dh_parameters, dh_transform_fn, verbose);
    

    % Get parameter grid
    if verbose
        ranges = values(parameter_ranges);        
        lengths = cellfun(@length, ranges);        
        product_of_lengths = prod(lengths);
        fprintf('allocating %d possible DH parameter combinations...\n', product_of_lengths);
    end

    keys = parameter_ranges.keys;
    param_values = parameter_ranges.values(keys);
    [param_grid{1:numel(param_values)}] = ndgrid(param_values{:});
    
    % Reshape into value arrays in map
    param_value_map = containers.Map;
    for i = 1:numel(param_grid)
        param_value_map(keys{i}) = reshape(param_grid{i}, 1, []);
        param_grid{i} = 0;
    end
    

    if verbose
        disp('calculating positions from expressions...');
    end
    % Calculate x,y,z positions
    positions = cell(3,1);
    expressions = {x,y,z};
    for i = 1:3
        % Get variables from expression
        expr = expressions{i};
        sym_cell = symvar(expr);
        keys_cell = arrayfun(@char, sym_cell, 'UniformOutput', false);
        % Convert from symbolic to numerical functions for faster evaluation
        pos_func = matlabFunction(expr, 'Vars', sym_cell);
        func_params = values(param_value_map, keys_cell);
        positions{i} = pos_func(func_params{:});
    end

    % Determine the largest absolute value in each cell
    minValues = cellfun(@(x) max(abs(x(:))), positions);
    axis_labels = {'X','Y','Z'};
    
    % Get the smallest value from all cells
    [~, min_idx] = min(minValues);

    if minValues(min_idx) > unused_position_threshold
        error(['With a 2D workspace, it is expected that one of the X,Y,Z positions' ...
            ' is always near 0 (< %d). Instead the smallest candidate %s has a max position magnitude of' ...
            '%d'], unused_position_threshold, axis_labels{min_idx}, minValues(min_idx))
    end

    % Plot results
    chosen_indices = true(size(axis_labels));
    chosen_indices(min_idx) = false;
    chosen_positions = positions(chosen_indices);
    chosen_axes = axis_labels(chosen_indices);

    figure(1)
    plot(chosen_positions{:},'.');
    title('Reachable Workspace')
    xlabel(chosen_axes{1}) 
    ylabel(chosen_axes{2}) 
    axis equal
    grid on
end