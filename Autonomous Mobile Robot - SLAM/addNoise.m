function noisyData = addNoise(lidrGyroData)
gyroNoise = .05;
lidrNoise = .05;
noisyData = lidrGyroData;
for i = 1:length(lidrGyroData)
    noisyData(i,1) = lidrGyroData(i,1) + (-1 + (1+1)*rand(1))*gyroNoise; %GYRO DATA
    noisyData(i,2) = lidrGyroData(i,2) + (-1 + (1+1)*rand(1))*lidrNoise; %LIDR DATA
end