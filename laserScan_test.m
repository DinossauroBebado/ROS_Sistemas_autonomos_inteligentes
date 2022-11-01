scanData = rosmessage('sensor_msgs/LaserEcho') ;

cmd_vel = rosmessage('geometry_msgs/Twist') ;

pub_cmdVel = rospublisher("/cmd_vel",'geometry_msgs/Twist');
subLaser = rossubscriber("scan"); 

scanData = receive(subLaser,10) ;
 figure 

plot(scanData,"MaximumRange",7); 

xy = readCartesian(scanData);






while(true)
    
 scanData = receive(subLaser,10) ;

 
  left = scanData.Ranges(1:170);
  middle = scanData.Ranges(171:341);
  right = scanData.Ranges(342: end);

  min(right)
  plot( xy)
  
  if((min(right))<0.4)
    cmd_vel.Linear.X = 0;
  end

 
% if( -minimo(2) < 1) 
%     
%     cmd_vel.Linear.X = 0;
% end


send(pub_cmdVel,cmd_vel);

end
