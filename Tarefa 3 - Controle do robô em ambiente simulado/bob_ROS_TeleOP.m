% para poder utilizar este scrip, primeiramente inicie o turtlesim node com
% o comando: 
% rosrun turtlesim turtlesim_node

%rosinit; 

% valor teclas 
quit = 113 ;       %q
forward = 119;     %w
backward = 115;    %s
left = 97;         %a
right = 100;       %d
stop = 101;        %e

% -------- publishers 
msg = rosmessage('geometry_msgs/Twist');
pub = rospublisher("/cmd_vel",'geometry_msgs/Twist');

while true 

    % le a tecla utilizada no momento
    [key,DT] = getkeywait(1);
    
    if key == quit 
        msg.Linear.X = 0;
        msg.Angular.Z = 0;
        break
    end
    
    if key == forward
        msg.Linear.X = 3;
    end
    
    if key == backward
        msg.Linear.X = -3;
    end
    
    if key == right
        msg.Angular.Z = pi/3;
    end 
    
    if key == left
        msg.Angular.Z = -pi/3;
    end
    
    if key == stop
        msg.Angular.Z = 0;
        msg.Linear.X = 0;
    end

send(pub,msg);

end

