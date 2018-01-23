classdef environment
    properties
        %T: Transition Matrix
        %O: Optimal Actions-Params
        T; O; s; sp; r;
    end
    
    methods
        function obj = environment(T,O)
            obj.s = 1;
            obj.sp = 1;
            obj.T = T;
        end
        
        function [obj,r] = step(obj, action, p) %two params per action...
            if (obj.s==1)&&(action==1)
                r = 10;
            elseif (obj.s==41)&&(action==4)
                r = 10;
            else
                r = 0;
            end
            obj.s = obj.T(obj.s, action);
        end
            
    end
end