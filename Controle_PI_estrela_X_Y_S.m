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

%target_x = 9;
%target_y = 0; 

targets = [[3,3];[5,8];[7,3];[2,6];[8,6];[3,3]] ;

kp_linear = 1;
kp_angular = 5;

ki_linear = 1000;
ki_angular = 1000;

elapsedTime = 0; 
previous_time = clock;


for t = 1:6
    target_x = targets(t,1);
    target_y = targets(t,2);
    disp("-----------------------------------------_");
    disp(target_x);
    disp(target_y);
    disp("-----------------------------------------_");

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

        %disp("angle:");
        %disp(desired_angle);
        %disp("theta");
        %disp(pose_data.Theta);
        %disp("error");
        %disp(error_angular);
        %disp("--------------");
        
        elapsedTime = etime(clock, previous_time); 
        
        vel_linear_integral = error_linear*ki_linear*elapsedTime;
        
        vel_linear = error_linear*kp_linear + vel_linear_integral;
        vel_angular = error_angular*kp_angular + error_angular*ki_angular*elapsedTime;

        msg_twist.Linear.X = vel_linear;
        msg_twist.Angular.Z = vel_angular;
        
        disp("vel_integral");
        disp(vel_linear_integral);

        %disp(vel_linear);
        %disp(error_linear);

        send(pub_twist,msg_twist);
        previous_time = clock; 
    end


msg_twist.Linear.X =0;
msg_twist.Angular.Z = 0;
send(pub_twist,msg_twist);

disp(pose_data.X);
disp(pose_data.Y);
error_angular = atan2(target_y-pose_data.Y,target_x-pose_data.X);

end


