


%while true

%[CH,DT] = getkeywait(1) ;

%disp(CH)

%if CH == 113
%    break 
%end 
%end
%
quit = 113 ; %q
forward = 119; %w
backward = 115 ; %s
left = 97 ; %a
right = 100; %d
stop = 101;

 

%cria a mensagem 

msg = rosmessage('geometry_msgs/Twist') ;

%cria o publisher 

pub = rospublisher("/turtle1/cmd_vel",'geometry_msgs/Twist');

while true 
    
    [key,DT] = getkeywait(1);
    
    if key == quit 
        break
    end
    
    if key == forward
        msg.Linear.X = 3;
    end
    
     if key == backward
        msg.Linear.X = -3;
     end
    
     if key == right
         msg.Angular.Z = pi/6;
     end 
     
      if key == left
         msg.Angular.Z = -pi/6;
      end 
      if key == stop
           msg.Angular.Z = 0;
           msg.Linear.X = 0;
      end
      
       
send(pub,msg);
end

