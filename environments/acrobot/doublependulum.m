function xdot = doublependulum(t,x,u,obj)

x(1) = atan2(sin(x(1)), cos(x(1)));
x(2) = atan2(sin(x(2)), cos(x(2)));

c1 = cos(x(1));
c2 = cos(x(2));
s1 = sin(x(1));
s2 = sin(x(2));
c12 = cos(x(1) + x(2));
s12 = sin(x(1) + x(2));

H = [obj.I1+obj.I2+obj.m2*obj.l1^2+2*obj.m2*obj.l1*obj.lc2*c2 , obj.I2+obj.m2*obj.l1*obj.lc2*c2;
    obj.I2+obj.m2*obj.l1*obj.lc2*c2              , obj.I2             ];

C = [-2*obj.m2*obj.l1*obj.lc2*s2*x(4)        , -obj.m2*obj.l1*obj.lc2*s2*x(4);
    obj.m2*obj.l1*obj.lc2*s2*x(3)           ,          0     ];

G = [(obj.m1*obj.lc1+obj.m2*obj.l1)*obj.g*s1 + obj.m2*obj.g*obj.l2*s12;
    obj.m2*obj.g*obj.l2*s12            ];

B = [0; 1];

F = x(3:4).*[-1;-0.5]*obj.friction;

qdd = H\(-C*x(3:4) - G + B*u +F);

xdot(1) = x(3);
xdot(2) = x(4);
xdot(3) = qdd(1);
xdot(4) = qdd(2);
xdot = xdot(:);


end
















