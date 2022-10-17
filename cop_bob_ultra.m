%cria a mensagem 



cmd_vel = rosmessage('geometry_msgs/Twist') ;
 
odom = rosmessage('nav_msgs/Odometry');

ultrassom = rosmessage('std_msgs/Float32'); 
%cria o publisher 

pub_cmdVel = rospublisher("/cmd_vel",'geometry_msgs/Twist');

sub_odom = rossubscriber("/odom");

sub_ultrassom = rossubscriber("/ultrassom");

odom_data = receive(sub_odom,10); 

ultrassom_data = receive(sub_ultrassom,10); 

cmd_vel.Linear.X = 0;
cmd_vel.Angular.Z = 0;

target_x = 2;
target_y = 2; 

kp_linear = 0.5;
kp_angular = pi/20;


error_angular = 99;
error_linear =  99;


while(abs(error_angular) > pi/10)
    odom_data = receive(sub_odom,10); 
    Quaternion_ros = odom_data.Pose.Pose.Orientation ;
    quat = [odom_data.Pose.Pose.Orientation.X odom_data.Pose.Pose.Orientation.Y odom_data.Pose.Pose.Orientation.Z odom_data.Pose.Pose.Orientation.W];
        %z in radians de - pi a pi 
    Z = quat2angle(quat,'XYZ');
    X = (odom_data.Pose.Pose.Position.X);
    Y = (odom_data.Pose.Pose.Position.Y);
    
    disp("---------------------");
    
    desired_angle = atan2((target_y-Y),(target_x-X));
    
    disp(desired_angle);
    disp(Z);
    if(Z < 0) 
        Z = abs(Z);
    end
    error_angular = desired_angle - Z;
    
    disp(error_angular);
    
    vel_angular = error_angular*kp_angular;
    
    disp(vel_angular);
    cmd_vel.Angular.Z = vel_angular;
    
    send(pub_cmdVel,cmd_vel);
end
cmd_vel.Angular.Z = 0;
send(pub_cmdVel,cmd_vel);

    while(abs(error_linear) > 0.5)

        odom_data = receive(sub_odom,10); 
        ultrassom_data = receive(sub_ultrassom,10); 
        %linear 
        X = (odom_data.Pose.Pose.Position.X);
        Y = (odom_data.Pose.Pose.Position.Y);

        %%angular 

        Quaternion_ros = odom_data.Pose.Pose.Orientation ;


        quat = [odom_data.Pose.Pose.Orientation.X odom_data.Pose.Pose.Orientation.Y odom_data.Pose.Pose.Orientation.Z odom_data.Pose.Pose.Orientation.W];

        %z in radians de - pi a pi 
        Z = quat2angle(quat,'XYZ');


    %     
         disp("---------");
         disp(X);
         disp(Y);
         disp(Z);
         disp("------");
         disp( ultrassom_data.Data) ;


        error_linear =  hypot((target_x - X),(target_y - Y));

        desired_angle = atan2((target_y-Y),(target_x-X));
        
        error_angular = desired_angle - Z;




%         if(error_angular<0 && Z > 0)
%                 error_angular = (desired_angle - Z) + 2*pi; 
%         end
        
        
        
        vel_angular = error_angular*kp_angular;
        vel_linear = error_linear*kp_linear;

        cmd_vel.Linear.X = vel_linear;
        
      
        %disp(vel_linear);
        %disp(error_linear);
        if(ultrassom_data.Data >=0.5)
              cmd_vel.Linear.X =-0;
              cmd_vel.Angular.Z = 2*pi;
              disp("perdeu");
        end
        
        send(pub_cmdVel,cmd_vel);

%     disp(error_angular);
    end

%  cmd_vel.Linear.X =0.1;
%  cmd_vel.Angular.Z = pi;
%  send(pub_cmdVel,cmd_vel);
% end 

cmd_vel.Linear.X =0;
cmd_vel.Angular.Z = 0;
send(pub_cmdVel,cmd_vel);



   