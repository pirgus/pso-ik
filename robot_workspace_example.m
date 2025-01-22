syms theta1 theta2 theta3 theta4 real
syms d1 d2 d3 d4 real

% DH parameters
test_dh = [0   pi/2 4.5 theta1; ...
           9.8 0    0   theta2; ...
           9.5 0    0   theta3; ...
           3.5 pi/2 0   theta4]

amostras = 12;
% Parameter ranges
theta1_range = arr2Rad(linspace(0, 340, amostras));  % Intervalo de theta1
theta2_range = arr2Rad(linspace(0, 180, amostras));  % Intervalo de theta2
theta3_range = arr2Rad(linspace(0, 270, amostras));  % Intervalo de theta3
theta4_range = arr2Rad(linspace(0, 180, amostras));  % Intervalo de theta4
%theta5_range = arr2Rad(linspace(0, 340, 15));  % Intervalo de theta5

test_map = containers.Map({'theta1', 'theta2', 'theta3', 'theta4'}, ...
    {theta1_range, theta2_range, theta3_range, theta4_range});
% Workspace plotting function


figure(1)
subplot(2, 2, 1);
plot3dworkspace(test_dh, test_map, @get_alternative_dh_transform, false)
title('Espaço de trabalho completo - visão tridimensional');
xlabel('X') 
ylabel('Y')
zlabel('Z')

subplot(2, 2, 2);
plot3dworkspace(test_dh, test_map, @get_alternative_dh_transform, false, 1, false)
title('Espaço de trabalho fatiado no eixo X');
xlabel('X') 
ylabel('Y')
zlabel('Z')

subplot(2, 2, 3);
plot3dworkspace(test_dh, test_map, @get_alternative_dh_transform, false, 2, false)
title('Espaço de trabalho fatiado no eixo Y');
xlabel('X') 
ylabel('Y')
zlabel('Z')

subplot(2, 2, 4);
plot3dworkspace(test_dh, test_map, @get_alternative_dh_transform, false)
title('Espaço de trabalho completo - visão de topo');
xlabel('X') 
ylabel('Y')
zlabel('Z')

function out = arr2Rad(A)
    out = arrayfun(@(angle) deg2rad(angle), A);
end

function T = get_alternative_dh_transform(a,alpha,d,theta)
T = [cos(theta) -cos(alpha)*sin(theta) sin(alpha)*sin(theta) a*cos(theta)
     sin(theta) cos(alpha)*cos(theta) -sin(alpha)*sin(theta) a*sin(theta)
     0 sin(alpha) cos(alpha) d
     0 0 0 1];
end