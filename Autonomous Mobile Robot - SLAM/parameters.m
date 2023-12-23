function [robo,field] = parameters()
%FIELD COORDINATES
field.topLeft  = [-5 3];      % [ft]
field.topRight = [5 3];       % [ft]
field.botLeft  = [-5 -3];     % [ft]
field.botRight = [5 -3];      % [ft]
field.dockLeftTop = [-5 .5];  % [ft]
field.dockLeftBot = [-5 -.5]; % [ft]
field.dockRightTop = [5 .5];  % [ft]
field.dockRightBot = [5 -.5]; % [ft]

%BEACON COORDINATES
field.leftBeacon = [-5,0];
field.rightBeacon = [5,0];

%OBSTACLE CENTER COODRINATES
obstRadius = .4;
theta02pi = linspace(0,2*pi,15)';
obst1pos = [0,0];
obst2pos = [2.5,1.5];
obst3pos = [-2.5,1.5];
obst4pos = [-2.5,-1.5];
obst5pos = [2.5,-1.5];
field.obst1 = [obstRadius*cos(theta02pi) + obst1pos(1) , obstRadius*sin(theta02pi) + obst1pos(2)];
field.obst2 = [obstRadius*cos(theta02pi) + obst2pos(1) , obstRadius*sin(theta02pi) + obst2pos(2)];
field.obst3 = [obstRadius*cos(theta02pi) + obst3pos(1) , obstRadius*sin(theta02pi) + obst3pos(2)];
field.obst4 = [obstRadius*cos(theta02pi) + obst4pos(1) , obstRadius*sin(theta02pi) + obst4pos(2)];
field.obst5 = [obstRadius*cos(theta02pi) + obst5pos(1) , obstRadius*sin(theta02pi) + obst5pos(2)];

%DETERMINE DIMS OF BOT
robo.center = [-4.5 0];
robo.center0 = robo.center;
robo.radius = .5;                       % [ft]
robo.theta = 0;                         % [deg]
robo.theta = robo.theta*pi/180;
robo.l = .4;                            % [ft]
robo.theta1 = asin(robo.l/robo.radius);
robo.theta2 = pi - robo.theta1;
robo.theta3 = robo.theta1 - pi;
robo.theta4 = -robo.theta1;

robo.wheelLeftTop =  [robo.radius*cos(robo.theta + robo.theta1) ; robo.radius*sin(robo.theta + robo.theta1)];
robo.wheelLeftBot =  [robo.radius*cos(robo.theta + robo.theta2) ; robo.radius*sin(robo.theta + robo.theta2)];
robo.wheelRightBot = [robo.radius*cos(robo.theta + robo.theta3) ; robo.radius*sin(robo.theta + robo.theta3)];
robo.wheelRightTop = [robo.radius*cos(robo.theta + robo.theta4) ; robo.radius*sin(robo.theta + robo.theta4)];

%INITALIZE LIDAR SENSOR
robo.lidarRange = 20;
robo.lidarPos0 = [robo.radius*cos(robo.theta),robo.radius*sin(robo.theta)] + robo.center;
robo.lidarEnd0 = [robo.lidarRange*cos(robo.theta),robo.lidarRange*sin(robo.theta)] + robo.center;
robo.lidarPos = robo.lidarPos0;
robo.lidarEnd = robo.lidarEnd0;

robo.pointCloud = double.empty(0,2);