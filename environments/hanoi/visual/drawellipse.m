function drawellipse(x1, x2, y1, y2, armr1, color)

t = 0:0.1:2*pi;
d = sqrt((x2-x1)^2+(y2-y1)^2);
x = sqrt(d)*cos(t);
y = armr1*sin(t);
th = atan2(y2-y1, x2-x1);
R = [cos(th) -sin(th); sin(th) cos(th)];
An = R*[x;y];
mx = (x1+x2)/2;
my = (y1+y2)/2;
Anm = An + [mx;my]*ones(1,length(t));
xn = Anm(1,:);
yn = Anm(2,:);
patch(xn, yn, color);




end

