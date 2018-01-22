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
        
        function obj = step(obj, action, params)
            if action~=7
                obj.s = obj.T(obj.s, action);
                obj.r = randn;
                if obj.s>=97
                    obj.r = 10;
                end
            end
        end
            
    end
end