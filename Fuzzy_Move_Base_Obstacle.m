

scanData = rosmessage('sensor_msgs/LaserEcho') ;

cmd_vel = rosmessage('geometry_msgs/Twist') ;

pub_cmdVel = rospublisher("/cmd_vel",'geometry_msgs/Twist');
subLaser = rossubscriber("scan"); 

scanData = receive(subLaser,10) ;

cmd_vetor = [0 0];
scan_vetor = [5 5 5];

cmd_vetor = evalfis(Fuzzy_Avoid_Obstacule_simple, scan_vetor);



while true
    
scanData = receive(subLaser,10) ;

left = min(scanData.Ranges(1:170));
middle = min(scanData.Ranges(171:341));
right = min(scanData.Ranges(342: end));

scan_vetor(1) = left ;
scan_vetor(2) = middle;
scan_vetor(3) = right ;

cmd_vetor = evalfis(Fuzzy_Avoid_Obstacule_simple, scan_vetor);
cmd_vel.Linear.X = cmd_vetor(1);
cmd_vel.Angular.Z = cmd_vetor(2);

disp(cmd_vetor)
disp(scan_vetor)

send(pub_cmdVel,cmd_vel);
end

