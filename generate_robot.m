function robot = generate_robot(dh_params, n_bodies, n_joints, joint_limits)
    robot = rigidBodyTree;
    bodies = cell(n_bodies, 1);
    joints = cell(n_joints, 1);

    for i = 1:n_bodies
        bodies{i} = rigidBody(['body', num2str(i)]);
        joints{i} = rigidBodyJoint(['jnt', num2str(i)], 'revolute');
        joints{i}.PositionLimits = [-joint_limits(i) joint_limits(i)];
        if i == 2
            joints{i}.HomePosition = pi/2;
        end
        setFixedTransform(joints{i}, dh_params(i,:), "dh");
        bodies{i}.Joint = joints{i};
        if i == 1 % add first body to base
            addBody(robot, bodies{i}, "base");
        else % add current body to previous body by name
            addBody(robot, bodies{i}, bodies{i-1}.Name);
        end
    end

end
