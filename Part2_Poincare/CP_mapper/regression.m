clear all;
close all;
clc;

rng(42);
PS = csvread("PS.csv");
rows = randperm(size(PS, 1));
PS = PS(rows,:);
%PS = rescale(PS, -1, 1);
%PS(:,7) = [];
%PS(:,3) = [];


Y_test = PS(1:250000, 1:4);
Y_train = PS(250001:end, 1:4);

X_test = PS(1:250000, 5:8);
X_train = PS(250001:end,5:8);

PS = [];


layers = [
    featureInputLayer(4)
    fullyConnectedLayer(256)
    reluLayer
    fullyConnectedLayer(512)
    reluLayer
    fullyConnectedLayer(512)
    reluLayer
    fullyConnectedLayer(1024)
    reluLayer
    fullyConnectedLayer(1024)
    reluLayer
    fullyConnectedLayer(512)
    reluLayer
    fullyConnectedLayer(4)
    regressionLayer
    
    ];
    
    %'GradientThresholdMethod','l2norm',...
opt = trainingOptions('adam', ...
    'ExecutionEnvironment','gpu', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 2,...
    'LearnRateSchedule', 'piecewise',...
    'Shuffle','every-epoch',...
    'MaxEpochs',1000, ...
    'MiniBatchSize', 2048*2, ...
    'InitialLearnRate', 0.0001,...
    'Plots','training-progress',...
    'Verbose', true,...
    'ValidationData',{X_test, Y_test});

net = trainNetwork(X_train, Y_train,layers, opt);