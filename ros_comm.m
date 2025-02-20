% remotely connect to ros
rosinit('10.0.0.180')

% i inserted try/catch so that in case of any error it terminates the connection
% anyway
try
%     disp('listing nodes -------------------------------------');
%     rosnode list
%     disp('end of nodes list ---------------------------------');

%     list the possible topics from the ros
    rostopic list
    
    txt = input('Choose a topic to view its info\n', "s");
    topic_info = rostopic("info", txt);

    disp(topic_info)
    disp(topic_info.Publishers)
    disp(topic_info.Subscribers)
    
    answer = input('Create subscriber?\n', "s");
    if answer == 'y'
        sub = rossubscriber(txt, "DataFormat", "struct");
        pause(2);
        data = receive(sub, 10);
        disp(data);

        write = input('Write to file?\n', 's');
        
        % inserted the option to write the response to a file bc it's
        % specially useful when it receives an image as a response
        if write == 'y'
            filename = input('Write file name with ext:\n', 's');
            fileid = fopen(filename, 'w');
            fwrite(fileid, data.Data);
            fclose(fileid);
        end
    end

    answer = input('Create publisher?\n', "s");
    if answer == 'y'
%         rosmsg list
        type = input('Choose type of message\n', 's');
        pub = rospublisher(txt, type, "DataFormat", "struct");
        pause(2);
        msg = rosmessage(pub);
        msg_data = input('Insert value of the message\n');
        msg.Data = msg_data;
%         joints_angles = [0 0 0 0];
%         msg.Name = {'joint1', 'joint2', 'joint3', 'joint4', 'joint5', 'r_joint'};
%         msg.Position = joints_angles;
        send(pub, msg);
        pause(2)
        disp('command sent')
% 
%         sub = rossubscriber('/joint_states', 'DataFormat', 'struct');
%         pause(1);
%         lastState = sub.LatestMessage.Position;
%         disp(lastState);
    end
catch error
    disp('An error occurred')
    disp(error.message)
    rosshutdown
end

rosshutdown