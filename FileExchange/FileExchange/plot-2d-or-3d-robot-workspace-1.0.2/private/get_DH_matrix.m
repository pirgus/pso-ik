% Generic link transform function that generates a homogeneous transform
% matrix from the DH parameters.
function T = get_DH_matrix(a,alpha,d,theta)
T = [cos(theta) -sin(theta) 0 a
     sin(theta)*cos(alpha) cos(theta)*cos(alpha) -sin(alpha) -sin(alpha)*d
     sin(theta)*sin(alpha) cos(theta)*sin(alpha)  cos(alpha)  cos(alpha)*d
     0 0 0 1];
end