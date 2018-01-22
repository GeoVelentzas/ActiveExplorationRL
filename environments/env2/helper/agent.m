classdef agent
    properties
        Q; betas; sigmas; rbar; rbbar; nS; nA; interval; gainSigma; gamma;
        metaparams; stars; mtars; alphaC; alphaA; alphaQ; mu; tau1; tau2;
        delta; wC; wA; VC; PA; ACT;
    end
    
    methods
        function obj = agent(nS, nA, param_scale)
            % agent initialization...
            disp('agent initializing ...');
            obj.mtars = 0*ones(nS,nA);
            obj.stars = 0*ones(nS,nA);
            obj.rbar = 0 * ones(nS, nA);
            obj.rbbar = 0 * ones(nS, nA);
            obj.betas = 0 * ones(1,nS);
            obj.sigmas = 0 * ones(nS,nA);
            obj.Q = 0 * ones(nS,nA);
            obj.nA = nA;
            obj.nS = nS;
            obj.interval = -param_scale:0.01:param_scale;
            obj.metaparams = 0 *ones(nS,nA);
            obj.alphaC = 0.1;
            obj.alphaA = 0.5;
            obj.alphaQ = 0.4;
            obj.gamma = 0.7;
            obj.mu = 0.1;
            obj.tau1 = 10;
            obj.tau2 = 5;
            obj.gainSigma = 20;
            obj.delta = 0; %reward prediction error
            obj.wC = zeros(nS, 1); %critic weights
            obj.wA = zeros(nS, nA); %actor weights
            obj.VC = 0; %critic value at time t in state s
            obj.PA = ones(1, nA)/ nA; %actor probability distribution (initial policy)
            obj.ACT = zeros(1, nA); %actor output
        end
        
        function [obj,a,p] = decide(obj, s)
            obj.ACT = obj.wA(s,:); %from Actor of CACLA
            obj.VC = obj.wC(s);    %from the Critic of CACLA
            obj.betas(s) = max(0, obj.metaparams(s)+10); %+10 for multi state
            logits = min(obj.betas(s)*obj.Q(s,:) , ones(1,obj.nA)*700);
            proba = exp(logits) / sum(exp(logits));
            a = drand01(proba);
            p = obj.ACT(a); 
            for i = 1:obj.nA
                smin = 3;  %minimum std
                smax = 40; %maximum std
                if i == a
                    obj.sigmas(s, i) = (smax-smin)./(1+(smax-1-smin)*exp(obj.gainSigma*(obj.metaparams(s, i)-0.1)))+smin;
                end
            end
            pisa = exp(- (obj.interval - p) .^ 2 ./ (2 * obj.sigmas(s, a) ^ 2)) ./ (sqrt(2 * pi)* obj.sigmas(s, a));
            pisa = pisa / sum(pisa);
            p = obj.interval(drand01(pisa));
        end
        
        function obj = learn(obj, s, a, p, r, sp)
            x=1;
        end
        
    end
end


















