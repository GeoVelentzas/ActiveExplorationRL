function [value, isterminal, direction] = Constraint(t, x)
value      = sign((((x(2) > pi-0.05) && (x(4)>0))||((x(2)<-pi+0.05)&&(x(4)<0))) -0.5);
isterminal = 1;   % Stop the integration
direction  = 0;
end