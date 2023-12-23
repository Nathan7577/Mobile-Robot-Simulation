%SIMULATION OF ROBOT MOVEMENT
clear all;close all; clc;

[robo,field] = parameters();
[fig,robo,field] = initalPlot(robo,field);

fig.KeyPressFcn = @(f,eve) moveRobot(f,eve,robo,field);

function moveRobot(fig,eve,robo,field)
    switch eve.Key
        case 'uparrow'
            robo = move(robo,eve.Key);
        case 'leftarrow'
            robo = move(robo,eve.Key);
        case 'rightarrow'
            robo = move(robo,eve.Key);
        case 'downarrow'
            robo = move(robo,eve.Key);
        case 'space' %MAP AND LOCALIZE
            [lidrGyroData,field] = scanArea(robo,field,pi/180);
            lidrGyroData = addNoise(lidrGyroData);
            robo.pointCloud = mapAndLocalize(robo,field,lidrGyroData);
            robo = identifyObjects(robo);
        otherwise
    end
    
    %UPDATE DRAWINGS
    robo = updateDrawings(robo,field);

    %UPDATE CALLBACK FUNCTION DATA
    fig.KeyPressFcn = @(f,eve) moveRobot(f,eve,robo,field);
end