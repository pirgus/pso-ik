function fitness = particle_fitness(particle)
    % Função para calcular o fitness, a distância do end-effector até o objetivo
    global goal robot  % Acessa as variáveis globais

    % Calcula a posição do end-effector com base na posição das juntas (posição da partícula)
    end_effector_pos = forward_kinematics(particle.position, robot, false);
    
    % Calcula o fitness como a norma (distância) entre o end-effector e o objetivo
    fitness = norm(end_effector_pos - goal);
end
