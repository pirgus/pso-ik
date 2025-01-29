function e = errorFunction(joint_angles, goal, robot)
    current_pose = forwardKinematics(joint_angles, robot, false, 'body4');
    e = norm(current_pose - goal);
end