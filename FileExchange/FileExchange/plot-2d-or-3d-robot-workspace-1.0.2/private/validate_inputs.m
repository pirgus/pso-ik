function validate_inputs(dh_parameters, parameter_ranges)
    % validate_inputs Validates the inputs to the plotting functions.
    %
    % This function checks if the given DH parameters are a symbolic matrix and if the parameter ranges are 
    % a valid containers.Map object with each value as a numeric array. Also checks for symbol consistency
    % between dh_parameters and parameter_ranges.
    %
    % Parameters:
    %   dh_parameters : A symbolic matrix that represents the DH parameters of the robot.
    %   
    %   parameter_ranges : A containers.Map that represents the range of each DH parameter.
    %


    % Check DH parameters type
    if ~isa(dh_parameters, 'sym') || ~ismatrix(dh_parameters)
        error('dh_parameters must be a symbolic matrix')
    end

    % Validate the size of DH parameters
    [~, cols] = size(dh_parameters);
    if cols ~= 4
        error('dh_parameters must be a n-by-4 matrix for n links each with 4 DH parameters.')
    end
    
    % Validate that parameter_ranges is a containers.Map
    if ~isa(parameter_ranges, 'containers.Map')
        error('parameter_ranges must be a containers.Map')
    end

    % Validate that each value in b is a triple of numbers
    values_in_params = parameter_ranges.values();
    for i = 1:length(values_in_params)
        if ~isa(values_in_params{i}, 'double')
            error('Each parameter range must be an array of numbers')
        end
    end
    
    % Find all unique symbols in dh_parameters
    symbols_in_dh = arrayfun(@char, symvar(dh_parameters), 'UniformOutput', false);
    
    % Get all keys in the map ranges
    keys_in_ranges = parameter_ranges.keys();
    extra_dh = setdiff(symbols_in_dh, keys_in_ranges);
    extra_ranges = setdiff(keys_in_ranges, symbols_in_dh);
    
    % Check if the symbols are the same
    if ~isempty(extra_dh) || ~isempty(extra_ranges)
        error(['The symbols in dh_parameters and keys in parameter_ranges must be the same. ' ...
            'Excess in dh_parameters: %s. Excess in parameter_ranges: %s.'], strjoin(extra_dh, ', '), strjoin(extra_ranges, ', ')')
    end
end
