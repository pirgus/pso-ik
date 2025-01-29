global goal robot

         % a    alp  d    theta  
test_dh = [0    pi/2 0.45  0;
           0.98 0     0    0;
           0.95 0     0    0;
           0.8 pi/2  0    0]; % '0.8' just getting the actual full length to the tip of the gripper
                              % in order to compute the distance correctly. The measurement is actually 0.35  
%             0   0      0.45 0];
% having difficulties getting the dh params for the 5th joint...

n_bodies = size(test_dh, 1);
joints_limits = [pi, pi, pi/2, pi/2];
goal = [-1 1.2 0.9];
robot = generate_robot(test_dh, n_bodies, n_bodies, joints_limits);
config = homeConfiguration(robot);
show(robot);

pso = PSO_R(50, 50, 0.78, 1, 1, joints_limits, 1);

pso = pso.initParticles;

pso = pso.optmProcess;

result = pso.global_best{1};
result(2) = - (pi/2) + result(2);
disp(result);

disp(['global best by the end of the process (angles, fitness) ==> ', ...
    mat2str(pso.global_best{1}, 4 ...
    ), ', ', num2str(pso.global_best{2})]);

end_effector_pos = forwardKinematics(pso.global_best{1}, robot, true, 'body4');
disp(['final position of end_effector ==> ', mat2str(end_effector_pos, 5)]);
disp(['the goal was ==> ', mat2str(goal, 3)]);
