function BBR = BBrobot(BBtask)

    % BBtask is a structure containing the Baby Robot learning task
    % Number of states available to the robot:
    nS = BBtask.nS;
    % Number of actions available to the robot:
    nA = BBtask.nA;
    
    %% Initialize model-free Q-learning (to decide which action to make)
    Q = zeros(nS, nA); % Q-values
    RPEQ = zeros(1, nA); % delta for Q-learning
    alphaQ = 0.4; % Q-learning learning rate
    gamma = 0.99; % discount factor (time horizon for reward prediction)
    beta = 50; % exploration rate (inverse temperature)
    
    % Initialize CACLA Actor-Critic (to learn parameters of actions) 
    delta = 0; % reward-prediction error (reinforcement signal)
    wC = zeros(nS, 1); % critic weights
    wA = zeros(nS, nA); % actor weights
    VC = 0; % critic value at time t in state s
    PA = ones(1, nA) / nA; % actor proba distrib %INITIAL POLICY...
    ACT = zeros(1, nA); % actor output
    alphaC = 0.5; % critic learning rate
    alphaA = 0.2; % actor learning rate
    sigma = 18.8; % Gaussian width for exploration of action parameter (0-100) %CONSIDER ONE SIGMA PER STATE...
    intervalle = BBtask.intervalle; % interval of possible action parameters
    decisionRule = 'softmax'; %TRY E-GREEDY AT SOMEPOINT?
    
    % parameters for active exploration on sigma
    gainSigma = 20; % gain of transformation of sigma. 100 for wA. 200 for kalmanCOV
    %I have changed gainSigma in BBrobotLearns!
    
    % Initialize Schweighofer meta-learning
    tau1 = 10; % short-term time constant
    tau2 = 5; % long-term time constant
    star = 0; % short-term running average
    mtar = 0; % mid-term running average
    mu = 0.5; % learning rate of meta-parameter
    metaparam = 0; % meta-parameter to be tuned
    
    
    % FOR NEW MODEL V4!!! STATE-DEPENDENT METAPARAMETERS
    STARS = 0*ones(1,nS);
    MTARS = 0*ones(1,nS);
    METAPARAMS = 0*ones(1,nS);
    SIGMAS = 18.8*ones(1, nS); 
    BETAS = 0.2*ones(1,nS); 
    
    % FOR NEW MODEL V5!!! STATE DEPENDENT BETA + STATE-ACTION DEPENDENT
    % SIGMAS
    METAPARAMS2 = 0*ones(nS,nA);
    SIGMAS2 = 0*ones(nS,nA);
    STARS2 = -2.0*ones(nS, nA); %-0.5 is a good value for engaging exploraion fast
    MTARS2 = 0*ones(nS, nA);
    BETAS = 10*ones(1,nS);
    time_sa = ones(nS,nA);
    timestep = 1;
    Hits = [];
    DHits = [];
    PV = [];
    
    ActionsTaken = nan*zeros(nA,1,nS); %rows actions - columns time - 3rd state :value=parameter value

    
    % build a structure for the hybrid robot
    BBR = struct('nS', nS, 'nA', nA, 'alphaC', alphaC, 'alphaA', alphaA, ...
        'beta', beta, 'gamma', gamma, 'sigma', sigma, 'intervalle', intervalle, ...
        'alphaQ', alphaQ, 'gainSigma', gainSigma, 'tau1', tau1, 'tau2', tau2, 'mu', ...
        mu, 'wC', wC, 'wA', wA, 'VC', VC, 'PA', PA, 'ACT', ACT, 'delta', delta, ...
        'decisionRule', decisionRule, 'Q', Q, 'RPEQ', RPEQ, 'star', star, ...
        'mtar', mtar, 'metaparam', metaparam, ...
        'STARS', STARS, 'MTARS', MTARS, 'METAPARAMS', METAPARAMS, 'SIGMAS', SIGMAS, 'BETAS', BETAS,...
        'METAPARAMS2', METAPARAMS2, 'SIGMAS2', SIGMAS2, 'STARS2', STARS2, 'MTARS2', MTARS2, ... 
        'time_sa', time_sa, 'timestep', timestep, 'ActionsTaken', ActionsTaken, 'Hits', Hits, 'DHits',DHits, 'PV', PV);
end