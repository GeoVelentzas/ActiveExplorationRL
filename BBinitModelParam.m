function BBR = BBinitModelParam( BBR )
load('bestModelsOptiSummer2016.mat')
vectParam = bestModels(5,1:10); 
BBR.beta = vectParam(1);
BBR.gamma = vectParam(2);
BBR.alphaC = vectParam(3);
BBR.alphaA = vectParam(4);
BBR.rateSigma = vectParam(5);
BBR.tau1 = vectParam(6);
BBR.tau2 = vectParam(7);
BBR.mu = vectParam(8);
end