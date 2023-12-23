function [fig,robo,field] = initalPlot(robo,field)
%PLOT FIELD
fig = figure(1);
%PLOT DOCK ZONES
thetaDockL = linspace(pi/2,-pi/2,1000);
subplot(2,1,1)
hold on;
h=gca;h.DataAspectRatio = [1 1 1];
title('Robot Field')
thetaDockR = linspace(pi/2,3*pi/2,1000);
plot(cos(thetaDockR) + 5,sin(thetaDockR),'g','LineWidth',2,'LineStyle','--')
plot(cos(thetaDockL) - 5,sin(thetaDockL),'g','LineWidth',2,'LineStyle','--')
%TOP WALL
plot([field.topLeft(1),field.topRight(1)],[field.topLeft(2),field.topRight(2)],'k','LineWidth',2);
%LEFT WALL
plot([field.topLeft(1),field.botLeft(1)],[field.topLeft(2),field.botLeft(2)],'k','LineWidth',2);
%RIGHT WALL
plot([field.topRight(1),field.botRight(1)],[field.topRight(2),field.botRight(2)],'k','LineWidth',2);
%BOTTOM WALL
plot([field.botRight(1),field.botLeft(1)],[field.botRight(2),field.botLeft(2)],'k','LineWidth',2);
%PLOT LEFT ENDZONE
plot([field.dockLeftTop(1),field.dockLeftBot(1)],[field.dockLeftTop(2),field.dockLeftBot(2)],'r','LineWidth',2);
%PLOT RIGHT ENDZONE
plot([field.dockRightTop(1),field.dockRightBot(1)],[field.dockRightTop(2),field.dockRightBot(2)],'r','LineWidth',2);

%PLOT BEACONS
plot(field.leftBeacon(1),field.leftBeacon(2),'o','MarkerFaceColor','g','MarkerEdgeColor','g')
plot(field.rightBeacon(1),field.rightBeacon(2),'o','MarkerFaceColor','g','MarkerEdgeColor','g')

%PLOT OBSTACLES
plot(field.obst1(:,1),field.obst1(:,2),'k','LineWidth',2)
plot(field.obst2(:,1),field.obst2(:,2),'k','LineWidth',2)
plot(field.obst3(:,1),field.obst3(:,2),'k','LineWidth',2)
plot(field.obst4(:,1),field.obst4(:,2),'k','LineWidth',2)
plot(field.obst5(:,1),field.obst5(:,2),'k','LineWidth',2)

xlim([-6 6])
ylim([-4 4])

%PLOT ROBOT
robo.circleX = linspace(0,2*pi,1000);
robo.robot = plot(robo.radius*cos(robo.circleX) + robo.center(1) , robo.radius*sin(robo.circleX) + robo.center(2),'b','lineWidth',2);
robo.leftWheel = plot([robo.wheelLeftTop(1),robo.wheelLeftBot(1)] + robo.center(1) , [robo.wheelLeftTop(2),robo.wheelLeftBot(2)] + robo.center(2) ,'r','LineWidth',2);
robo.rightWheel = plot([robo.wheelRightTop(1),robo.wheelRightBot(1)] + robo.center(1),[robo.wheelRightTop(2),robo.wheelRightBot(2)] + robo.center(2) ,'r','LineWidth',2);

%PLOT LIDR DETECTOR
robo.lidarLine = plot([robo.lidarPos0(1),robo.lidarEnd0(1)],[robo.lidarPos0(2),robo.lidarEnd0(2)],'k','LineWidth',1.5,'LineStyle','--');