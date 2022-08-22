%cria a mensagem 

msg = rosmessage('geometry_msgs/Twist') ;

%cria o publisher 

pub = rospublisher("/turtle1/cmd_vel",'geometry_msgs/Twist');

msg.Linear.X = 0;




msg.Linear.X = 1;

msg.Angular.Z = pi/12;




t0 = clock ;

while(etime(clock,t0) < (4))
    send(pub,msg);
    
end
    
msg.Linear.X = 0;
msg.Angular.Z = 0;

send(pub,msg);

    
    