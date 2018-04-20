classdef environment
    properties
        Map; S; CW; Goal; Li, Lj, dt; interpolate_motion; visualize; goalr, stepr, hitr;
    end
    
    methods
        function obj = environment(file, v1, v2)
            M = dlmread(file);
            obj.S  = size(M, 1);
            obj.Goal = size(M,1)*(size(M, 2)-1)+1;
            obj.Map = (M==1);
            obj.Li = size(obj.Map, 1);
            obj.Lj = size(obj.Map, 2);
            obj.dt = 0.01;
            obj.interpolate_motion = v2;
            obj.visualize = v1;
            
            obj.goalr = 10;
            obj.stepr = -0.1;
            obj.hitr = -0.2;
            
            obj.CW = zeros(size(obj.Map,1), size(obj.Map,2),3);
            obj.CW(:,:,1) = 0*imcomplement(obj.Map);
            obj.CW(:,:,2) = imcomplement(obj.Map);
            obj.CW(:,:,3) = 0*imcomplement(obj.Map);
            %obj.CW = imcomplement(obj.CW);
        end
        
        function [obj,r] = step(obj, action, p)
            [si,sj] = ind2sub(size(obj.Map), obj.S);
            switch action
                                    
                case 1
                    stopped = ~abs(sign(p));
                    pj = sj;
                    pc = p;
                    r = obj.stepr;
                    while ~stopped
                        if (sj + sign(p) > obj.Lj) ||(sj + sign(p) < 1)
                            p = -p;
                            r = r+obj.hitr;
                        elseif ~obj.Map(si, sj+sign(p))
                            sj = sj + sign(p);
                            if obj.interpolate_motion
                                step = 0.1;
                                while abs(pj-sj)>0.1
                                    pj = pj + step*sign(sj-pj);
                                    visual2(obj, si, pj);
                                    step = (1-10^(-(abs(p))))*step;
                                end
                            end
                            p = p-sign(p);
                        elseif obj.Map(si, sj+sign(p))
                            pc = 0.9*pc;
                            p = -round(pc);
                            r = r+obj.hitr;
                        end
                        if obj.visualize;  visual2(obj, si, sj); end
                        stopped = ~abs(sign(p));
                        obj.S = sub2ind(size(obj.Map), si, sj);
                        r = r + (obj.S == obj.Goal)*obj.goalr;
                    end
                    
                case 2
                    stopped = ~abs(sign(p));
                    pj = sj;
                    p = -p;
                    pc = p;
                    r = obj.stepr;
                    while ~stopped
                        if (sj + sign(p) > obj.Lj) ||(sj + sign(p) < 1)
                            p = -p;
                            r = r+obj.hitr;
                        elseif ~obj.Map(si, sj+sign(p))
                            sj = sj + sign(p);
                            if obj.interpolate_motion
                                step = 0.1;
                                while abs(pj-sj)>0.1
                                    pj = pj + step*sign(sj-pj);
                                    visual2(obj, si, pj);
                                    step = (1-10^(-(abs(p))))*step;
                                end
                            end
                            p = p-sign(p);
                        elseif obj.Map(si, sj+sign(p))
                            pc = 0.9*pc;
                            p = -round(pc);
                            r = r+obj.hitr;
                        end
                        if obj.visualize;  visual2(obj, si, sj); end
                        stopped = ~abs(sign(p));
                        obj.S = sub2ind(size(obj.Map), si, sj);
                        r = r + (obj.S == obj.Goal)*obj.goalr;
                    end
                    
                case 3
                    stopped = ~abs(sign(p));
                    pi = si;
                    p = -p;
                    pc = p;
                    r = obj.stepr;
                    while ~stopped
                        if (si + sign(p) > obj.Lj) ||(si + sign(p) < 1)
                            p = -p;
                            r = r+obj.hitr;
                        elseif ~obj.Map(si+sign(p), sj)
                            si = si + sign(p);
                            if obj.interpolate_motion
                                step = 0.1;
                                while abs(pi-si)>0.1
                                    pi = pi + step*sign(si-pi);
                                    visual2(obj, pi, sj);
                                    step = (1-10^(-(abs(p))))*step;
                                end
                            end
                            p = p-sign(p);
                        elseif obj.Map(si+sign(p), sj)
                            pc = 0.9*pc;
                            p = -round(pc);
                            r = r+obj.hitr;
                        end
                        if obj.visualize;  visual2(obj, si, sj); end
                        stopped = ~abs(sign(p));
                        obj.S = sub2ind(size(obj.Map), si, sj);
                        r = r + (obj.S == obj.Goal)*obj.goalr;
                    end
                    
                    
                case 4
                    stopped = ~abs(sign(p));
                    pi = si;
                    pc = p;
                    r = obj.stepr;
                    while ~stopped
                        if (si + sign(p) > obj.Lj) ||(si + sign(p) < 1)
                            p = -p;
                            r = r+obj.hitr;
                        elseif ~obj.Map(si+sign(p), sj)
                            si = si + sign(p);
                            if obj.interpolate_motion
                                step = 0.1;
                                while abs(pi-si)>0.1
                                    pi = pi + step*sign(si-pi);
                                    visual2(obj, pi, sj);
                                    step = (1-10^(-(abs(p))))*step;
                                end
                            end
                            p = p-sign(p);
                        elseif obj.Map(si+sign(p), sj)
                            pc = 0.9*pc;
                            p = -round(pc);
                            r = r+obj.hitr;
                        end
                        if obj.visualize;  visual2(obj, si, sj); end
                        stopped = ~abs(sign(p));
                        obj.S = sub2ind(size(obj.Map), si, sj);
                        r = r + (obj.S == obj.Goal)*obj.goalr;
                    end
                    
                    
            end
            
        end
        
    end
end


















