classdef acrobot
    properties
        q; qd; H; C; G; m1; m2; l1; l2; m3, m4; lc1; lc2; I1; I2; g; dt; friction; state;
    end
    
    methods
        function obj = acrobot(m1, m2, l1, l2, m3, m4, theta1, theta2, friction)
            obj.m1 = m1 + m3; %link+motor;
            obj.m2 = m2 + m4; %link+end effector;
            obj.l1 = l1;
            obj.l2 = l2;
            obj.m3 = m3; %motor weight;
            obj.m4 = m4; %end effector weight;
            obj.lc1 = 1/2*l1;
            obj.lc2 = 1/2*l2;
            obj.I1 = 1/3*m1*l1^2 + m3*l1^2;
            obj.I2 = 1/3*m2*l2^2 + m4*l2^2; 
            obj.g = 9.81;
            obj.dt = 0.02;
            obj.q = [theta1; theta2];
            obj.qd = [0; 0];
            obj.state = [obj.q;  obj.qd];
            obj.friction = friction;
            
        end
        
        function [obj,S,t] = step(obj, u) %or try two params per action...
%             Opt    = odeset('Events', @Constraint);
            x0 = obj.state;
            tspan = [0 obj.dt];
            [t,x] = ode45(@(t,x) doublependulum(t,x,u,obj), tspan, x0);
            S = x';
%             val = Constraint(t(end), x(end,:)');
%             if val>0 && x(end,2)>0
%                 x(end,4) = -1*x(end,4);
%                 x(end,2) = pi - 0.06;
%             elseif val>0&&x(end,2)<0
%                 x(end,4) = -1*x(end,4);
%                 x(end,2) = -pi + 0.06;
%             end
            obj.state = x(end,:);
            obj.state = obj.state(:);
            obj.state(1) = atan2(sin(obj.state(1)), cos(obj.state(1)));
            obj.state(2) = atan2(sin(obj.state(2)), cos(obj.state(2)));
            obj.q(1)  = obj.state(1);
            obj.q(2)  = obj.state(2);
            obj.qd(1) = obj.state(3);
            obj.qd(2) = obj.state(4);
            
        end
        
        
        function show(obj,s)
            figure(1);
            cla;
            q(1) = s(1);
            q(2) = s(2);
            px0 = 0;
            py0 = 0;
            px1 = obj.l1*sin(q(1));
            py1 =-obj.l1*cos(q(1));
            
            px2 = px1 + obj.l2*sin(q(1) + q(2));
            py2 = py1 - obj.l2*cos(q(1) + q(2));
            cla;
            plot([px0, px1], [py0, py1], 'k', 'LineWidth', 2);hold on;
            plot([px1, px2], [py1, py2], 'k', 'LineWidth', 2);hold on;
            xlim([-3 3]); ylim([-3 3]);
            plot(px1,py1,'ko', 'LineWidth', 2, 'MarkerFaceColor', 'k');
            plot(px2,py2,'ko', 'LineWidth', 2, 'MarkerFaceColor', 'k');
            plot(px0,py0,'ko', 'LineWidth', 1, 'MarkerFaceColor', 'w');
            drawnow;
        end
        
                
    end
end


















