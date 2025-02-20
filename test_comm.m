rosinit('10.0.0.180'); % IP do ROS Master
armPublisher = rospublisher('/arm_controller/command', 'trajectory_msgs/JointTrajectory');
pause(2);
trajMsg = rosmessage(armPublisher);
trajMsg.JointNames = {'joint1', 'joint2', 'joint3', 'joint4', 'joint5', 'r_joint'};

% Adicione o ponto desejado
point = rosmessage('trajectory_msgs/JointTrajectoryPoint');
point.Positions = [0 0 0 0 0]; % Ângulos desejados (em radianos)
point.TimeFromStart = rosduration(1.5); % Tempo para atingir os ângulos

trajMsg.Points = point;
send(armPublisher, trajMsg);

rosshutdown;
