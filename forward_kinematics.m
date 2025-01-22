function end_effector_pos = forward_kinematics(joint_angles, robot, show_r)
    global goal
    config = homeConfiguration(robot);
    for i = 1:length(joint_angles)
        config(i).JointPosition = joint_angles(i);
    end
    end_effector_transform = getTransform(robot, config, 'body4');
    end_effector_pos = end_effector_transform(1:3, 4)';

    if show_r
        show(robot, config);
        hold on;
        plot3(goal(1), goal(2), goal(3), 'o', 'Color', 'r');
    end
end