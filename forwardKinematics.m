function end_effector_pos = forwardKinematics(joint_angles, robot, show_r, end_effector_name)
    global goal
    new_config = robot.homeConfiguration;
    for i = 1:length(joint_angles)
        new_config(i).JointPosition = joint_angles(i);
    end
    end_effector_transform = getTransform(robot, new_config, end_effector_name);
    end_effector_pos = end_effector_transform(1:3, 4)';
end