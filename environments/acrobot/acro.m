clear; close all;clc;
m1 = 1; 
m2 = 1;
l1 = 1;
l2 = 1;
lc1 = 0.5; 
lc2 = 0.5;
g = 9.81;
theta1 = 0;
theta2 = pi/4;
I1 = m1*lc1^2;
I2 = m2*lc2^2;
q  = [theta1; theta2];
qd = [0; 0];
dt = 0.01;
Q = [];
QD = [];
figure(1);
xlim([-3 3]); ylim([-3 3]);
pause(1);

for i = 1:1000
    s1 = sin(q(1));
    s2 = sin(q(2));
    c1 = cos(q(1));
    c2 = cos(q(2));
    s12 = sin(q(1) + q(2));
    c12 = cos(q(1) + q(2));
    
    H = [I1+I2+m2*l1^2+2*m2*l1*lc2*c2 , I2+m2*l1*lc2*c2;
        I2+m2*l1*lc2*c2              , I2             ];
        
    C = [-2*m2*l1*lc2*s2*qd(2)        , -m2*l1*lc2*s2*qd(2);
         m2*l1*lc2*s2*qd(1)           ,          0     ];
    
    G = [(m1*lc1+m2*l1)*g*s1 + m2*g*l2*s12;
                  m2*g*l2*s12            ];
    
    B = [0; 1];
    u = 0;
    F = qd.*[-1;-0.01];
    
    qdd = H\(-C*qd - G + B*u +F);
    q = q + qd*dt + 1/2*qdd*dt^2;
    qd = qd + qdd*dt;
    q(1) = atan2(sin(q(1)), cos(q(1)));
    q(2) = atan2(sin(q(2)), cos(q(2)));
    Q = [Q q];
    QD = [QD qd];
    
    %plot link1;
    px0 = 0;
    py0 = 0;
    px1 = l1*sin(q(1));
    py1 =-l1*cos(q(1));

    px2 = px1 + l2*sin(q(1) + q(2));
    py2 = py1 - l2*cos(q(1) + q(2));
    cla;
    plot([px0, px1], [py0, py1], 'k', 'LineWidth', 2);hold on;
    plot([px1, px2], [py1, py2], 'r', 'LineWidth', 2);hold on;
    xlim([-3 3]); ylim([-3 3]);
    drawnow;
    
end


% for i=1:size(Q,2);
%     q = Q(:,i);
%     qd = QD(:,i);
%     px0 = 0;
%     py0 = 0;
%     px1 = l1*sin(q(1));
%     py1 =-l1*cos(q(1));
%     px2 = px1 + l2*sin(q(1) + q(2));
%     py2 = py1 - l2*cos(q(1) + q(2));
%     cla;
%     plot([px0, px1], [py0, py1], 'k', 'LineWidth', 2);hold on;
%     plot([px1, px2], [py1, py2], 'r', 'LineWidth', 2);hold on;
%     xlim([-3 3]); ylim([-3 3]);
%     drawnow;
% 
% end




























             