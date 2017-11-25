function [ TDerror, values ] = temporalDifferenceError( reward, minRwd, maxRwd, action, values, newvalues, weight, alpha, gamma, kappa1, kappa2, alpha2, Qinit )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    % reward = reward value obtained by the agent
    % action = action that was performed
    % values = action values in the previous state
    % weight = probability of having being in the previous state (POMDP)
    % newvalues = action values in the new state
    % alpha = learning rate
    % gamma = discount factor
    % kappa1 = magnitude of reward
    % kappa2 = magnitude of no-reward
    kapa3 = 0; % before kapa3 = kapa2 with kapa2 always equal to 0
    % alpha2 = forgetting rate for non chosen actions
    nbAction = length(values);
    TDerror = zeros(1,nbAction);
    TDerror(action) = (reward~=0)*reward*kappa1 + (reward==0)*(reward-1)*kappa2 + gamma*max(newvalues) - values(action);
    values(action) = values(action) + weight*alpha*TDerror(action);
    if (nbAction > 1),
        for iii=0:(nbAction-2), % we update the values of non-chosen actions
            TDerror(mod(action+iii,nbAction)+1) = Qinit + (reward>minRwd)*minRwd*kapa3 + (reward<=minRwd)*maxRwd*kapa3 + gamma*max(newvalues) - values(mod(action+iii,nbAction)+1);
            values(mod(action+iii,nbAction)+1) = values(mod(action+iii,nbAction)+1) + weight*alpha2*TDerror(mod(action+iii,nbAction)+1);
        end;
    end;
end

