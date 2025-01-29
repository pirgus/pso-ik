         % a    alp  d    theta  
test_dh = [0    pi/2 0.45  0;
           0.98 0     0    0;
           0.95 0     0    0;
           0.8 pi/2  0    0];
global goal
n_bodies = size(test_dh, 1);
joints_limits = [pi, pi, pi/2, pi/2];
goal = [-1; 1.2; 0.9];
robot = generate_robot(test_dh, n_bodies, n_bodies, joints_limits);
config = homeConfiguration(robot);
show(robot);

config_nr = newtonRaphsonIK(goal, [0 0 0; 0 0 pi/2; 0 0 0; 0 0 0], 0.000001, 100, robot);

end_effector_pos = forwardKinematics(config_nr, robot, true, 'body4');