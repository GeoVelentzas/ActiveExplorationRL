classdef environment
    properties
        %T: Transition Matrix
        %O: Optimal Actions-Params
        T; O; P; s; sp; r; engSig; minEng; maxEng; cEng; reeng; forget; lambdaRwd;
    end
    
    methods
        function obj = environment(T,O,P)
            obj.s = 1;
            obj.sp = 1;
            obj.T = T;
            obj.O = O;
            obj.engSig = 10;
            obj.minEng = 0;
            obj.maxEng = 10;
            obj.cEng = (obj.maxEng+obj.minEng)/2;
            obj.reeng = 0.2;
            obj.forget = 0.05;
            obj.lambdaRwd = 0.7;
            obj.P = P;
        end
        
        function [obj,r] = step(obj, action, p) %two params per action...
            oldEng = obj.cEng;
            s1 = obj.s;
            s2 = obj.T(obj.s, action);
            if obj.O(obj.s,action) %action is optimal here...
                %r = 1;
                if (s1<=24)&&(s2<=24)
                    %1-1
                    type = 1;
                elseif (s1<=24)&&(s2>=25)&&(s2<=96)
                    %1-2
                    type = 2;
                elseif (s1>=25)&&(s1<=96)&&(s2<=24)
                    %2-1
                    type = 3;
                elseif (s1>=25)&&(s1<=96)&&(s2>=25)&&(s2<=96)
                    %2-2
                    type = 4;
                elseif (s1>=25)&&(s1<=96)&&(s2>=97)
                    %2-3
                    type = 5;
                elseif (s1>=96)&&(s2>=25)&&(s2<=96)
                    %3-2
                    type = 6;
                end
                H = (exp((- (p - obj.P(type)) ^ 2) / (2 * obj.engSig ^ 2)) - 0.5) * 2;
                if H >= 0
                    obj.cEng = obj.cEng + H * obj.reeng * (obj.maxEng - obj.cEng);
                else
                    obj.cEng = obj.cEng - H * obj.forget * (obj.minEng - obj.cEng);
                end
            else %action is not the optimal here....
                obj.cEng = obj.cEng + obj.forget * (obj.minEng - obj.cEng);
                %r = -10;
            end
            r = (1 - obj.lambdaRwd) * (obj.cEng - 5) / 5 + obj.lambdaRwd * 2 * (obj.cEng - oldEng); % mixed reward function
            
            obj.s = obj.T(obj.s, action);
            if obj.s == 118
                r = r+10;
            end
            % add reward based on parameter value...
            
            
        end
        
    end
end






%%

%         if (a.action == BBT.optimal(s))
%             %% gaussian child engagement
%             % probaEng is between -1 (disengagement) and 1 (reengagement)
%             % a.param is the continuous parameter executed by the robot
%             % BBT.engMu is the optimal parameter
%             probaEng = (exp((- (a.param - BBT.engMu(s)) ^ 2) / (2 * BBT.engSig ^ 2)) - 0.5) * 2;
%             if (probaEng >= 0)
%                 BBT.cENG = BBT.cENG + probaEng * BBT.reeng * (BBT.maxENG - BBT.cENG);
%                 %r = 1;
%             else
%                 BBT.cENG = BBT.cENG - probaEng * BBT.forget * (BBT.minENG - BBT.cENG);
%                 %r = 0;
%             end
%         else % the robot performed a non-optimal action
%             BBT.cENG = BBT.cENG + BBT.forget * (BBT.minENG - BBT.cENG);
%             %r = 0;
%         end
% %     else % other state than terminal state
% %         %r = 0;
% %     end
%     %% setting the reward as a function of the difference in engagement
%     %r = BBT.cENG - oldEng; % reward = variations in child engagement
%     %r = (BBT.cENG - 5) / 20; % reward = (child engagement - 5) / 5
%     r = (1 - BBT.lambdaRwd) * (BBT.cENG - 5) / 5 + BBT.lambdaRwd * 2 * (BBT.cENG - oldEng); % mixed reward function
%     %r = (1 - BBT.lambdaRwd) * BBT.cENG + BBT.lambdaRwd *(BBT.cENG - oldEng);
%
%

















