clear; close all; clc;

     %acrobot(m1, m2, l1, l2, m3, m4, theta1, theta2, friction)
bot = acrobot(1,  1,  1,  1,  0,  1,  pi/2,    0,     0.2);
figure(1); pause(0.5);

for i = 1:1000
    bot = bot.step(0);
    bot.show();
end
close all;