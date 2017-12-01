%% main
clear all; close all; clc

%% Initialize Task-Robot
episodeLength = 10000;          %length of one hyper-session
BBT = BBsetTask();              %initialize task
BBR = BBrobot(BBT);             %initialize robot
BBR = BBinitModelParam( BBR );  %initialize parameters (Mehdi's optim)
BBR.tau1 = 10;                  %hardcoded... needs to be optimized 
BBR.tau2 = 5;                   %hardcoded... needs to be optimized

%% Initialize variables
s = drand01(BBT.P0);                                            %initial state is s
[BBR, a] = BBrobotDecides(BBT, BBR, s);                         %first action decision
OptimalActions = nan*ones(BBT.nA, episodeLength+1, BBT.nS);     %track optimal actions and parameters (nAxTxnS)
OptimalActions(BBT.optimal(s), 1, s) = BBT.engMu(s);            %initial optimal action and parameter in s
BBR.ActionsTaken = nan*zeros(BBT.nA,episodeLength+1, BBT.nS);   %for tracking actions taken using nans for plots... hardcoded....!
sigmas2 = nan*zeros(BBT.nA, episodeLength+1, BBT.nS);           %tracking gaussian exploration stds (nAxTxnS)
betas2 = zeros(BBT.nS, episodeLength+1);                        %tracking inverse temperature (nSxT)
engagement = zeros(1,episodeLength);                            %tracking engagement (1xT)
metaparams2 = zeros(BBT.nA, episodeLength+1,BBT.nS);            %tracking metaparams (nAxTxnS)
sigmas2(:, 1, :) = BBR.SIGMAS2';                                %gaussian exploration stds at first timestep
betas2(:, 1) = BBR.BETAS;                                       %betas at first timestep
engagement(1, 1) = BBT.cENG;                                    %initial engagement
metaparams2(:, 1, :) = BBR.METAPARAMS2';                        %initial metaparams values
StatesVisited = s;                                              %track States visited in a list (array)

%% Run Task ... Decide-Transition-Observe-Learn and Track History
task = 'non-stationary1';
for iii=1:episodeLength
    BBT = tasktype(BBT, iii ,s , task);                         %the task might change dynamically
    [ BBT, BBR, s, a, logs ] = BBrunTrial( BBT, BBR, s, a );    %decide-transition-observe-learn
    sigmas2(:,iii+1, :) = BBR.SIGMAS2';                         %track gaussian stds
    betas2(:,iii+1) = BBR.BETAS;                                %track inverse temperature beta
    engagement(1,iii+1) = BBT.cENG;                             %track engagement
    metaparams2(:,iii+1, :) = BBR.METAPARAMS2';                 %track values of metaparameters
    OptimalActions(BBT.optimal(s), iii+1, s) = BBT.engMu(s);    %track visited States
    StatesVisited(iii+1) = s;
end

%% Show Results
visual1;























