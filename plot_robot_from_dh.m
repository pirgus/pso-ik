% DH parameters
test_dh = [0   pi/2 4.5 0;
           9.8 0    0   0;
           9.5 0    0   0;
           3.5 pi/2 0   0]

robot = rigidBodyTree;

bodies = cell(4, 1);
joints = cell(4, 1);

for i = 1:4
    bodies{i} = rigidBody(['body', num2str(i)]);
    joints{i} = rigidBodyJoint(['jnt', num2str(i)], 'revolute');
    setFixedTransform(joints{i}, test_dh(i,:), "dh");
    bodies{i}.Joint = joints{i};
    if i == 1 % add first body to base
        addBody(robot, bodies{i}, "base");
    else % add current body to previous body by name
        addBody(robot, bodies{i}, bodies{i-1}.Name);
    end
end

% vetorzinho de angulos que serao aplicados a cada junta, respectivamente
angles = [pi/4, pi/6, pi/3, pi/2];
% armazenando as configuracoes do robo
config = homeConfiguration(robot);

for i = 1:length(angles)
    % aplicar os angulos definidos em angles a cada uma das juntas
    % respectivas
    config(i).JointPosition = angles(i);
end

% calculo da transformação do efetuador
end_effector_transform = getTransform(robot, config, 'body4');
% obtendo apenas a posição final do efetuador
end_effector_position = end_effector_transform(1:3, 4);
disp('Posição final do efetuador (em coordenadas do mundo):');
disp(end_effector_position);

showdetails(robot)
show(robot, config); % mostrar o robo com as config de juntas definidas

% fazendo uma esfera para mostrar o objetivo do robo
object_radius = 1;
object_position = [10, 7, 24];

% mostrando a esfera
hold on;
[x, y, z] = sphere;
surf(object_radius*x + object_position(1), ...
    object_radius*y + object_position(2), ...
    object_radius*z + object_position(3), 'FaceColor', 'r');
title('Robô e Objeto a Ser Pegado');

% interactive view of the robot
%gui = interactiveRigidBodyTree(robot,"MarkerScaleFactor",8);