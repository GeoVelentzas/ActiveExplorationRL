classdef agent
    properties
        Q; betas; sigmas; rbar; rbbar; nS; nA; interval; gainSigma; gamma;
        metaparams; stars; mtars; alphaC; alphaA; alphaQ; mu; tau1; tau2;
        wC; wA; VC; PA; ACT; stars2; mtars2; metaparams2;
    end
    
    methods
        function obj = agent(nS, nA, param_scale)
            % agent initialization...
            disp('agent initializing ...');
            obj.mtars = 0*ones(1,nS);
            obj.stars = -2.0*ones(1,nS);
            obj.mtars2 = 0*ones(nS,nA);
            obj.stars2 = -2.0*ones(nS,nA);
            obj.rbar = 0 * ones(nS, nA);
            obj.rbbar = 0 * ones(nS, nA);
            obj.betas = 0 * ones(1,nS);
            obj.sigmas = 0 * ones(nS,nA);
            obj.Q = 0 * ones(nS,nA);
            obj.nA = nA;
            obj.nS = nS;
            obj.interval = -param_scale:0.1:param_scale;
            obj.metaparams = 0 *ones(1,nS);
            obj.metaparams2 = 0 *ones(nS,nA);
            obj.alphaC = 0.1;   %def 0.1
            obj.alphaA = 0.5;   %def 0.5
            obj.alphaQ = 0.4;   %def 0.4
            obj.gamma = 0.7;    %def 0.7
            obj.mu = 0.1;       %def 0.9
            obj.tau1 = 10;      %def 10
            obj.tau2 = 5;       %def 5
            obj.gainSigma = 20; %def 20
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
            obj.ACT(a) = max(obj.ACT(a), -100);
            obj.ACT(a) = min(obj.ACT(a), 100);
            p = obj.ACT(a); 
            for i = 1:obj.nA
                smin = 2;   %minimum std
                smax = 40;   %maximum std
                if i == a
                    obj.sigmas(s, i) = (smax-smin)./(1+(smax-1-smin)*exp(obj.gainSigma*(obj.metaparams2(s, i)-0.25)))+smin; %0.1 default
                end
            end
            pisa = exp(- (obj.interval - p) .^ 2 ./ (2 * obj.sigmas(s, a) ^ 2)) ./ (sqrt(2 * pi)* obj.sigmas(s, a));
            pisa = pisa / sum(pisa);
            p = obj.interval(drand01(pisa));
        end
        
        function obj = learn(obj, s, a, p, r, sp)
            obj.stars(s) = obj.stars(s) + (r-obj.stars(s))/obj.tau1;
            obj.mtars(s) = obj.mtars(s) + (obj.stars(s) - obj.mtars(s))/obj.tau2;
            obj.metaparams(s) = obj.metaparams(s) + obj.mu*(obj.stars(s)-obj.mtars(s));
            
            obj.stars2(s,a) = obj.stars2(s,a) + (r-obj.stars2(s,a))/obj.tau1;
            obj.mtars2(s,a) = obj.mtars2(s,a) + (obj.stars2(s,a) - obj.mtars2(s,a))/obj.tau2;
            obj.metaparams2(s,a) = obj.metaparams2(s,a) + obj.mu*(obj.stars2(s,a)-obj.mtars2(s,a));
            %obj.metaparams2(s,a) = min(0.5, obj.metaparams2(s,a));
            %obj.metaparams2(s,a) = max(-0.4, obj.metaparams2(s,a));
            
            newQvalues = obj.Q(sp,:);
            deltaQ = r + obj.gamma*max(newQvalues) - obj.Q(s,a);
            obj.Q(s,a) = obj.Q(s,a) + obj.alphaQ*deltaQ;

            value = obj.wC(sp);
            deltaV = r + obj.gamma*value - obj.VC;
            obj.wC(s) = obj.wC(s) + obj.alphaC*deltaV;
            
            if deltaV>0
                obj.wA(s,a) = obj.wA(s,a) + obj.alphaA*deltaV*(p-obj.ACT(a));
            end
        end
        
    end
end


















