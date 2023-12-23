function robo = identifyObjects(robo)
    X = robo.pointCloud(:,1);
    Y = robo.pointCloud(:,2);
    wallThreshold = .05;
    obstThreshold = .25;

    %SINCE ALL INCOMING DATA IS ASSUMED TO BE LOCALIZED WE CAN IDENTIFY
    %DATA AROUND THE ACTUAL POSITIONS AS WALL DATA.
    
    %DETERMINE TOP WALL DATA
    topList = double.empty(0,2);
    botList = double.empty(0,2);
    leftList = double.empty(0,2);
    rightList = double.empty(0,2);
    obstList = double.empty(0,2);
    for i = 1:length(Y)
        used = false;
        %CHECK TOP WALL
        if Y(i) > 3 - wallThreshold  && Y(i) < 3 + wallThreshold 
            topList = [topList; X(i),Y(i)];
            used = true;
        end
        %CHECK BOT WALL
        if  Y(i) > -3 - wallThreshold  && Y(i) < -3 + wallThreshold 
            botList = [botList; X(i),Y(i)];
            used = true;
        end
        %CHECK LEFT WALL
        if X(i) > -5 - wallThreshold  && X(i) < -5 + wallThreshold 
            leftList = [leftList; X(i),Y(i)];
            used = true;
        end
        %CHECK RIGHT WALL
        if X(i) > 5 - wallThreshold  && X(i) < 5 + wallThreshold 
            rightList = [rightList; X(i),Y(i)];
            used = true;
        end
        %IF POINT DOES NOT BELONG TO ANY WALL AND IT IS INSIDE THE ARENA,
        %IT IS ASSUMED TO BE AN OBSTACLE
        if used == false && X(i) > -5 + obstThreshold && X(i) < 5 - obstThreshold && Y(i) < 3 - obstThreshold && Y(i) > -3 + obstThreshold
            obstList = [obstList; X(i),Y(i)];
        end
    end
    
    %DISCRITIZE SPACE
    horiz = 10;
    vert = 6;
    res = 10; %ARRAY ZONES PER HORIZONTAL METER
%     vertRes = horizRes * vert/horiz;
    %MOVE ALL ELEMENTS INTO FIRST QUADRANT FOR ARRAY PURPOSES
    topListArray = round((topList + [horiz/2,vert/2] + 1),1) * res;
    botListArray = round((botList + [horiz/2,vert/2] + 1),1) * res;
    leftListArray = round((leftList + [horiz/2,vert/2] + 1),1) * res;
    rightListArray = round((rightList + [horiz/2,vert/2] + 1),1) * res;
    obstListArray = round((obstList + [horiz/2,vert/2] + 1),1) * res;
    
    heatMap = zeros((horiz + 2)*res,(vert + 2)*res);
    topHeatMap = generateHeat(heatMap,topListArray);
    botHeatMap = generateHeat(heatMap,botListArray);
    leftHeatMap = generateHeat(heatMap,leftListArray);
    rightHeatMap = generateHeat(heatMap,rightListArray);
    obstHeatMap = generateHeat(heatMap,obstListArray);
    robo.heatMap = flip(topHeatMap + botHeatMap + leftHeatMap + rightHeatMap + obstHeatMap,2);

%     planPath(robo,topHeatMap,botHeatMap,leftHeatMap,rightHeatMap,obstHeatMap);

    %PLOT SPACE
    figure(1)
    subplot(2,1,2)
    imagesc([-6 6],[-4 4],robo.heatMap')
    h2=gca;h2.DataAspectRatio=[1 1 1];
    colorbar
    clim([0 5])
    title('Heatmap for Obstacle Detection')

    figure(1)
    subplot(2,1,1)
end