function BBR = BBsetParams( BBR, task )

switch task
    case {'non-stationary2', 'stochastic-non-stationary2', 'non-stationary1', 'stochastic-non-stationary1'}
        BBR.alphaC=0.1; 
        BBR.alphaA=0.5; 
        BBR.gamma=0.7; 
        BBR.mu=0.1; 
        BBR.tau1=10; 
        BBR.tau2=5; 
        BBR.gainSigma=20;
    case {'non-stationary0', 'stationary', 'stochastic-non-stationary0'}
        BBR.alphaC=0.5; 
        BBR.alphaA=0.2; 
        BBR.gamma=0.95; 
        BBR.mu=0.2;                             
        BBR.tau1=10; 
        BBR.tau2=5; 
        BBR.gainSigma=20;
    otherwise
        warning('not a known task type')
end

