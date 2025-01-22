% DH parameters
test_dh = [0   pi/2 4.5 0;
           9.8 0    0   0;
           9.5 0    0   0;
           3.5 pi/2 0   0]

robot = rigidBodyTree;

bodies = cell(4, 1);
joints = cell(4, 1);

for i = 1:4
    bodies{i} = rigidBody(['body', num2str(i)]);
    joints{i} = rigidBodyJoint(['jnt', num2str(i)], 'revolute');
    setFixedTransform(joints{i}, test_dh(i,:), "dh");
    bodies{i}.Joint = joints{i};
    if i == 1 % add first body to base
        collBase = collisionCylinder(2,3);
        collBase.Pose = trvec2tform([0 0 4/2]);
        addCollision(bodies{i}, collBase);
        addBody(robot, bodies{i}, "base");
    elseif i == length(bodies)
        %add collision sphere to end-effector
        collEndEffector = collisionSphere(1);
        collEndEffector.Pose = trvec2tform([0 -1 -1.5/2]);
        addCollision(bodies{i}, collEndEffector);
        addBody(robot, bodies{i}, bodies{i - 1}.Name);
    else % add current body to previous body by name
        collB = collisionBox(2, 1, 1.5);
        collB.Pose = trvec2tform([0 0 1.5/2]);
        addCollision(bodies{i}, collB);
        addBody(robot, bodies{i}, bodies{i-1}.Name);
    end
end

showdetails(robot)

% interactive view of the robot
%figure(Name="Braço robótico :)")
%gui = interactiveRigidBodyTree(robot,"MarkerScaleFactor",12);

%draw robot without interactive interface
%robot_config = homeConfiguration(robot)
%config(1).JointPosition = pi/2;
%show(robot, randomConfiguration(robot), Visuals="on", Collisions="off");
%drawnow;

[wksp,cfgs] = generateRobotWorkspace(robot,{});
mIndexYoshikawa = manipulabilityIndex(robot,cfgs,IndexType="yoshikawa");
show(robot);
hold on
showWorkspaceAnalysis(wksp,mIndexYoshikawa);
hold off
title("Yoshikawa index");
axis auto
