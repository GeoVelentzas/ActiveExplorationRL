function [ Sess ] = RunSession( task )

%% Initialize Task-Robot
episodeLength = 10000;                                          %length of one hyper-session
BBT = BBsetTask();                                              %initialize task
BBR = BBrobot(BBT);                                             %initialize robot
% BBR = BBinitModelParam( BBR );                                %initialize parameters (Mehdi's optim)
BBR = BBsetParams( BBR, task );                                 %new optimized parameters

%% Initialize variables
s = drand01(BBT.P0);                                            %initial state is s
[BBR, a] = BBrobotDecides(BBT, BBR, s);                         %first action decision
OptimalActions = nan*ones(BBT.nA, episodeLength+1, BBT.nS);     %track optimal actions and parameters (nAxTxnS)
OptimalActions(BBT.optimal(s), 1, s) = BBT.engMu(s);            %initial optimal action and parameter in s
BBR.ActionsTaken = nan*zeros(BBT.nA,episodeLength+1, BBT.nS);   %for tracking actions taken using nans for plots... hardcoded....!
Sigmas = nan*zeros(BBT.nA, episodeLength+1, BBT.nS);            %tracking gaussian exploration stds (nAxTxnS)
Betas = zeros(BBT.nS, episodeLength+1);                         %tracking inverse temperature (nSxT)
Engagement = zeros(1,episodeLength);                            %tracking engagement (1xT)
Metaparams = zeros(BBT.nA, episodeLength+1,BBT.nS);             %tracking metaparams (nAxTxnS)
ExpectedActionParams = zeros(BBT.nA, episodeLength+1, BBT.nS);  %tracking means of gaussians (nAxTxnS)
Qvalues = zeros(BBT.nA, episodeLength+1, BBT.nS);               %tracking Qvalues (nAxTxnS)


Sigmas(:, 1, :) = BBR.SIGMAS2';                                 %gaussian exploration stds at first timestep
Betas(:, 1) = BBR.BETAS;                                        %betas at first timestep
Engagement(1, 1) = BBT.cENG;                                    %initial engagement
Metaparams(:, 1, :) = BBR.METAPARAMS2';                         %initial metaparams values
StatesVisited = s;                                              %track States visited in a list (array)
ExpectedActionParams(:,1,:) = BBR.wA';                          %track means of gaussians for exploration
Qvalues(:,1,:) = BBR.Q';                                        %track Qvalues

%% Run Task ... Decide-Transition-Observe-Learn and Track History
for iii=1:episodeLength
    BBT = tasktype(BBT, iii ,s , task);                         %the task might change dynamically
    [ BBT, BBR, s, a ] = BBrunTrial( BBT, BBR, s, a );          %decide-transition-observe-learn
    Sigmas(:,iii+1, :) = BBR.SIGMAS2';                          %track gaussian stds
    Betas(:,iii+1) = BBR.BETAS;                                 %track inverse temperature beta
    Engagement(1,iii+1) = BBT.cENG;                             %track engagement
    Metaparams(:,iii+1, :) = BBR.METAPARAMS2';                  %track values of metaparameters
    OptimalActions(BBT.optimal(s), iii+1, s) = BBT.engMu(s);    %track Optimal Actions
    StatesVisited(iii+1) = s;                                   %track visited States
    ExpectedActionParams(:,iii+1,:) = BBR.wA';                  %track estimated parameter means
    Qvalues(:, iii+1, :) = BBR.Q';                              %track Qvalues
end

%% Save Session variables
Sess.Sigmas = Sigmas;                                           %Sigmas: (nAxTxnS)
Sess.Betas = Betas;                                             %Betas:  (nSxT)
Sess.Engagement = Engagement;                                   %Engagement: (1xT)
Sess.ActionsTaken = BBR.ActionsTaken;                           %ActionsTaken: (nAxTxnS)
Sess.OptimalActions = OptimalActions;                           %OptimalActions: (nAxTxnS)
Sess.StatesVisited = StatesVisited;                             %StatesVisited: (1xT)
Sess.Metaparams = Metaparams;                                   %Metaparams: (nAxTxnS)
Sess.Hits = BBR.Hits;                                           %Hits: (1xT)
Sess.DHits = BBR.DHits;                                         %DHits: (1xT)
Sess.ExpectedActionParams = ExpectedActionParams;               %ExpParamVal: (nAxTxnS);
Sess.Qvalues = Qvalues;                                         %Qvalues: (nAxTxnS);
Sess.H = BBR.H;
end

