function drawcube(cube)
r = cube.size;
p = cube.pos;
color = cube.color;
c(1,:) = p + [-r -r];
c(2,:) = p + [-r +r];
c(3,:) = p + [+r +r];
c(4,:) = p + [+r -r];
patch(c(:,1)', c(:,2)', color); 


end