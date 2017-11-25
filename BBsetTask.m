function BBtask = BBsetTask()

    % This functions returns the task for the Baby Robot Use Case 2 Learning scenario.

    %% Context/Child number (=type of children involved in the interaction)
    % 1 = normal
    % 2 = curious
    % 3 = introspective
    nC = 1; % USELESS
    
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
    % current optimal action in each state
    %optimal = ones(1, nS);
    optimal = nA-nS+1:nA; %THIS IS THE DEFAULT ... [2, 3, 4, 5, 6] OPTIMAL ACTIONS AT EACH STATE
    %optimal = randperm(nS); %optimal action at each state..
    %optimal = randi(nA, [1,nS]); %optimal action at each state...
    % preference of the child for continuous parameters
    engMu = zeros(1, nS); engMu([2 4]) = 50; engMu([1 3 end]) = -50; %THIS IS THE DEFAULT
    %engMu = randi([-100 100], [1, nS]); 
    % fixed width of the gaussian around child's preference
    engSig = 10; %default is 10
    
    %% Action parameters
    % interval of possible continuous action parameters
    intervalle = [-100:5:100]; %IT WAS [-100:5:100];

    % Initial state distribution. This a vector which indicates the probability of
    % starting in a given state, for each state. Recall that our robot will always
    % start in state 1. Fill in the corresponding probabilities.
    P0 = zeros(1, nS);
    P0(1) = 1; %always start in state 1... no lose of generality
    
    % Transition probabilities matrix
    % For example, P(2, A, 1) represents the probability of moving to state 1
    % from state 2 when choosing action A.
%     P = zeros(nS, nA, nS);
%     for state = 1:nS
%         for action = 1:nA
%             if (action == optimal(state)) % optimal action in this state
%                 if (state == nS) % terminal state
%                     P(state, action, 1) = 1; % go back to initial state
%                 else
%                     P(state, action, state+1) = 1; % move forward
%                 end
%             else % not the optimal action in this state
%                 P(state, action, state) = 1; % we remain in this state
%             end
%         end
%     end
    [P, optimal, engMu] = setTransitions(nS,nA); 

    % We now create a structure that stores all the elements of the MDP
    BBtask = struct('nC', nC, 'minENG', minENG, 'maxENG', maxENG, 'cENG', cENG, 'forget', forget, 'reeng', reeng, 'engMu', engMu, 'engSig', engSig, 'lambdaRwd', lambdaRwd, 'nS', nS, 'nA', nA, 'P0', P0, 'intervalle', intervalle, 'optimal', optimal, 'P', P);

end