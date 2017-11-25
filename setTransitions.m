function [ P, optimal, engMu ] = setTransitions( nS, nA)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


optimal = nA-nS+1:nA; %[2,3,4,5,6]
P = zeros(nS, nA, nS);
for state = 1:nS
    for action = 1:nA
        if (action == optimal(state)) % optimal action in this state
            if (state == nS) % terminal state
                P(state, action, 1) = 1; % go back to initial state
            else
                P(state, action, state+1) = 1; % move forward
            end
        else % not the optimal action in this state
            P(state, action, state) = 1; % we remain in this state
        end
    end
end
engMu = zeros(1, nS);
engMu([2 4]) = 50;
engMu([1 3 end]) = -50;

