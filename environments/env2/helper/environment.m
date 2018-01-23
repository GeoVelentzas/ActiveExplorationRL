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
            obj.O = O;
        end
        
        function [obj,r] = step(obj, action, p) %two params per action...
            if obj.O(obj.s,action)
                r = 1;
            else
                r = -10;
            end
            obj.s = obj.T(obj.s, action);
            if obj.s == 118
                r = 10;
            end
        end
            
    end
end