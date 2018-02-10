classdef acrobot
    properties
        q; qd; H; C; G; m1; m2; l1; l2; m3, m4; lc1; lc2; I1; I2; g; dt; friction
    end
    
    methods
        function obj = acrobot(m1, m2, l1, l2, m3, m4, theta1, theta2, friction)
            obj.m1 = m1 + m3; %link+motor;
            obj.m2 = m2 + m4; %link+end effector;
            obj.l1 = l1;
            obj.l2 = l2;
            obj.m3 = m3; %motor weight;
            obj.m4 = m4; %end effector weight;
            obj.lc1 = (1/2*l1*m1 + l1*m3)/(m1+m3);
            obj.lc2 = (1/2*l2*m2 + l2*m4)/(m2+m4);
            obj.I1 = obj.m1*obj.lc1^2;
            obj.I2 = obj.m2*obj.lc2^2;
            obj.g = 9.81;
            obj.dt = 0.01;
            obj.q = [theta1; theta2];
            obj.qd = [0; 0];
            obj.friction = friction;
            
        end
        
        function obj = step(obj, u) %or try two params per action...
            c1 = cos(obj.q(1));
            c2 = cos(obj.q(2));
            s1 = sin(obj.q(1));
            s2 = sin(obj.q(2));
            c12 = cos(obj.q(1) + obj.q(2));
            s12 = sin(obj.q(1) + obj.q(2));
            
            H = [obj.I1+obj.I2+obj.m2*obj.l1^2+2*obj.m2*obj.l1*obj.lc2*c2 , obj.I2+obj.m2*obj.l1*obj.lc2*c2;
                obj.I2+obj.m2*obj.l1*obj.lc2*c2              , obj.I2             ];
            
            C = [-2*obj.m2*obj.l1*obj.lc2*s2*obj.qd(2)        , -obj.m2*obj.l1*obj.lc2*s2*obj.qd(2);
                obj.m2*obj.l1*obj.lc2*s2*obj.qd(1)           ,          0     ];
            
            G = [(obj.m1*obj.lc1+obj.m2*obj.l1)*obj.g*s1 + obj.m2*obj.g*obj.l2*s12;
                obj.m2*obj.g*obj.l2*s12            ];
            
            B = [0; 1];
            
            F = obj.qd.*[-1;-0.1]*obj.friction;
            
            qdd = H\(-C*obj.qd - G + B*u +F);
            
            obj.q = obj.q + obj.qd*obj.dt + 1/2*qdd*obj.dt^2;
            obj.qd = obj.qd + qdd*obj.dt;
            
            obj.q(1) = atan2(sin(obj.q(1)), cos(obj.q(1)));
            obj.q(2) = atan2(sin(obj.q(2)), cos(obj.q(2)));
            
            
        end
        
        
        function show(obj)
            figure(1);
            cla;
            px0 = 0;
            py0 = 0;
            px1 = obj.l1*sin(obj.q(1));
            py1 =-obj.l1*cos(obj.q(1));
            
            px2 = px1 + obj.l2*sin(obj.q(1) + obj.q(2));
            py2 = py1 - obj.l2*cos(obj.q(1) + obj.q(2));
            cla;
            plot([px0, px1], [py0, py1], 'k', 'LineWidth', 2);hold on;
            plot([px1, px2], [py1, py2], 'r', 'LineWidth', 2);hold on;
            xlim([-3 3]); ylim([-3 3]);
            drawnow;
        end
        
    end
end


















