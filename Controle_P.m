
%set publisher
msg_twist = rosmessage('geometry_msgs/Twist') ;

pub_twist = rospublisher("/turtle1/cmd_vel",'geometry_msgs/Twist');

%set subscriber
sub_pose = rossubscriber("/turtle1/pose");

pose_data = receive(sub,10); 

target_x = 7;
target_y = 0; 

kp = 1;

error_linear = target_x - pose_data.X ;
error_angular = atan2(target_y-pose_data.Y,target_x-pose_data.X);

while(error_linear < 0.1)
    error_linear = target_x - pose_data.X ;
    vel_linear = error_linear*kp ;
    
    msg_twist.Linear.X = vel_linear;
    
    disp(vel_linear);
        
    send(pub_twist,msg_twist);
end


msg_twist.Linear.X =0;
send(pub_twist,msg_twist);

disp(pose_data.X);
disp(pose_data.Y);
error_angular = atan2(target_y-pose_data.Y,target_x-pose_data.X);




