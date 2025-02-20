         % a    alp  d    theta  
test_dh = [0    pi/2 4.5  0;
           9.8 0     0    0;
           9.5 0     0    0;
           13.5 pi/2  0    0];

global goal
n_bodies = size(test_dh, 1);
joints_limits = [[-23*pi/36, 23*pi/36]; [0, pi]; [-pi/2, pi/2]; [-pi/2, pi/2]];
q_min = [-23*pi/36, 0, -pi/2, -pi/2];
q_max = [23*pi/36, pi, pi/2, pi/2];
goal = [15, 10, 13];
robot = generate_robot(test_dh, n_bodies, n_bodies, joints_limits);
home_config = homeConfiguration(robot);

% random_start = rand(4,1) * (-pi/2);
random_start = (-pi/2)+ pi * rand(4,1);
% random_start = generate_r_config(robot);
% disp(mat2str(random_start, 4));
[config_nr, error] = newtonRaphsonIK(goal, random_start, 1e-8, 1000, robot, q_min, q_max);
sim_config = config_nr;
config_nr(2) = -(pi/2) + config_nr(2);
disp(['found config = ', mat2str(config_nr, 4)]);


config = home_config;
end_effector_pos = forwardKinematics(config_nr, robot, true, 'body4');
for i = 1:length(joints_limits)
    config(i).JointPosition = sim_config(i);
end

disp(num2str(norm(error)));

% show(robot, config);
% hold on;
% plot3(goal(1), goal(2), goal(3), 'o', 'Color', 'r');
% drawnow()

% send_2_r = input('Send to robot?\n', "s");
send_2_r = 'n';
if send_2_r == 'y'
    rosinit('10.0.0.180'); % IP do ROS Master
    armPublisher = rospublisher('/arm_controller/command', 'trajectory_msgs/JointTrajectory');
    pause(2);
    trajMsg = rosmessage(armPublisher);
    trajMsg.JointNames = {'joint1', 'joint2', 'joint3', 'joint4', 'joint5', 'r_joint'};
    
    % Adicione o ponto desejado
    point = rosmessage('trajectory_msgs/JointTrajectoryPoint');
    point.Positions = [config_nr(1) config_nr(2) config_nr(3) config_nr(4) 0 0]; % Ângulos desejados (em radianos)
    point.TimeFromStart = rosduration(1.5); % Tempo para atingir os ângulos
    
    trajMsg.Points = point;
    send(armPublisher, trajMsg);
    
    rosshutdown;
end