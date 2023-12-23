function robo = move(robo,option)
    stepDist = .05;
    stepAngle = pi/180;
    switch option
        case 'uparrow'
            step = [stepDist*cos(robo.theta) , stepDist*sin(robo.theta)];
            robo.center = robo.center + step;
            robo.lidarPos = robo.lidarPos + step;
            robo.lidarEnd = robo.lidarEnd + step;
        case 'leftarrow'
            robo.theta = robo.theta + stepAngle;
            if robo.theta >= 2*pi
                robo.theta = robo.theta - 2*pi;
            end
            rotMat = [cos(robo.theta) -sin(robo.theta);sin(robo.theta),cos(robo.theta)];
            robo.lidarPos = (rotMat*(robo.lidarPos0-robo.center0)' + robo.center')';
            robo.lidarEnd = (rotMat*(robo.lidarEnd0-robo.center0)' + robo.center')';
        case 'rightarrow'
            robo.theta = robo.theta - stepAngle;
            if robo.theta <= 2*pi
                robo.theta = robo.theta + 2*pi;
            end
            rotMat = [cos(robo.theta) -sin(robo.theta);sin(robo.theta),cos(robo.theta)];
            robo.lidarPos = (rotMat*(robo.lidarPos0-robo.center0)' + robo.center')';
            robo.lidarEnd = (rotMat*(robo.lidarEnd0-robo.center0)' + robo.center')';
        case 'downarrow'
            step = -[stepDist*cos(robo.theta) , stepDist*sin(robo.theta)];
            robo.center = robo.center + step;
            robo.lidarPos = robo.lidarPos + step;
            robo.lidarEnd = robo.lidarEnd + step;
    end
end