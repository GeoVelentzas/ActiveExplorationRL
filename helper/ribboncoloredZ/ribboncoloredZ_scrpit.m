%% 
% builtin ribbon() function colors ribbons according to X values

[x,y] = meshgrid(-3:.5:3,-3:.1:3);
z = peaks(x,y);

h = ribbon(y,z)
xlabel('X');ylabel('Y');zlabel('Z');
%% 
% ribboncoloredZ colors ribbons according to Z values

figure
h2 = ribboncoloredZ(y,z)
xlabel('X');ylabel('Y');zlabel('Z');

%% 
% Change colors by using colormap()

colormap('hot')