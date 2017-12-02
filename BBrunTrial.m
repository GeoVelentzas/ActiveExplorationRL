function [ BBT, BBR, s, a ] = BBrunTrial( BBT, BBR, s, a )
    
    % BBT = task used for Baby Robot learning
    % BBR = structure containing the baby robot
    % whichModel = 1 QL 2 kalman 3 sigma2Q 4 hybrid 5 schweig1 6 schweig2
    % s = state vector in which the robot was
    % a = structure containing [executed action, action parameter]
    
    %% UPDATING THE TASK STATE
    % Perform a step of the TASK by executing the action decided outside the
    % function
    % for the moment, only the pointing action can increase the child's
    % engagement
    % y = new state ; r = new reward
    % y = s; % new state
    % r = 0; % new reward
    y = BBtaskStep( BBT, s, a ); %USING TRANSITION MATRIX CHOSE NEXT STATE
    olds = s; % storing s
    olda = a; % storing a
    
    %% UPDATING THE CHILD ENGAGEMENT
    % storing the old engagement
    oldEng = BBT.cENG;
    % computing the new engagement (only in the terminal state)
%     if (s == BBT.nS)
        if (a.action == BBT.optimal(s))
            %% gaussian child engagement
            % probaEng is between -1 (disengagement) and 1 (reengagement)
            % a.param is the continuous parameter executed by the robot
            % BBT.engMu is the optimal parameter
            probaEng = (exp((- (a.param - BBT.engMu(s)) ^ 2) / (2 * BBT.engSig ^ 2)) - 0.5) * 2;
            if (probaEng >= 0)
                BBT.cENG = BBT.cENG + probaEng * BBT.reeng * (BBT.maxENG - BBT.cENG);
                %r = 1;
            else
                BBT.cENG = BBT.cENG - probaEng * BBT.forget * (BBT.minENG - BBT.cENG);
                %r = 0;
            end
        else % the robot performed a non-optimal action
            BBT.cENG = BBT.cENG + BBT.forget * (BBT.minENG - BBT.cENG);
            %r = 0;
        end
%     else % other state than terminal state
%         %r = 0;
%     end
    %% setting the reward as a function of the difference in engagement
    %r = BBT.cENG - oldEng; % reward = variations in child engagement
    %r = (BBT.cENG - 5) / 20; % reward = (child engagement - 5) / 5
    r = (1 - BBT.lambdaRwd) * (BBT.cENG - 5) / 5 + BBT.lambdaRwd * 2 * (BBT.cENG - oldEng); % mixed reward function
    %r = (1 - BBT.lambdaRwd) * BBT.cENG + BBT.lambdaRwd *(BBT.cENG - oldEng);
    
    
    %% HAVE THE ROBOT LEARN FROM THIS OUTCOME
    BBR = BBrobotLearns( BBR, s, a, y, r );
    
    %% NEXT STATE
    s = y; % the next state becomes the current state
    
    %% HAVE THE ROBOT MAKE A DECISION
    [BBR, a, probaA, probaPISA] = BBrobotDecides( BBT, BBR, s );
    
    
    
    
end