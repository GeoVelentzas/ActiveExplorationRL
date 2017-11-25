function BBR = BBrobotLearns( BBR, s, a, y, r )
    
    % BBR = structure containing the baby robot
    % s = state where the robot was
    % a = executed action (has 2 components, number and param)
    % y = state where the robot found himself after doing action u
    % r = reward obtained by the robot when arriving in state y
    % eng = level of engagement of the child

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Learning in Schweighofer meta-learning
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % updating short-term reward running average
    BBR.star = BBR.star + (r - BBR.star) / BBR.tau1;
    % updating mid-term reward running average
    BBR.mtar = BBR.mtar + (BBR.star - BBR.mtar) / BBR.tau2;
    % updating the meta-parameter 
    BBR.metaparam = BBR.metaparam + BBR.mu * (BBR.star - BBR.mtar);
    
    
    %NEW MODEL V3 HERE !!!!!!!!!!!!!!!!!!!!!!!
    BBR.STARS(s) = BBR.STARS(s) + (r - BBR.STARS(s))/BBR.tau1;
    BBR.MTARS(s) = BBR.MTARS(s) + (BBR.STARS(s) - BBR.MTARS(s))/ BBR.tau2;
    BBR.METAPARAMS(s) = BBR.METAPARAMS(s) + BBR.mu*(BBR.STARS(s) - BBR.MTARS(s));
    
    BBR.STARS2(s,a.action) = BBR.STARS2(s,a.action) + (r-BBR.STARS2(s,a.action))/BBR.tau1;
    BBR.MTARS2(s,a.action) = BBR.MTARS2(s,a.action) + (BBR.STARS2(s, a.action)-BBR.MTARS2(s,a.action))/BBR.tau2;
    BBR.METAPARAMS2(s, a.action) = BBR.METAPARAMS2(s, a.action) + BBR.mu*(BBR.STARS2(s,a.action) - BBR.MTARS2(s,a.action));
    
    %try unbiased method
%     lr1 = (BBR.tau1-1)/BBR.tau1;
%     lr2 = (BBR.tau2-1)/BBR.tau2;
%     lr3 = (1-BBR.mu);
%     BBR.STARS2(s,a.action) = (1-lr1^BBR.time_sa(s,a.action))*(BBR.STARS2(s,a.action) + (r-BBR.STARS2(s,a.action))/BBR.tau1);
%     BBR.MTARS2(s,a.action) = (1-lr2^BBR.time_sa(s,a.action))*(BBR.MTARS2(s,a.action) + (BBR.STARS2(s, a.action)-BBR.MTARS2(s,a.action))/BBR.tau2);
%     BBR.METAPARAMS2(s, a.action) = (1-lr3^BBR.time_sa(s,a.action))*(BBR.METAPARAMS2(s, a.action) + BBR.mu*(BBR.STARS2(s,a.action) - BBR.MTARS2(s,a.action)));
    
    
    
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Learning action values with Q-learning
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % computing Q-values in the new state y
    newQvalues = BBR.Q(y, :);
    % computing reward prediction error
    BBR.RPEQ(a.action) = r + BBR.gamma * max(newQvalues) - BBR.Q(s, a.action);
    % updating wQ weights through Q-learning
    BBR.Q(s, a.action) = BBR.Q(s, a.action) + BBR.alphaQ * BBR.RPEQ(a.action);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Learning action parameters in the CACLA Actor-Critic
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% UPDATING THE CRITIC
    % Compute the critic value function in the new state y
    BBR.value = BBR.wC(y);
    % Compute reinforcement signal (temporal-difference error)
    BBR.delta = r + BBR.gamma * BBR.value - BBR.VC;
    % Update the critic weights with TD-Learning
    BBR.wC(s) = BBR.wC(s) + BBR.alphaC * BBR.delta;
    
    %% UPDATING THE ACTOR
    % updating only for action performed a.action
    if BBR.delta>0    
      BBR.wA(s, a.action) = BBR.wA(s, a.action) + BBR.alphaA * BBR.delta * (a.param - BBR.ACT(a.action));
    end
end