scanData = rosmessage('sensor_msgs/LaserEcho') ;

cmd_vel = rosmessage('geometry_msgs/Twist') ;

pub_cmdVel = rospublisher("/cmd_vel",'geometry_msgs/Twist');
subLaser = rossubscriber("scan"); 

scanData = receive(subLaser,10) ;
figure 

plot(scanData,"MaximumRange",7); 

xy = readCartesian(scanData) ;

cmd_vel.Linear.X = 1;

while(true)
    
 scanData = receive(subLaser,10) ;
 plot(scanData,"MaximumRange",7); 
 xy = readCartesian(scanData) ;
 minimo = min(xy);
 disp(minimo(2));
if( -minimo(2) < 1) 
    
    cmd_vel.Linear.X = 0;
end

send(pub_cmdVel,cmd_vel);

end
