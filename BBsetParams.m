function BBR = BBsetParams( task )

switch task
    case 'non-stationary2'
        BBR.aC=0.1; 
        BBR.aA=0.5; 
        BBR.gamma=0.7; 
        BBR.mu=0.1; 
        BBR.tau1=10; 
        BBR.tau2=5; 
        BBR.gainSigma=20;
    case 'non-stationary1'
        BBR.aC=0.1; 
        BBR.aA=0.5; 
        BBR.gamma=0.7; 
        BBR.mu=0.1; 
        BBR.tau1=10; 
        BBR.tau2=5; 
        BBR.gainSigma=20;
    case 'non-stationary0'
        BBR.aC=0.5; 
        BBR.aA=0.2; 
        BBR.gamma=0.95; 
        BBR.mu=0.2;                             
        BBR.tau1=10; 
        BBR.tau2=5; 
        BBR.gainSigma=20;
end

