% para poder utilizar este scrip, primeiramente inicie o turtlesim node com
% o comando: 
% rosrun turtlesim turtlesim_node

% rosinit; 

% cria o servico para limpar a tela do turtlesim
turtle_reset = rossvcclient('/reset');
 
% chama o servico
call(turtle_reset);

% ------- config publisher
msg_twist = rosmessage('geometry_msgs/Twist') ;
pub_twist = rospublisher("/turtle1/cmd_vel",'geometry_msgs/Twist');

% ------- config subscriber
sub_pose = rossubscriber("/turtle1/pose");
pose_data = receive(sub_pose,10); 

% coordenadas desenho da estrela
targets = [[3,3];[5,8];[7,3];[2,6];[8,6];[3,3]] ;

% constantes PI
kp_linear = 1;
kp_angular = 5;

% set coordenadas 
for t = 1:6
    
    target_x = targets(t,1);
    target_y = targets(t,2);
    
    disp("-----------------------------------------_");
    disp(target_x);
    disp(target_y);
    disp("-----------------------------------------_");

    error_linear =  hypot((target_x - pose_data.X),(target_y - pose_data.Y));
    error_angular =  99;   % fazer com que o scrip entre na condição while abaixo

    while(abs(error_angular) > pi/1000 && abs(error_linear) > 0.01)
        
        pose_data = receive(sub_pose,10); 
        
        setpoint_angle = atan2((target_y-pose_data.Y),(target_x-pose_data.X));

        error_linear =  hypot((target_x - pose_data.X),(target_y - pose_data.Y));
        error_angular = setpoint_angle - pose_data.Theta;

        % condição para complementar o angulo caso necessário
        if(error_angular<0 && pose_data.Theta > 0)
            error_angular = (setpoint_angle - pose_data.Theta) + 2*pi; 
        end

        vel_linear = error_linear*kp_linear;
        vel_angular = error_angular*kp_angular;

        msg_twist.Linear.X = vel_linear;
        msg_twist.Angular.Z = vel_angular;

        send(pub_twist,msg_twist);
    end

    msg_twist.Linear.X =0;
    msg_twist.Angular.Z = 0;
    
    send(pub_twist,msg_twist);

    disp(pose_data.X);
    disp(pose_data.Y);

end



