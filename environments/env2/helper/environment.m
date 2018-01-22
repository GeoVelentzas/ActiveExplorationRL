classdef environment
    properties
        T; s; sp;
    end
    
    methods
        function obj = environment(T)
            obj.s = 1;
            obj.sp = 1;
            obj.T = T;
        end
        
        function obj = step(obj, action)
            obj.s = obj.T(obj.s,action);
        end
            
    end
end