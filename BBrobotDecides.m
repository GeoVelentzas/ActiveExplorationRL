function [BBR, a, probaA, probaPISA] = BBrobotDecides(BBT, BBR, s)

    % BBR is a structure containing the Baby Robot
    % s = current state
    % decisionRule = 'rand' / 'softmax' / 'max' / 'matching' / 'epsilon'
    % output of the robot learning system
    BBR.ACT = BBR.wA(s,:); % from the Actor of CACLA
    BBR.VC = BBR.wC(s); % from the Critic of CACLA
    
    %% decision of the discrete action to be performed by the robot
    BBR.BETAS(s) = max(0, BBR.METAPARAMS(s)+10);
    [a.action, BBR.PA] = valueBasedDecision(BBR.Q(s,:), BBR.decisionRule, BBR.BETAS(s), 0);
    probaA = BBR.PA(BBT.optimal(s)); % log de la proba qu'avait le mod�le d'effectuer l'action optimale
    
    %% decision of the width sigma of the Gaussian from which to draw a continuous param
    a.param = BBR.ACT(a.action); % default == exploitation
    % Here we will explore by choosing a value around the learned
    % action parameter a.param within a Gaussian distribution of mean =
    % a.param and variance = BBR.sigma.
    % Each model has a different way of determining BBR.sigma.
    %% UPDATING sigma for CACLA actor exploration
    BBR.sigma = 20 / (1 + 19 * exp(BBR.gainSigma * BBR.metaparam));
    BBR.sigma = 40 / (1 + 39 * exp(BBR.gainSigma * BBR.metaparam));
    %NEW MODEL V3 HERE !!!!!!!!!!!!!!!!!!!!
    for i = 1:BBT.nA
        if i == a .action
            %BBR.SIGMAS2(s, i) = 20./(1+19*exp(BBR.gainSigma*BBR.METAPARAMS2(s, i)));
            %BBR.SIGMAS2(s, i) = max(BBR.SIGMAS2(s, i), 0.1);
            %BBR.SIGMAS2(s, i) = min(BBR.SIGMAS2(s, i), 20);
            
            %stable version
            BBR.SIGMAS2(s, i) = 40./(1+39*exp(BBR.gainSigma*BBR.METAPARAMS2(s, i))); %increase this.. 20 is not enough
            BBR.SIGMAS2(s, i) = max(BBR.SIGMAS2(s, i), 0.1);
            BBR.SIGMAS2(s, i) = min(BBR.SIGMAS2(s, i), 40);
            
            %                     BBR.gainSigma = 1e8;
            %                     power = 1000;
            %                     BBR.SIGMAS2(s, i) = 80*1./(1+1*exp(BBR.gainSigma*BBR.METAPARAMS2(s, i))); %increase this.. 20 is not enough
            %                     BBR.SIGMAS2(s, i) = max(BBR.SIGMAS2(s, i), 0.1);
            %                     BBR.SIGMAS2(s, i) = min(BBR.SIGMAS2(s, i), 40);
            
        else
            %BBR.SIGMAS2(s, i) = max(BBR.SIGMAS2(s,i)+0.1, 0.1);
            %BBR.SIGMAS2(s, i) = min(BBR.SIGMAS2(s, i), 40);
        end
    end
    %bar3(BBR.SIGMAS2);
    %pause(0.1);
    
    
    if (BBR.sigma <= 0.1)
        BBR.sigma = 0.1;
    end
    
    %% decision of the continuous parameter a.param to be executed
    %pisa = exp(- (BBR.intervalle - a.param) .^ 2 ./ (2 * BBR.sigma ^ 2)) ./ (sqrt(2 * pi)* BBR.sigma);
    %pisa = pisa / sum(pisa);
    % pisa is a pdf centered on a.param with variance = BBR.sigma^2
    %a.param = BBR.intervalle(drand01(pisa));
    % we randomly pick a.param from the pisa density function
    %probaPISA = pisa(floor(1+(BBT.engMu+100)/5));
    
    
    % NEW MODEL HERE !!!!!!!!!!
    pisa = exp(- (BBR.intervalle - a.param) .^ 2 ./ (2 * BBR.SIGMAS2(s, a.action) ^ 2)) ./ (sqrt(2 * pi)* BBR.SIGMAS2(s, a.action));
    pisa = pisa / sum(pisa);
    % pisa is a pdf centered on a.param with variance = BBR.sigma^2
    a.param = BBR.intervalle(drand01(pisa));
    % we randomly pick a.param from the pisa density function
    probaPISA = pisa(floor(1+(BBT.engMu+100)/5));
    
    
    
    % increment number the number of times (s,a) has been selected
    BBR.ActionsTaken(a.action, BBR.timestep, s) = a.param;
    p = (exp((- (a.param - BBT.engMu(s)) ^ 2) / (2 * BBT.engSig ^ 2)) - 0.5) * 2;

    if (a.action == BBT.optimal(s))%&&(a.action==BBT.optimal(BBT.nS)))
        BBR.Hits = [BBR.Hits 1];
        BBR.PV(s,BBR.timestep) = p;
        if (p > 0)
            BBR.DHits = [BBR.DHits 1];
        else
            BBR.DHits = [BBR.DHits 0];
        end
    else
        BBR.Hits  = [BBR.Hits 0];
        BBR.DHits = [BBR.DHits 0];
    end
    
    BBR.time_sa(s,a.action) = BBR.time_sa(s,a.action) + 1;
    BBR.timestep = BBR.timestep + 1;

    
    
            
end