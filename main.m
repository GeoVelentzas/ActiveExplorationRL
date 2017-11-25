%% main

clear all
close all
clc

whichModel = 5;
runOptimizedModels = 5;
episodeLength = 10000;
vertiBars = true;

% define Task
BBT = BBsetTask();

% define baby robot
BBR = BBrobot(BBT);

% initialize model optimized parameters
if (runOptimizedModels)
    load('bestModelsOptiSummer2016.mat') %CHANGED THIS TO BE IN MY DIR!!!
    whichModel = 5;
    BBR = BBinitModelParam( BBR, bestModels(whichModel,1:10), whichModel );
    BBR.tau1 = 10; 
    BBR.tau2 = 5; 
    %BBR.beta = 10; 
    %BBR.mu = 0.1;
end

% initial state
s = drand01(BBT.P0); %THIS WILL BE THE FIRST STATE...

OAPE = [BBT.optimal(s)];
OPPE = [BBT.engMu(s)];

OptimalActions = nan*ones(BBT.nA, episodeLength+1, BBT.nS);
OptimalActions(BBT.optimal(s), 1, s) = BBT.engMu(s);
BBR.ActionsTaken = nan*zeros(BBT.nA,episodeLength+1, BBT.nS);

% initial action by the robot
[BBR, a] = BBrobotDecides(BBT, BBR, whichModel, s);

% init LOGS
LOG_FILES = [s a.action a.param 0 s a.action a.param BBT.cENG BBR.delta BBR.VC BBR.ACT BBR.PA zeros(1, BBR.nA) 0 BBR.sigma 0 0 0 BBR.BETAS BBR.SIGMAS];
sigmas2 = nan*zeros(BBT.nA, episodeLength+1, BBT.nS);
betas2 = zeros(BBT.nS, episodeLength+1);
engagement = zeros(1,episodeLength);
metaparams2 = zeros(BBT.nA, episodeLength+1,BBT.nS);

sigmas2(:, 1, :) = BBR.SIGMAS2';
betas2(:, 1) = BBR.BETAS;
engagement(1, 1) = BBT.cENG;
metaparams2(:, 1, :) = BBR.METAPARAMS2';
StatesVisited = s;


%% RUN TASK
T = episodeLength; 
t = 1:episodeLength;

for iii=1:episodeLength
    BBT = tasktype(BBT, iii ,s ,'non-stationary1');
    [ BBT, BBR, s, a, logs ] = BBrunTrial( BBT, BBR, whichModel, s, a );
    LOG_FILES = [LOG_FILES ; [logs.s logs.oldaction logs.oldparam logs.reward logs.y logs.action logs.param logs.engagement logs.delta logs.VC logs.ACT logs.PA logs.Q logs.RPEQ logs.sigma logs.star logs.mtar logs.meta logs.BETAS logs.SIGMAS]];
    OAPE = [OAPE BBT.optimal(s)];
    OPPE = [OPPE BBT.engMu(s)];

    sigmas2(:,iii+1, :) = BBR.SIGMAS2';
    betas2(:,iii+1) = BBR.BETAS;
    engagement(1,iii+1) = BBT.cENG;
    metaparams2(:,iii+1, :) = BBR.METAPARAMS2';
    OptimalActions(BBT.optimal(s), iii+1, s) = BBT.engMu(s);
    StatesVisited(iii+1) = s;
    
end



%% showresults 2
visual1;


























