
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
target_y = 0; 

kp_linear = 1;
kp_angular = 5;



error_linear =  hypot((target_x - pose_data.X),(target_y - pose_data.Y));
error_angular =  99;
%atan(target_y-pose_data.Y/target_x-pose_data.X);



while(abs(error_angular) > pi/1000 && abs(error_linear) > 0.01)
    
    
    pose_data = receive(sub_pose,10); 
    
    
    
    desired_angle = atan2((target_y-pose_data.Y),(target_x-pose_data.X));
    
   
    
   % error_angular = desired_angle - pose_data.Theta;
    
    
    error_linear =  hypot((target_x - pose_data.X),(target_y - pose_data.Y));
    error_angular = desired_angle - pose_data.Theta;
    
   
    
    
    if(error_angular<0 && pose_data.Theta > 0)
        error_angular = (desired_angle - pose_data.Theta) + 2*pi; 
    end
    
    disp("angle:");
    disp(desired_angle);
    disp("theta");
    disp(pose_data.Theta);
    disp("error");
    disp(error_angular);
    disp("--------------");
        
    vel_linear = error_linear*kp_linear;
   
    vel_angular = error_angular*kp_angular;
    
    
    
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




