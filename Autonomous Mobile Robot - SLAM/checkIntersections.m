function [x,y] = checkIntersections(startPoint,endPoint,field)

%TOP WALL CHECK
[topX,topY] = intersections([startPoint(1) endPoint(1)],[startPoint(2) endPoint(2)],[field.topLeft(1) field.topRight(1)],[field.topLeft(2) field.topRight(2)]);
%LEFT WALL CHECK
[leftX,leftY] = intersections([startPoint(1) endPoint(1)],[startPoint(2) endPoint(2)],[field.topLeft(1) field.botLeft(1)],[field.topLeft(2) field.botLeft(2)]);
%RIGHT WALL CHECK
[rightX,rightY] = intersections([startPoint(1) endPoint(1)],[startPoint(2) endPoint(2)],[field.topRight(1) field.botRight(1)],[field.topRight(2) field.botRight(2)]);
%RIGHT WALL CHECK
[botX,botY] = intersections([startPoint(1) endPoint(1)],[startPoint(2) endPoint(2)],[field.botLeft(1) field.botRight(1)],[field.botLeft(2) field.botRight(2)]);

highResLineX = [startPoint(1),endPoint(1)];
highResLineY = [startPoint(2),endPoint(2)];
%OBST1 CHECK
[obst1X,obst1Y] = intersections(highResLineX,highResLineY,field.obst1(:,1),field.obst1(:,2));
%OBST2 CHECK
[obst2X,obst2Y] = intersections(highResLineX,highResLineY,field.obst2(:,1),field.obst2(:,2));
%OBST3 CHECK
[obst3X,obst3Y] = intersections(highResLineX,highResLineY,field.obst3(:,1),field.obst3(:,2));
%OBST4 CHECK
[obst4X,obst4Y] = intersections(highResLineX,highResLineY,field.obst4(:,1),field.obst4(:,2));
%OBST5 CHECK
[obst5X,obst5Y] = intersections(highResLineX,highResLineY,field.obst5(:,1),field.obst5(:,2));

minMag = 100;
if isempty(obst1X) == false
    for j = 1:length(obst1X)
        checkMag = norm([startPoint(1) - obst1X(j);startPoint(2)-obst1Y(j)]);%CHECK MAGNITUDE OF VECTOR
        if checkMag < minMag
            minMag = checkMag;
            obst1Xmin = obst1X(j);
            obst1Ymin = obst1Y(j);
        end
    end
else
    obst1Xmin = 100;
    obst1Ymin = 100;
end

minMag = 100;
if isempty(obst2X) == false
    for j = 1:length(obst2X)
        checkMag = norm([startPoint(1) - obst2X(j);startPoint(2)-obst2Y(j)]);%CHECK MAGNITUDE OF VECTOR
        if checkMag < minMag
            minMag = checkMag;
            obst2Xmin = obst2X(j);
            obst2Ymin = obst2Y(j);
        end
    end
else
    obst2Xmin = 100;
    obst2Ymin = 100;
end

minMag = 100;
if isempty(obst3X) == false
    for j = 1:length(obst3X)
        checkMag = norm([startPoint(1) - obst3X(j);startPoint(2)-obst3Y(j)]);%CHECK MAGNITUDE OF VECTOR
        if checkMag < minMag
            minMag = checkMag;
            obst3Xmin = obst3X(j);
            obst3Ymin = obst3Y(j);
        end
    end
else
    obst3Xmin = 100;
    obst3Ymin = 100;
end

minMag = 100;
if isempty(obst4X) == false
    for j = 1:length(obst4X)
        checkMag = norm([startPoint(1) - obst4X(j);startPoint(2)-obst4Y(j)]);%CHECK MAGNITUDE OF VECTOR
        if checkMag < minMag
            minMag = checkMag;
            obst4Xmin = obst4X(j);
            obst4Ymin = obst4Y(j);
        end
    end
else
    obst4Xmin = 100;
    obst4Ymin = 100;
end

minMag = 100;
if isempty(obst5X) == false
    for j = 1:length(obst5X)
        checkMag = norm([startPoint(1) - obst5X(j);startPoint(2)-obst5Y(j)]);%CHECK MAGNITUDE OF VECTOR
        if checkMag < minMag
            minMag = checkMag;
            obst5Xmin = obst5X(j);
            obst5Ymin = obst5Y(j);
        end
    end
else
    obst5Xmin = 100;
    obst5Ymin = 100;
end

% STORE INTERSECTION POINTS IN BIG VECTOR, CHECK FOR MINIMUM MAGNITUDE AFTER
interVect = [topX,topY;
             leftX,leftY;
             rightX,rightY;
             botX,botY;
             obst1Xmin,obst1Ymin;
             obst2Xmin,obst2Ymin;
             obst3Xmin,obst3Ymin;
             obst4Xmin,obst4Ymin;
             obst5Xmin,obst5Ymin;];

minMag = 100;
for j = 1:size(interVect,1)
    if isempty(interVect(j,:)) == false
        checkMag = norm([startPoint(1) - interVect(j,1);startPoint(2) - interVect(j,2)]);%CHECK MAGNITUDE OF VECTOR
        if checkMag < minMag
            minMag = checkMag;
            n = j;
        end
    end
end
if exist('n','var') == false
    x = NaN;
    y = NaN;
    return
end
x = interVect(n,1);
y = interVect(n,2);

%FUNCTION OBJECTIVES
%CHECK ALL FIELD DATA FOR INTERSECTIONS WITH THE GIVEN LINE
%RETURN THE INTERSECTION DATA OF THE CLOSEST OBJECT