classdef agent
    properties
        Q; beta; sigma; rbar; rbbar; nS; nA; scale;
    end
    
    methods
        function obj = agent(nS, nA, scale)
            obj.rbar = 0 * ones(nS, nA);
            obj.rbbar = 0 * ones(nS, nA);
            obj.beta = 0 * ones(1,nS);
            obj.sigma = 0 * ones(nS,nA);
            obj.Q = 0 * ones(nS,nA);
            obj.nA = nA;
            obj.nS = nS;
            obj.scale = scale;
            
        end
        
        function [a,p] = decide(obj, state)
            a = randperm(obj.nA);
            a = a(1);
            p = randn * obj.scale;
        end
            
    end
end