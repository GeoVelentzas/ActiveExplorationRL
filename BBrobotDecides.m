function [BBR, a, probaA, probaPISA] = BBrobotDecides(BBT, BBR, s)

    % s = current state
    BBR.ACT = BBR.wA(s,:); % from the Actor of CACLA
    BBR.VC = BBR.wC(s); % from the Critic of CACLA
    BBR.BETAS(s) = max(0, BBR.METAPARAMS(s)+10); %+10 for multi-state
    [a.action, BBR.PA] = valueBasedDecision(BBR.Q(s,:), BBR.decisionRule, BBR.BETAS(s), 0);
    probaA = BBR.PA(BBT.optimal(s));
    a.param = BBR.ACT(a.action); 
    BBR.sigma = 40 / (1 + 39 * exp(BBR.gainSigma * BBR.metaparam));

    for i = 1:BBT.nA
        if i == a .action
            BBR.SIGMAS2(s, i) = 40./(1+39*exp(BBR.gainSigma*BBR.METAPARAMS2(s, i))); %increase this.. 20 is not enough
            BBR.SIGMAS2(s, i) = max(BBR.SIGMAS2(s, i), 4); %default 0.1
            BBR.SIGMAS2(s, i) = min(BBR.SIGMAS2(s, i), 40);
        else
            BBR.SIGMAS2(s, i) = 0.9*BBR.SIGMAS2(s, i) + 0.1*40;
        end
    end
            
    pisa = exp(- (BBR.intervalle - a.param) .^ 2 ./ (2 * BBR.SIGMAS2(s, a.action) ^ 2)) ./ (sqrt(2 * pi)* BBR.SIGMAS2(s, a.action));
    pisa = pisa / sum(pisa);
    a.param = BBR.intervalle(drand01(pisa));
    probaPISA = pisa(floor(1+(BBT.engMu+100)/5));
    
    
    BBR.ActionsTaken(a.action, BBR.timestep, s) = a.param;
    p = (exp((- (a.param - BBT.engMu(s)) ^ 2) / (2 * BBT.engSig ^ 2)) - 0.5) * 2;
    BBR.H = [BBR.H nan*ones(BBR.nS,1)];

    if (a.action == BBT.optimal(s))
        BBR.Hits = [BBR.Hits 1];
        BBR.PV(s,BBR.timestep) = p;
        BBR.H(s,end) = p;
        if (p >= 0)
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