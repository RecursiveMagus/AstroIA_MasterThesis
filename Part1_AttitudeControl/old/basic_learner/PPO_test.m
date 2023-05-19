% Satellite angular velocity controller, first test.
% This program uses the PPO algorithm to obtain an agent capable to
% stabilize the angular velocity of a satellite.
% This program should be run alongside the 'SatelliteEnviroment.m' script.
%
% Results: The control agent is able to stabilize a sperical satellite of
% radius 0.29m and 5Kg of mass in less than 60 seconds with a precision
% less than 1e-3 (or about 1e-2 in the worst initial conditions). The controller 
% is trained with an initial perturbation between [-3, 3] rad/s on all 
% three axis.
% The training process lasts for 2500 episodes, although we should begin
% to have an acceptable controller around iteration 350-400, and a suitable
% controller around iteration 1700.

% We begin by clearing everything:
clear all;
close all;
clc;

% Random seed:
rng(42);

% Create the simulation enviroment:
env = SatelliteEnviroment;

% Simultation properties:
env.Ts = 1e-2; % Time step
env.desired_precision = 1e-3; % Desired precision for the final ang. vel.
env.Max_t = 120; % Max. simulation time
env.hardness = 3; % "Difficulty" of each simulation
env.max_episodes = 2500; % Max. training episodes

% Retrieve information about the enviroment actions and states:
actInfo = getActionInfo(env);
obsInfo = getObservationInfo(env);

% Get the dimension of the states:
numObs = prod(obsInfo.Dimension);

% Create the critic network
criticNetwork = [
    featureInputLayer(numObs)
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(32)
    reluLayer
    fullyConnectedLayer(1)
    ];
criticNetwork = dlnetwork(criticNetwork);
critic = rlValueFunction(criticNetwork, obsInfo, 'UseDevice','gpu');

% Create the actor network
actorNetwork = [
    featureInputLayer(numObs)
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(32)
    reluLayer
    fullyConnectedLayer(numel(actInfo.Elements))
    softmaxLayer
    ];
actorNetwork = dlnetwork(actorNetwork);
actor = rlDiscreteCategoricalActor(actorNetwork, obsInfo, actInfo, 'UseDevice','gpu');

% Set the learning rate for the critic and the actor:
actorOpts = rlOptimizerOptions(LearnRate=1e-4);
criticOpts = rlOptimizerOptions(LearnRate=1e-4);

% Set the options for the PPO agent:
agentOpts = rlPPOAgentOptions(...
    MiniBatchSize=512,...
    ExperienceHorizon=1024,...
    ClipFactor=0.02,...
    EntropyLossWeight=0.01,...
    ActorOptimizerOptions=actorOpts,...
    CriticOptimizerOptions=criticOpts,...
    NumEpoch=10,...
    AdvantageEstimateMethod="gae",...
    GAEFactor=0.95,...
    SampleTime=0.1,...
    DiscountFactor=0.997);

% Create the *actual* reinf. learn. agent:
agent = rlPPOAgent(actor,critic,agentOpts);

% Set the training options:
trainOpts = rlTrainingOptions(...
    MaxEpisodes=env.max_episodes,...
    MaxStepsPerEpisode= floor(env.Max_t / env.Ts),...
    Plots="training-progress",...
    StopTrainingCriteria='EpisodeCount',...
    StopTrainingValue = env.max_episodes,...
    ScoreAveragingWindowLength=50);

% Start the training process! Go grab a coffee and touch some grass or
% something; this will take a while:
trainingStats = train(agent, env, trainOpts);

% When done, we play some "games" where the agent will choose the "best"
% actions, without learning:
env.train_done = true;
env.episode_counter = -1;
simOptions = rlSimulationOptions(MaxSteps=floor(env.Max_t / env.Ts));
simOptions.NumSimulations = 25;
experience = sim(env, agent, simOptions);