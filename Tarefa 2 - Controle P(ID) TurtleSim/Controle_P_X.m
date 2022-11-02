
% para poder utilizar este scrip, primeiramente inicie o turtlesim node com
% o comando: 
% rosrun turtlesim turtlesim_node

%rosinit; 

% cria o servico para limpar a tela do turtlesim
turtle_reset = rossvcclient('/reset');
 
% chama o servico
call(turtle_reset);

% ------- publishers 
% cria a mensagem Twist e em seguida o tópico cmd_vel
msg_twist = rosmessage('geometry_msgs/Twist');
pub_twist = rospublisher("/turtle1/cmd_vel",'geometry_msgs/Twist');

% ------- subscriber
% cria a mensagem Pose e em seguida subscreve o tópico /turtle1/pose
sub_pose = rossubscriber("/turtle1/pose");

% recebe a posição atual de X
pose_data = receive(sub_pose,10); 

% setpoint em X
target_x = 0;

% coeficiente KP
kp_linear = 5;

error_linear = target_x - pose_data.X;

% o calculo do controle PID será feito enquanto o erro é maior que 1
% nesta parte recebemos a posição atual da tartaruga, calculamos o erro e com o KP podemos determinar a velocidade 
while(abs(error_linear) > 0.1)
    
    pose_data = receive(sub_pose,10); 
    
    error_linear =  target_x - pose_data.X;
        
    vel_linear = error_linear*kp_linear;
   
    msg_twist.Linear.X = vel_linear;
    
    % publica a velocidade para o cmd_vel
    send(pub_twist,msg_twist);
end

pose_data.X

% para a tartaruga quanto atingir o setpoint
msg_twist.Linear.X =0;
msg_twist.Angular.Z = 0;
send(pub_twist,msg_twist);


