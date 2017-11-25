function BBR = BBinitModelParam( BBR, vectParam, whichModel )
    % whichModel = 1 QL 5 NTUA 8 USTL
    % vectParam contains the list of parameters of the studied model
    % BBR = structure containing the baby robot
    
    % set model parameters for the baby robot
    switch(whichModel)
        case 1 %% Q-learning
            BBR.beta = vectParam(1);
            BBR.gamma = vectParam(2);
            BBR.alphaC = vectParam(3);
            BBR.alphaA = vectParam(4);
            BBR.sigma = vectParam(5);
            BBR.alphaQ = vectParam(6);
        case 5 %% Schweighofer 1
            BBR.beta = vectParam(1);
            BBR.gamma = vectParam(2);
            BBR.alphaC = vectParam(3);
            BBR.alphaA = vectParam(4);
            BBR.rateSigma = vectParam(5);
            BBR.tau1 = vectParam(6);
            BBR.tau2 = vectParam(7);
            BBR.mu = vectParam(8);
        case 8 %% USTL policy gradient
            
    end
    
end