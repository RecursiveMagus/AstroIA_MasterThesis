clear all;
close all;
clc;

nsamp = 10000;

a = -1;
b = 1;
rx = a + (b-a).*rand(nsamp,1);
ry = -0.5*rx.^3+1*cos(rx*5)+exp(rx)-2;
rz = -rx.^3+1*cos(rx*5)+exp(rx)-2 + sin(rx*2);

RXY = [rx,ry];

x2 = -1:0.05:1;
y2 = -0.5*x2.^3+1*cos(x2*5)+exp(x2)-2;
z2 = -x2.^3+1*cos(x2*5)+exp(x2)-2 + sin(x2*2);

XY = [x2;y2];

figure; hold on;
plot3(rx,ry,rz, '*');

netconf = [64 128 64 32];
net = feedforwardnet(netconf);

layers = [
    featureInputLayer(2)
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(1)
    regressionLayer
    
    ]

opt = trainingOptions('adam', ...
    'ExecutionEnvironment','gpu', ...
    'MaxEpochs',1000, ...
    'MiniBatchSize', 2048, ...
    'InitialLearnRate', 1e-5);

net = trainNetwork(RXY, rz, layers, opt);

z_pred = predict(net, XY.');

figure;
plot3(x2, y2, z2, '*');
hold on;
plot3(x2, y2, z_pred, 'linewidth', 0.5);