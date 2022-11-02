% para poder utilizar este scrip, primeiramente inicie o turtlesim node com
% o comando: 
% rosrun turtlesim turtlesim_node

% rosinit; 

% ------- config publisher
msg_twist = rosmessage('geometry_msgs/Twist') ;
pub_twist = rospublisher("/cmd_vel",'geometry_msgs/Twist');

% ------- config subscriber
sub_odom = rossubscriber("odom");
odom_data = receive(sub_odom,10); 

% setpoint y
target_y = 3.5;

% constantes PID linaer 
kp_linear = 0.5;
ki_linear = 0.1; 
kd_linear = 0.1; 

% variavais para calculo deltaT
elapsedTime = 0; 
previous_time = clock;

previous_error_linear = 0;

vel_linear_integral = 0;


error_linear =  hypot((target_x - odom_data.Pose.Pose.Position.X),(target_y - odom_data.Pose.Pose.Position.Y)); 

while(abs(error_linear) > 1)
    
    odom_data = receive(sub_odom,10); 
        
    error_linear =  target_y - odom_data.Pose.Pose.Position.Y; 

    % Delta T para calculo de derivada e integral
    elapsedTime = etime(clock, previous_time); 
    
    % ------- integral 
    vel_linear_integral = (error_linear*ki_linear*elapsedTime) + vel_linear_integral;

    % ------- devidada 
    vel_linear_derivative = (error_linear- previous_error_linear)/elapsedTime; 

    % ------- proporcional 
    vel_linear_proporcional = error_linear*kp_linear;

    % ------ calculo PID 
    vel_linear = vel_linear_proporcional + vel_linear_integral + vel_linear_derivative; 
    
    disp(error_linear);
    disp("-------"); 
    disp(vel_linear); 
    
    plot(vel_linear);
    
    msg_twist.Linear.X = vel_linear;
    msg_twist.Angular.Z = 0;

    send(pub_twist,msg_twist);
    
    previous_time = clock; 

    previous_error_linear = error_linear;

end

msg_twist.Linear.X =0;
msg_twist.Angular.Z = 0;
    
send(pub_twist,msg_twist);





