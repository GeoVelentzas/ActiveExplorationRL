function drawstate( obj )

figure(1);
%subplot(3,10,[1:5, 11:15, 21:25]);
hold on; xlim([-9 9]); ylim([-9.5 8.5]); box on; cla; hold on; axis square;
% set(gca,'color',[0.99 0.99 0.99]);
set(gca,'color', [0.1 0.1 0.2]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);


%% draw positions
px1 = obj.map.pos1(1); py1 = obj.map.pos1(2); c1=[0.50 0.50 0.50]; r1=0.7;
px2 = obj.map.pos2(1); py2 = obj.map.pos2(2); c2=[0.50 0.50 0.50]; r2=0.7;
px3 = obj.map.pos3(1); py3 = obj.map.pos3(2); c3=[0.50 0.50 0.50]; r3=0.7;

drawcircle(px1,py1,r1,c1,false);
drawcircle(px3,py3,r3,c3,false);
drawcircle(px2,py2,r2,c2,false);

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
for i=obj.map.layer1
    if i==1
        drawcube(obj.cube1);
    elseif i==2
        drawcube(obj.cube2);
    elseif i==3
        drawcube(obj.cube3);
    end
end

for i = obj.map.layer2
    if i==1
        drawcube(obj.cube1);
    elseif i==2
        drawcube(obj.cube2);
    elseif i==3
        drawcube(obj.cube3);
    end
end

for i = obj.map.layer3
    if i==1
        drawcube(obj.cube1);
    elseif i==2
        drawcube(obj.cube2);
    elseif i==3
        drawcube(obj.cube3);
    end
end


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




































