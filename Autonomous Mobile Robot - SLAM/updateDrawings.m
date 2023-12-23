function robo = updateDrawings(robo,field)
    set(robo.robot,'XData',robo.radius*cos(robo.circleX) + robo.center(1),'YData',robo.radius*sin(robo.circleX) + robo.center(2))
    robo.wheelLeftTop = [robo.radius*cos(robo.theta + robo.theta1) ; robo.radius*sin(robo.theta + robo.theta1)] + robo.center';
    robo.wheelLeftBot = [robo.radius*cos(robo.theta + robo.theta2) ; robo.radius*sin(robo.theta + robo.theta2)] + robo.center';
    robo.wheelRightBot = [robo.radius*cos(robo.theta + robo.theta3) ; robo.radius*sin(robo.theta + robo.theta3)] + robo.center';
    robo.wheelRightTop = [robo.radius*cos(robo.theta + robo.theta4) ; robo.radius*sin(robo.theta + robo.theta4)] + robo.center';
    set(robo.leftWheel,'XData',[robo.wheelLeftTop(1),robo.wheelLeftBot(1)],'YData',[robo.wheelLeftTop(2),robo.wheelLeftBot(2)])
    set(robo.rightWheel,'XData',[robo.wheelRightTop(1),robo.wheelRightBot(1)],'YData',[robo.wheelRightTop(2),robo.wheelRightBot(2)])
   
    [xf,yf] = checkIntersections(robo.lidarPos,robo.lidarEnd,field);
    if isnan(xf)
        set(robo.lidarLine,'XData',[robo.lidarPos(1),robo.lidarEnd(1)],'YData',[robo.lidarPos(2),robo.lidarEnd(2)])
    else
        set(robo.lidarLine,'XData',[robo.lidarPos(1),xf],'YData',[robo.lidarPos(2),yf])
    end
    
    drawnow;
    pause(.001)
end