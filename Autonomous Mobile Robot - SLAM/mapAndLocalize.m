function pointCloud = mapAndLocalize(robo,field,lidrGyroData)
    %IDENTIFY WALLS
    X = lidrGyroData(:,1).*cos(lidrGyroData(:,2));
    Y = lidrGyroData(:,1).*sin(lidrGyroData(:,2));
    theta = lidrGyroData(:,2);
    index1 = 0;
    index2 = 0;
    index3 = 0;
    index4 = 0;
    threshold = .2;
    targetThreshold = 1;
    xList = sort(X);
    yList = sort(Y);

    %DETERMINE TOP WALL DATA
    topList = [];
    for i = fix(length(Y)/2):length(Y)
        if yList(i) - yList(i-1) <= threshold
            topList(length(topList)+1) = yList(i);
        end
    end
    topTarget = mode(round(topList,1));
    if abs(max(Y)) - abs(topTarget) > targetThreshold
        topTarget = [];
    end

    %DETERMINE BOT WALL DATA
    botList = [];
    for i = 2:fix(length(Y)/2)
        if yList(i) - yList(i-1) <= threshold
            botList(length(botList)+1) = yList(i);
        end
    end
    botTarget = mode(round(botList,1));
    if abs(min(Y)) - abs(botTarget) > targetThreshold
        botTarget = [];
    end

    leftList = [];
    for i = 2:fix(length(X)/2)
        if xList(i) - xList(i-1) <= threshold
            leftList(length(leftList)+1) = xList(i);
        end
    end
    leftTarget = mode(round(leftList,1));
    if abs(min(X)) - abs(leftTarget) > targetThreshold
        leftTarget = [];
    end

    rightList = [];
    for i = fix(length(X)/2):length(X)
        if xList(i) - xList(i-1) <= threshold
            rightList(length(rightList)+1) = xList(i);
        end
    end
    rightTarget = mode(round(rightList,1));
    if abs(max(X)) - abs(rightTarget) > targetThreshold
        rightTarget = [];
    end


    %CHECK FOR EMPTY TARGETS, GENERATE THEM BASED ON OPPOSITE SIDE DATA
    %NOTE: SYSTEM FAILS IF IT CANNOT IDENTIFY (TOP OR BOTTOM) (LEFT OR RIGHT)
    if isempty(topTarget)
        topTarget = botTarget + 6;
    end
    if isempty(botTarget)
        botTarget = topTarget - 6;
    end
    if isempty(leftTarget)
        leftTarget = rightTarget -10;
    end
    if isempty(rightTarget)
        rightTarget = leftTarget + 10;
    end
    
    if isempty(topTarget) || isempty(botTarget) ||...
       isempty(leftTarget) || isempty(rightTarget)
        disp('NOT ENOUGH DATA WALL DATA COLLECTED TO LOCALIZE POSITION')
        pointCloud = double.empty(0,2);
        return;
    end
    topWallData = double.empty(0,2);
    botWallData = double.empty(0,2);
    rightWallData = double.empty(0,2);
    leftWallData = double.empty(0,2);
    %IDENTIFY WALLS BASED ON TARGET DATA AND THRESHOLDS
    for i = 1:length(theta)
        if Y(i) < topTarget+threshold && Y(i) > topTarget-threshold
            index1 = index1+1;
            topWallData(index1,1) = X(i);
            topWallData(index1,2) = Y(i);
        end
        if Y(i) < botTarget+threshold && Y(i) > botTarget-threshold
            index2 = index2+1;
            botWallData(index2,1) = X(i);
            botWallData(index2,2) = Y(i);
        end
        if X(i) < leftTarget+threshold && X(i) > leftTarget-threshold
            index3 = index3+1;
            leftWallData(index3,1) = X(i);
            leftWallData(index3,2) = Y(i);
        end
        if X(i) < rightTarget+threshold && X(i) > rightTarget-threshold
            index4 = index4+1;
            rightWallData(index4,1) = X(i);
            rightWallData(index4,2) = Y(i);
        end
    end

    figure(2);
    subplot(2,1,1)
    hold off;
    plot(X,Y,'o','MarkerEdgeColor','m','MarkerFaceColor','m','MarkerSize',4)
    h1=gca;h1.DataAspectRatio=[1 1 1];
    hold on;
    title('Pre-Localization Point Cloud')
    robo.center = [0 0];
    robo.wheelLeftTop =  [robo.radius*cos(robo.theta + robo.theta1) ; robo.radius*sin(robo.theta + robo.theta1)];
    robo.wheelLeftBot =  [robo.radius*cos(robo.theta + robo.theta2) ; robo.radius*sin(robo.theta + robo.theta2)];
    robo.wheelRightBot = [robo.radius*cos(robo.theta + robo.theta3) ; robo.radius*sin(robo.theta + robo.theta3)];
    robo.wheelRightTop = [robo.radius*cos(robo.theta + robo.theta4) ; robo.radius*sin(robo.theta + robo.theta4)];
    %TOP WALL
    plot([field.topLeft(1),field.topRight(1)],[field.topLeft(2),field.topRight(2)],'k','LineWidth',2);
    %LEFT WALL
    plot([field.topLeft(1),field.botLeft(1)],[field.topLeft(2),field.botLeft(2)],'k','LineWidth',2);
    %RIGHT WALL
    plot([field.topRight(1),field.botRight(1)],[field.topRight(2),field.botRight(2)],'k','LineWidth',2);
    %BOTTOM WALL
    plot([field.botRight(1),field.botLeft(1)],[field.botRight(2),field.botLeft(2)],'k','LineWidth',2);

    robo.robot = plot(robo.radius*cos(robo.circleX) + robo.center(1) , robo.radius*sin(robo.circleX) + robo.center(2),'b','lineWidth',2);
    robo.leftWheel = plot([robo.wheelLeftTop(1),robo.wheelLeftBot(1)] + robo.center(1) , [robo.wheelLeftTop(2),robo.wheelLeftBot(2)] + robo.center(2) ,'r','LineWidth',2);
    robo.rightWheel = plot([robo.wheelRightTop(1),robo.wheelRightBot(1)] + robo.center(1),[robo.wheelRightTop(2),robo.wheelRightBot(2)] + robo.center(2) ,'r','LineWidth',2);

    errorScore = 100;
    horizError = 100;
    vertError = 100;
    dataShiftX = 0;
    dataShiftY = 0;
    totalShiftX = 0;
    totalShiftY = 0;
    topWallData1 = topWallData;
    botWallData1 = botWallData;
    leftWallData1 = leftWallData;
    rightWallData1 = rightWallData;
    count = 0;
    tic
    while errorScore > .04
        %SHIFT DATA POINTS
        topWallData1(:,1) = topWallData1(:,1) + ones(length(topWallData1(:,1)),1)*dataShiftX;
        topWallData1(:,2) = topWallData1(:,2) + ones(length(topWallData1(:,2)),1)*dataShiftY;
        botWallData1(:,1) = botWallData1(:,1) + ones(length(botWallData1(:,1)),1)*dataShiftX;
        botWallData1(:,2) = botWallData1(:,2) + ones(length(botWallData1(:,2)),1)*dataShiftY;
        leftWallData1(:,1) = leftWallData1(:,1) + ones(length(leftWallData1(:,1)),1)*dataShiftX;
        leftWallData1(:,2) = leftWallData1(:,2) + ones(length(leftWallData1(:,2)),1)*dataShiftY;
        rightWallData1(:,1) = rightWallData1(:,1) + ones(length(rightWallData1(:,1)),1)*dataShiftX;
        rightWallData1(:,2) = rightWallData1(:,2) + ones(length(rightWallData1(:,2)),1)*dataShiftY;
        
        topError = double.empty(1,0);
        botError = double.empty(1,0);
        leftError = double.empty(1,0);
        rightError = double.empty(1,0);

        count = count + 1;
        %CALCULATE TOP ERROR
        for i = 1:size(topWallData1,1)
            pt = [topWallData1(i,1),topWallData1(i,2)];
            topWallError = point_to_line_distance(pt,field.topLeft,field.topRight);
            if isnan(topWallError) == true
                disp('TOPWALL NaN')
                pause(.1)
            end
            topError(length(topError)+1) = topWallError;
        end

        %CALCULATE BOT ERROR
        for i = 1:size(botWallData1,1)
            pt = [botWallData1(i,1),botWallData1(i,2)];
            botWallError = point_to_line_distance(pt,field.botLeft,field.botRight);
            if isnan(botWallError) == true
                disp('BOTWALL NaN')
                pause(.1)
            end
            botError(length(botError)+1) = botWallError;
        end

        %CALCULATE LEFT ERROR
        for i = 1:size(leftWallData1,1)
            pt = [leftWallData1(i,1),leftWallData1(i,2)];
            leftWallError = point_to_line_distance(pt,field.topLeft,field.botLeft);
            if isnan(leftWallError) == true
                disp('LEFT NaN')
                pause(.1)
            end
            leftError(length(leftError)+1) = leftWallError;
        end
    
        %CALCULATE RIGHT ERROR
        for i = 1:size(rightWallData1,1)
            pt = [rightWallData1(i,1),rightWallData1(i,2)];
            rightWallError = point_to_line_distance(pt,field.topRight,field.botRight);
            if isnan(rightWallError) == true
                disp('RIGHTWALL NaN')
                pause(.1)
            end
            rightError(length(rightError)+1) = rightWallError;
        end
        
        %CALCULATE HORIZONTAL ERROR
        oldHorizError = horizError;
        horizError = mean([leftError,rightError]);
        if abs(oldHorizError) >= abs(horizError)
            dataShiftX = horizError/2;
        else % oldHorizError <= horizError
            dataShiftX = -horizError/2;
        end

        %CALCULATE VERTICAL ERROR
        oldVertError = vertError;
        vertError = mean([topError,botError]);
        if abs(oldVertError) >= abs(vertError)
            dataShiftY = vertError/2;
        else % oldVertError <= vertError
            dataShiftY = -vertError/2;
        end
        totalShiftY = totalShiftY + dataShiftY;
        totalShiftX = totalShiftX + dataShiftX;
        errorScore = sqrt(vertError^2 + horizError^2);
        if toc >= 1
            errorScore = 0;
        end
    end

    if max(isnan(totalShiftX)) == 1 || max(isnan(totalShiftY)) == 1
        disp('DATA IS KINDA JANK, NOT SURE WHY')
        pointCloud = double.empty(0,2);
        figure(1)
        return;
    end

    figure(2)
    subplot(2,1,2)
    xlim([-6 6])
    ylim([-4 4])
    hold on;
    title('Localized Position')
    h2 = gca;h2.DataAspectRatio=[1 1 1];
    robo.robot = plot(robo.radius*cos(robo.circleX) + robo.center(1) +totalShiftX, robo.radius*sin(robo.circleX) + robo.center(2) +totalShiftY,'b','lineWidth',2);
    robo.leftWheel = plot([robo.wheelLeftTop(1),robo.wheelLeftBot(1)] + robo.center(1) + totalShiftX, [robo.wheelLeftTop(2),robo.wheelLeftBot(2)] + robo.center(2) +totalShiftY,'r','LineWidth',2);
    robo.rightWheel = plot([robo.wheelRightTop(1),robo.wheelRightBot(1)] + robo.center(1) + totalShiftX,[robo.wheelRightTop(2),robo.wheelRightBot(2)] + robo.center(2) + totalShiftY,'r','LineWidth',2);
    plot(X + totalShiftX,Y + totalShiftY,'o','MarkerEdgeColor','m','MarkerFaceColor','m','MarkerSize',4)
    drawnow;
    %TOP WALL
    plot([field.topLeft(1),field.topRight(1)],[field.topLeft(2),field.topRight(2)],'k','LineWidth',2);
    %LEFT WALL
    plot([field.topLeft(1),field.botLeft(1)],[field.topLeft(2),field.botLeft(2)],'k','LineWidth',2);
    %RIGHT WALL
    plot([field.topRight(1),field.botRight(1)],[field.topRight(2),field.botRight(2)],'k','LineWidth',2);
    %BOTTOM WALL
    plot([field.botRight(1),field.botLeft(1)],[field.botRight(2),field.botLeft(2)],'k','LineWidth',2);
    drawnow;
    pointCloud = [X + totalShiftX , Y + totalShiftY];
    figure(1)
end