
%cria o servico
turtle_reset = rossvcclient('/reset');
 
%chama o servico
call(turtle_reset);

%set publisher
msg_twist = rosmessage('geometry_msgs/Twist') ;

pub_twist = rospublisher("/turtle1/cmd_vel",'geometry_msgs/Twist');

%set subscriber
sub_pose = rossubscriber("/turtle1/pose");

pose_data = receive(sub_pose,10); 

target_x = 9;
target_y =  9; 

kp_linear = 1;
kp_angular = 2*pi;



error_linear = target_x - pose_data.X ;

error_angular = atan(target_y-pose_data.Y/target_x-pose_data.X);



while(abs(error_linear) > 0.1 && abs(error_angular) > pi/100)
    
    pose_data = receive(sub_pose,10); 
    error_linear = target_x - pose_data.X ;
    error_angular = - pose_data.Theta + atan(target_y/target_x);
    
    disp(pose_data.Theta)
    
    vel_angular = error_angular*kp_angular;
    vel_linear = error_linear*kp_linear ;
    
    msg_twist.Linear.X = vel_linear;
    msg_twist.Angular.Z = vel_angular;
    
    
    %disp(vel_linear);
    %disp(error_linear);

    send(pub_twist,msg_twist);
end


msg_twist.Linear.X =0;
msg_twist.Angular.Z = 0;
send(pub_twist,msg_twist);

disp(pose_data.X);
disp(pose_data.Y);
error_angular = atan2(target_y-pose_data.Y,target_x-pose_data.X);




