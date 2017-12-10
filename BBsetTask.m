function BBtask = BBsetTask()

    %% Context/Child number (=type of children involved in the interaction)
    % 1 = normal
    % 2 = curious
    % 3 = introspective
    nC = 1; % not used
    
    %% Context/Child engagement
    % min engagement
    minENG = 0;
    % max engagement
    maxENG = 10;
    % current engagement = initial child engagement (just the fact to see the robot)
    cENG = (minENG+maxENG)/2; % OLD : minENG;
    % re-engagement rate
    reeng = 0.2;
    % forgetting rate
    forget = 0.05; %0.01;
    % weight of engagement variations in reward function
    lambdaRwd = 0.7;

    %% Number of states
    % CONSIDER SWITCHING TO RELATIONAL REINFORCEMENT LEARNING (PIETQUIN)
    nS = 5;

    %% Number of actions available to the robot:
    % 6 Actions: 1 nothing, 2 pointing, 3 picking, 4 placing, 5 giving, 6 receiving.
    nA = 6;
    
    %% OPTIMAL ACTION AND PARAMETERS

    % fixed width of the gaussian around child's preference
    engSig = 10; %default is 10
    
    % interval of possible continuous action parameters
    intervalle = [-100:0.01:100]; %default [-100:5:100];

    % Initial state distribution. This a vector which indicates the probability of
    % starting in a given state, for each state. Recall that our robot will always
    % start in state 1. Fill in the corresponding probabilities.
    P0 = zeros(1, nS);
    P0(1) = 1; %always start in state 1... no loss of generality
    
    [P, optimal, engMu] = setTransitions(nS,nA); 

    % We now create a structure that stores all the elements of the MDP
    BBtask = struct('nC', nC, 'minENG', minENG, 'maxENG', maxENG, 'cENG', cENG, 'forget', forget, 'reeng', reeng, 'engMu', engMu, 'engSig', engSig, 'lambdaRwd', lambdaRwd, 'nS', nS, 'nA', nA, 'P0', P0, 'intervalle', intervalle, 'optimal', optimal, 'P', P);

end