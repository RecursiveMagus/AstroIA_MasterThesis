clear all;
close all;
clc;

PS = csvread("PS.csv");
rows = randperm(size(PS, 1));
PS = PS(rows,:);

X_test = PS(1:20000, 1:4);
X_train = PS(20001:end, 1:4);

Y_test = PS(1:20000, 5:8);
Y_train = PS(20001:end,5:8);


layers = [
    featureInputLayer(4)
    fullyConnectedLayer(1024)
    reluLayer
    fullyConnectedLayer(2048)
    reluLayer
    fullyConnectedLayer(2048)
    reluLayer
    fullyConnectedLayer(2048)
    reluLayer
    fullyConnectedLayer(2048)
    reluLayer
    fullyConnectedLayer(2048)
    reluLayer
    fullyConnectedLayer(2048)
    reluLayer
    fullyConnectedLayer(1024)
    reluLayer
    fullyConnectedLayer(4)
    regressionLayer
    
    ]
    
    %'GradientThresholdMethod','l2norm',...
opt = trainingOptions('sgdm', ...
    'GradientThresholdMethod','global-l2norm',...
    'ExecutionEnvironment','gpu', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 5,...
    'LearnRateSchedule', 'piecewise',...
    'Shuffle','every-epoch',...
    'MaxEpochs',1000, ...
    'MiniBatchSize', 256, ...
    'InitialLearnRate', 0.01,...
    'Plots','training-progress',...
    'Verbose', true,...
    'ValidationData',{X_test, Y_test});

net = trainNetwork(X_train, Y_train,layers, opt);