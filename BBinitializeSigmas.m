function [BBR] = BBinitializeSigmas(BBR, BBT, T)

rbar = -1*ones(BBR.nS, BBR.nA); rbbar = 0*zeros(BBR.nS, BBR.nA);

for t = 1:T
    for s = 1:BBT.nS
        for a = 1:BBT.nA
            r = 0; 
            rbar(s,a) = rbar(s,a) + (r-rbar(s,a))/BBR.tau1;
            rbbar(s,a) = rbbar(s,a) +(rbar(s,a) - rbbar(s,a))/BBR.tau2;
            BBR.METAPARAMS2(s,a) = BBR.METAPARAMS2(s,a) + BBR.mu*(rbar(s,a)-rbbar(s,a));
            BBR.SIGMAS2(s, a) = 40./(1+39*exp(BBR.gainSigma*BBR.METAPARAMS2(s, a))); %increase this.. 20 is not enough
            BBR.SIGMAS2(s, a) = max(BBR.SIGMAS2(s, a), 0.1);
            BBR.SIGMAS2(s, a) = min(BBR.SIGMAS2(s, a), 40);
            disp(BBR.SIGMAS2(1,1));
            %pause(0.2);
        end
    end
end
end