test_dh = [0   pi/2 4.5 0;
           9.8 0    0   0;
           9.5 0    0   0;
           3.5 pi/2 0   0];
global goal robot
goal = [3, 4, 5];
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

% particle = Particle([pi/3, pi, pi/6, 0], [1, 2, 3, 2], 0.5, 2, 1);
% disp(particle);