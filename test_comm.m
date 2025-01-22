rosinit('192.168.149.1'); % IP do ROS Master
pub = rospublisher('/joint2_controller/command', 'std_msgs/Float64', 'DataFormat', 'struct');
pause(2);
msg = rosmessage(pub);
msg.Data = 0.5966; % Valor fixo para teste
send(pub, msg);
pause(2);
rosshutdown;
