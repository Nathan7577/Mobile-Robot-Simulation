function [distAngle,field] = scanArea(robo,field,stepAngle)
    n = 2*pi/stepAngle;
    pointVect = zeros(n-1,2);
    distAngle = pointVect;
    for i = 1:n
        %UPDATE ANGLE
        robo.theta = robo.theta - stepAngle;
        if robo.theta < 0
            robo.theta = robo.theta + 2*pi;
        end
        if robo.theta >= 2*pi
            robo.theta = robo.theta - 2*pi;
        end
        robo.lidarPos = robo.center' + [cos(robo.theta) -sin(robo.theta);sin(robo.theta) cos(robo.theta)]*(robo.lidarPos0' - robo.center0');
        robo.lidarEnd = robo.center' + [cos(robo.theta) -sin(robo.theta);sin(robo.theta) cos(robo.theta)]*(robo.lidarEnd0' - robo.center0');
        
        [xf,yf] = checkIntersections(robo.lidarPos,robo.lidarEnd,field);
        set(robo.lidarLine,'XData',[robo.lidarPos(1),xf],'YData',[robo.lidarPos(2),yf])
        %LOG INTERSECTION DATA
        if i ~= n
            pointVect(i,1) = xf;
            pointVect(i,2) = yf;
        end
        %CONVERT INTERSECTION DATA TO LIRD + GYRO EQUIVILANT
        XY = [xf - robo.center(1);yf - robo.center(2)];
        distAngle(i,1) = norm(XY);
        distAngle(i,2) = robo.theta;
        %UPDATE DRAWINGS
        set(robo.robot,'XData',robo.radius*cos(robo.circleX) + robo.center(1),'YData',robo.radius*sin(robo.circleX) + robo.center(2))
        robo.wheelLeftTop = [robo.radius*cos(robo.theta + robo.theta1) ; robo.radius*sin(robo.theta + robo.theta1)] + robo.center';
        robo.wheelLeftBot = [robo.radius*cos(robo.theta + robo.theta2) ; robo.radius*sin(robo.theta + robo.theta2)] + robo.center';
        robo.wheelRightBot = [robo.radius*cos(robo.theta + robo.theta3) ; robo.radius*sin(robo.theta + robo.theta3)] + robo.center';
        robo.wheelRightTop = [robo.radius*cos(robo.theta + robo.theta4) ; robo.radius*sin(robo.theta + robo.theta4)] + robo.center';
        set(robo.leftWheel,'XData',[robo.wheelLeftTop(1),robo.wheelLeftBot(1)],'YData',[robo.wheelLeftTop(2),robo.wheelLeftBot(2)])
        set(robo.rightWheel,'XData',[robo.wheelRightTop(1),robo.wheelRightBot(1)],'YData',[robo.wheelRightTop(2),robo.wheelRightBot(2)])
        drawnow;
        pause(.01)
    end
end