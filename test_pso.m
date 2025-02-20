global goal robot q_min q_max

         % a    alp  d    theta  
test_dh = [0    pi/2 4.5  0;
           9.8 0     0    0;
           9.5 0     0    0;
           13.5 pi/2  0    0]; 

n_bodies = size(test_dh, 1);
joints_limits = [[-23*pi/36, 23*pi/36]; [0, pi]; [-pi/2, pi/2]; [-pi/2, pi/2]];
q_min = [-23*pi/36, 0, -pi/2, -pi/2];
q_max = [23*pi/36, pi, pi/2, pi/2];
goal = [15, 10, 13];
robot = generate_robot(test_dh, n_bodies, n_bodies, joints_limits);
home_config = homeConfiguration(robot);

          % (n_particles, n_iterations, inertia_factor, cog_factor,
          % social_factor, joints_limits, verbose);
% pso = PSO_R(40, 40, 0.73, 0.31, 0.184, robot, 1e-5, q_min, q_max);
pso = PSO_R(15, 40, 0.7, 0.3, 0.8, robot, 1e-8, q_min, q_max);
pso = pso.initParticles;
pso = pso.optmProcess;
result = pso.global_best{1};
disp(['current result = ', mat2str(result)]);

result(2) = - (pi/2) + result(2);

for i = 1:length(joints_limits)
        home_config(i).JointPosition = pso.global_best{1}(i);
end

% show(robot, home_config);
% hold on;
% plot3(goal(1), goal(2), goal(3), 'o', 'Color', 'r');
% drawnow();

disp(['global best by the end of the process (angles, fitness) ==> ', ...
    mat2str(result, 4 ...
    ), ', ', num2str(pso.global_best{2})]);

end_effector_pos = forwardKinematics(pso.global_best{1}, robot, true, 'body4');
disp(['final position of end_effector ==> ', mat2str(end_effector_pos, 10)]);
disp(['the goal was ==> ', mat2str(goal, 3)]);

% send_2_r = input('Send to robot?\n', "s");
% % send_2_r = 'n';
% if send_2_r == 'y'
%     rosinit('10.0.0.180'); % IP do ROS Master
%     armPublisher = rospublisher('/arm_controller/command', 'trajectory_msgs/JointTrajectory');
%     pause(2);
%     trajMsg = rosmessage(armPublisher);
%     trajMsg.JointNames = {'joint1', 'joint2', 'joint3', 'joint4', 'joint5', 'r_joint'};
%     
%     % Adicione o ponto desejado
%     point = rosmessage('trajectory_msgs/JointTrajectoryPoint');
%     point.Positions = [result(1) result(2) result(3) result(4) 0 0]; % Ângulos desejados (em radianos)
%     point.TimeFromStart = rosduration(1.5); % Tempo para atingir os ângulos
%     
%     trajMsg.Points = point;
%     send(armPublisher, trajMsg);
%     
%     rosshutdown;
% end
