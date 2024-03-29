
% We begin by clearing everything:
clear all;
close all;
clc;

% Random seed:
rng(42);

% Create the simulation enviroment:
env = SatelliteEnviroment;

% Simultation properties:
env.Ts = 1e-1; % Time step
env.Max_t = 60*5; % Max. simulation time
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
    fullyConnectedLayer(64)
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
    fullyConnectedLayer(64)
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
