function drawstate( obj )

figure(1);hold on; xlim([-10 10]); ylim([-10 10]); box on; cla; hold on; axis square;
set(gca,'color',[0.99 0.99 0.99]);
title(obj.time);

%% draw child
person = obj.child;
angle = person.head_angle;
pos = person.head_pos;
radius = person.head_radius;
color = person.head_color;
t = 0:0.01:2*pi;
x = cos(t);
y = sin(t);
w = 0.2;
d = radius/5;
%shoulders
patch(1.7*radius*x+pos(1), radius/1.3*y+pos(2), color);
%nose
patch([radius*cos(angle-w)+pos(1) radius*cos(angle+w)+pos(1) (radius+d)*cos(angle)+pos(1)],...
      [radius*sin(angle-w)+pos(2) radius*sin(angle+w)+pos(2) (radius+d)*sin(angle)+pos(2)], color);
%head
patch(radius*x+pos(1), radius*y+pos(2), color);


%% draw cubes
cube1 = obj.cube1;
cube2 = obj.cube2;
cube3 = obj.cube3;
cube4 = obj.cube4;

r = cube1.size;
p = cube1.pos;
color = cube1.color;
c(1,:) = p + [-r -r];
c(2,:) = p + [-r +r];
c(3,:) = p + [+r +r];
c(4,:) = p + [+r -r];
patch(c(:,1)', c(:,2)', color); 

r = cube2.size;
p = cube2.pos;
color = cube2.color;
c(1,:) = p + [-r -r];
c(2,:) = p + [-r +r];
c(3,:) = p + [+r +r];
c(4,:) = p + [+r -r];
patch(c(:,1)', c(:,2)', color); 

r = cube3.size;
p = cube3.pos;
color = cube3.color;
c(1,:) = p + [-r -r];
c(2,:) = p + [-r +r];
c(3,:) = p + [+r +r];
c(4,:) = p + [+r -r];
patch(c(:,1)', c(:,2)', color); 

r = cube4.size;
p = cube4.pos;
color = cube4.color;
c(1,:) = p + [-r -r];
c(2,:) = p + [-r +r];
c(3,:) = p + [+r +r];
c(4,:) = p + [+r -r];
patch(c(:,1)', c(:,2)', color); 


%% draw robot
person = obj.robot;
angle = person.head_angle;
headx = person.head_pos(1);
heady = person.head_pos(2);
headr = person.head_radius;
color = person.head_color;
t = 0:0.01:2*pi;
x = cos(t);
y = sin(t);
w = 0.2;
d = headr/5;
% torso;
patch(1.7*radius*x+headx, radius/1.6*y+heady, color);

l1 = person.bicep_length;
l2 = person.forearm_length;
l3 = person.fist_radius;
l23 = l2+l3;

% right arm
shoulderx = headx + 1.3*radius;
shouldery = heady;
xg = obj.robot.right_arm_pos(1);
yg = obj.robot.right_arm_pos(2);
x = xg-shoulderx;
y = yg-shouldery;
th2 = acos((x^2+y^2-l1^2-l23^2)/(2*l1*l23));
thq = acos((x^2+y^2+l1^2-l23^2)/(2*l1*sqrt(x^2+y^2)));
th1 = atan2(y,x) - thq;
x1 = shoulderx;
y1 = shouldery;
x2 = x1+l1*cos(th1);
y2 = y1+l1*sin(th1);
x3 = x2+l2*cos(th1+th2);
y3 = y2+l2*sin(th1+th2);
x4 = x3+l3*cos(th1+th2);
y4 = y3+l3*sin(th1+th2);
%bicep1
drawellipse(x1, x2, y1, y2, person.shoulder_radius, color);
%forearm
drawellipse(x2,x3, y2, y3, person.elbow_radius, color);
%elbow1
% drawcircle(x2,y2,armr1, color);
%fist
drawcircle(x4,y4,person.fist_radius, color);
%shoulder joint
drawcircle(x1,y1,1.3*person.shoulder_radius, color);





%left arm
shoulderx = headx - 1.3*radius;
shouldery = heady;
xg = obj.robot.left_arm_pos(1);
yg = obj.robot.left_arm_pos(2);
x = xg-shoulderx;
y = yg-shouldery;
th2 = -acos((x^2+y^2-l1^2-l23^2)/(2*l1*l23));
thq = acos((x^2+y^2+l1^2-l23^2)/(2*l1*sqrt(x^2+y^2)));
th1 = atan2(y,x) + thq;
x1 = shoulderx;
y1 = shouldery;
x2 = x1+l1*cos(th1);
y2 = y1+l1*sin(th1);
x3 = x2+l2*cos(th1+th2);
y3 = y2+l2*sin(th1+th2);
x4 = x3+l3*cos(th1+th2);
y4 = y3+l3*sin(th1+th2);
%bicep1
drawellipse(x1, x2, y1, y2, person.shoulder_radius, color);
%forearm
drawellipse(x2,x3, y2, y3, person.elbow_radius, color);
%elbow1
% drawcircle(x2,y2,armr1, color);
%fist
drawcircle(x4,y4,person.fist_radius, color);
%shoulder joint
drawcircle(x1,y1,1.3*person.shoulder_radius, color);



%nose
patch([headr*cos(angle-w)+headx headr*cos(angle+w)+headx (headr+d)*cos(angle)+headx],...
      [headr*sin(angle-w)+heady headr*sin(angle+w)+heady (headr+d)*sin(angle)+heady], color);
t = 0:0.1:2*pi;
x = cos(t); y = sin(t);
%head
patch(headr*x+headx, headr*y+heady, color); 








alpha(0.8);






drawnow;
end




































