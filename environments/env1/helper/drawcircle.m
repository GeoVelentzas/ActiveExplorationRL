function drawcircle( px,py,r,c )

t = 0:0.01:2*pi;
x = r*cos(t);
y = r*sin(t);
patch(x+px,y+py,c);

end

