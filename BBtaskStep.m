function y = BBtaskStep(BBT, s, a)
    % This function executes a step on the MDP M given current state s and action a.
    % It returns a next state y and a reward r
    
    %[size(BBT.P) BBT.nS BBT.nA s a.action]
    y = drand01(reshape(BBT.P(s, a.action, :), BBT.nS, 1)');
    %r = BBT.R(s, a); %+ 1.0*randn;

end