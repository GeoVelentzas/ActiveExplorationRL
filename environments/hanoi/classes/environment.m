classdef environment
    properties
        %T: Transition Matrix
        %O: Optimal Actions-Params
        T; O; P; s; sp; r; engSig; minEng; maxEng; cEng; reeng; forget; lambdaRwd; optimalP; V; OptPar;
    end
    
    methods
        function obj = environment(T,O,P,varargin)
            obj.s = 1;
            obj.sp = 1;
            obj.T = T;
            obj.O = O;
            obj.engSig = 10;
            obj.minEng = 0;
            obj.maxEng = 10;
            obj.cEng = (obj.maxEng+obj.minEng)/2;
            obj.reeng =  0.2; %0.2;   %default for re-engagement
            obj.forget = 0.05; %0.05;  %default for disengagement
            obj.lambdaRwd = 0.7;
            obj.P = P;
            obj.optimalP = 0;
            if nargin<4
                obj.V = ones(size(T,1), size(T,2));
            else
                obj.V = varargin{1};
            end
        end
        
        function [obj,r] = step(obj, action, p) %or try two params per action...
            oldEng = obj.cEng;
            s1 = obj.s;
            s2 = obj.T(s1, action);
            if obj.O(obj.s,action) %action is optimal here...
                obj.optimalP = obj.P(obj.OptPar(s));
                H = (exp((- (p - obj.P(type)) ^ 2) / (2 * obj.engSig ^ 2)) - 0.5) * 2;
                obj.optimalP = obj.P(type);
                if H >= 0
                    obj.cEng = obj.cEng + H * obj.reeng * (obj.maxEng - obj.cEng);
                    r2 = 1;
                else
                    obj.cEng = obj.cEng - H * obj.forget * (obj.minEng - obj.cEng);
                    r2 = -0;
                end
            else %action is not the optimal here....
                obj.cEng = obj.cEng + obj.forget * (obj.minEng - obj.cEng);
                r2 = -10;
                obj.optimalP = 0; %no meaning...
            end
            r1 = (1 - obj.lambdaRwd) * (obj.cEng - 5) / 5 + obj.lambdaRwd * 2 * (obj.cEng - oldEng); % mixed reward function
            obj.s = obj.T(obj.s, action);
            %if obj.s == 26
            %    r2 = 10;
            %end
            r = r1+r2;%
            %r = r1;
            % add reward based on parameter value...
            
        end
        
    end
end


















