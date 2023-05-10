clear all;
close all;
clc;

rng(42);
PS = csvread("PS_train_1Eminus2.csv");
rows = randperm(size(PS, 1));
PS = PS(rows,:);
%PS = rescale(PS, -1, 1);
PS(:,7) = [];
PS(:,3) = [];

% Scale PS by the energy level (this way, the elements of PS will be
% between -1 and 1, which is better when training NNs:
%PS = PS / 1.7;


%full_size = size(PS,1);
%test_size = floor(full_size * 0.3);

X_train = PS(:, 1:3);


Y_train = PS(:,4:6);

%X_train(:,4) = X_train(:,3)+ X_train(:,1);
%X_train(:,5) = sqrt(X_train(:,1).*X_train(:,1)+ X_train(:,2).*X_train(:,2));

PS = [];

input_size = size(X_train, 2);

% Big Network
layers_BIG = [
    featureInputLayer(input_size)
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
    fullyConnectedLayer(1)
    regressionLayer
    
    ];

% Small Network
layers_SMALL = [
    featureInputLayer(input_size)
    fullyConnectedLayer(32)
    reluLayer
    fullyConnectedLayer(64)
    reluLayer
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(64)
    reluLayer
    fullyConnectedLayer(32)
    reluLayer
    fullyConnectedLayer(1)
    regressionLayer
    
    ];

layers = [
    featureInputLayer(input_size)
    fullyConnectedLayer(256)
    reluLayer
    fullyConnectedLayer(512)
    reluLayer
    fullyConnectedLayer(1024)
    reluLayer
    fullyConnectedLayer(1024)
    reluLayer
    fullyConnectedLayer(1024)
    reluLayer
    fullyConnectedLayer(1024)
    reluLayer
    fullyConnectedLayer(1024)
    reluLayer
    fullyConnectedLayer(1024)
    reluLayer
    fullyConnectedLayer(1024)
    reluLayer
    fullyConnectedLayer(1024)
    reluLayer
    fullyConnectedLayer(512)
    reluLayer
    fullyConnectedLayer(1)
    regressionLayer
    
    ];





opt = trainingOptions('adam', ...
    'ExecutionEnvironment','gpu', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 5,...
    'LearnRateSchedule', 'piecewise',...
    'Shuffle','every-epoch',...
    'MaxEpochs',15, ...
    'MiniBatchSize', 2048*2, ...
    'InitialLearnRate', 0.0001,...
    'Verbose', true)%,...
    %'ValidationData',{X_test, Y_test(:,2)});
    %    'Plots','training-progress',...


net_x = trainNetwork(X_train, Y_train(:,1),layers_SMALL, opt);
net_y = trainNetwork(X_train, Y_train(:,2),layers_BIG, opt);
net_dx = trainNetwork(X_train, Y_train(:,3),layers_BIG, opt);




PS = csvread("PS_small.csv");
PS(:,7) = [];
PS(:,3) = [];
%PS = PS / 1.7;
X_test = PS(:, 1:3);
Y_test = PS(:,4:6);
%X_test(:,4) = X_test(:,3)+ X_test(:,1);
%X_test(:,5) = sqrt(X_test(:,1).*X_test(:,1)+ X_test(:,2).*X_test(:,2));
%PS = [];

x_pred = predict(net_x, X_test);
y_pred = predict(net_y, X_test);
dx_pred = predict(net_dx, X_test);

rez = [x_pred, y_pred, dx_pred];


disp("Final RMSE:")
disp(rmse(rez, Y_test));
disp(rmse(rez, Y_test, 'all'));

plot(PS(:,1), PS(:,2), '.', MarkerSize = 0.1, Color = 'blue');
hold on;
plot(rez(:,1), rez(:,2), '.', MarkerSize = 0.1,  Color = 'red');

