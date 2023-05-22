clear all;
close all;
clc;

rng(42);
PS = csvread("PS_train_1Eminus2.csv");
rows = randperm(size(PS, 1));
PS = PS(rows,:);

% We delete the x' columns, since in our poincare section, x' = 0.
PS(:,7) = [];
PS(:,3) = [];


% In this program, we will try to predict the origin point of each initial
% condition. Therefore, the first three columns will be the targets, and
% the last three will be the features.
Y_train = PS(:, 1:3);
X_train = PS(:,4:6);

% Empty the PS matrix, in order to save some memory.
PS = [];

%Get the input size of the network
input_size = size(X_train, 2);


% Experimental results performed have found that having a network to
% predict each target variable yields better results than having a
% monolithic predictor. In addition to this, we use two different network
% architectures: one to predict x and the other to predict y and y'.

% Big Network - to predict y and y'
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

% Small Network - to predict x
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




% Training options - we will only use 15 training epochs, to avoid
% overfitting.
opt = trainingOptions('adam', ...
    'ExecutionEnvironment','gpu', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 5,...
    'LearnRateSchedule', 'piecewise',...
    'Shuffle','every-epoch',...
    'MaxEpochs',15, ...
    'MiniBatchSize', 2048, ...
    'InitialLearnRate', 0.0001,...
    'Verbose', true)


% Train the networks
net_x = trainNetwork(X_train, Y_train(:,1),layers_SMALL, opt); %smll
net_y = trainNetwork(X_train, Y_train(:,2),layers_BIG, opt); %big
net_dx = trainNetwork(X_train, Y_train(:,3),layers_BIG, opt); %big


% Once trained, calculate the offset between a fixed point and its
% prediction:
x0 = -0.507008504151148;
K = 0.0015749;
h = -1.7;
y_dot_0 = -sqrt( 2 * h + x0*x0 + 2 / abs(x0) - 2 * K * x0);
zero = [x0, 0, y_dot_0];
zero_offx = predict(net_x, zero) + 0.507008504151148;
zero_offy = predict(net_y, zero);
zero_offxd = predict(net_dx, zero) + y_dot_0;
% We will subtract this offset from each result.


% Load and prepare the testing dataset:
PS = csvread("PS_small.csv");
PS(:,7) = [];
PS(:,3) = [];
Y_test = PS(:, 1:3);
X_test = PS(:,4:6);

% Make predictions on the test data (taking into account the offset)
x_pred = predict(net_x, X_test) - zero_offx;
y_pred = predict(net_y, X_test) - zero_offy;
dx_pred = predict(net_dx, X_test) - zero_offxd;
rez = [x_pred, y_pred, dx_pred];

% Display and plot the results:
disp("Final RMSE:")
disp(rmse(rez, Y_test));
disp(rmse(rez, Y_test, 'all'));
plot(PS(:,1), PS(:,2), '.', MarkerSize = 0.1, Color = 'blue'); % Actual points
hold on;
plot(rez(:,1), rez(:,2), '.', MarkerSize = 0.1,  Color = 'red'); % Predictions
