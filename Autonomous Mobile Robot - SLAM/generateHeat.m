function heatMap = generateHeat(heatMap,list)
    for i = 1:size(list,1)
        pt = fix(list(i,:));
        heatMap(pt(1),pt(2)) = heatMap(pt(1),pt(2)) + 1;
    end
end