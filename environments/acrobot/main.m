clear; close all; clc;

     %acrobot(m1, m2, l1, l2, m3, m4, theta1, theta2, friction)
bot = acrobot(1,  1,  1.2,  1,  0,  0,    pi/2,     pi/6,     0.1);
% bot.q = [-0.9941; 0.6917];
% bot.qd= [-1.9636; 12.2903];
% bot.state = [bot.q; bot.qd];

figure(1); pause(0.5);
S = [];

while true
%for i = 1:10000
%     if     bot.state(1)>-0.25 && bot.state(1)<0.25 && bot.state(3)>0
%         u = 3;
%         title('front');
%     elseif bot.state(1)>-0.25 && bot.state(1)<0.25 && bot.state(3)<0
%         u = -3;
%         title('back');
%     else
%         u = 0;
%         title('hold');
%     end
    u = 0.2;
    [bot] = bot.step(u);
    bot.show(bot.state);
    s = bot.state;
    S = [S s];
    if size(S,2)>10000;
        S = S(:, end-10000+1:end);
    end
end
close all;
%%
figure(2); box on; hold on;
xlim([-pi pi]); ylim([-pi pi]);
xlabel('\theta_1'); ylabel('\theta_2');
comet3(S(1,:), S(2,:),S(3,:));


%%
figure(2); box on; hold on;
%xlim([-pi pi]); ylim([-pi pi]);
%xlabel('\theta_1'); ylabel('\theta_2');
%comet3(S(1,:), S(2,:), S(3,:));
%plot3(S(1,:), S(2,:), S(3,:),'LineWidth', 0.5, 'Color', [0.7 0.7 0.7]);
[X,Y,Z] = tubeplot([S(1,:);S(2,:);S(3,:)],0.1, 8, 0.001);
[~,~,W] = tubeplot([S(2,:);S(3,:);S(4,:)],0.1, 8, 0.001);
%W = W(:,1:size(X,2));
surf(X,Y,Z,W);
colormap(jet);
%xlim([-pi pi]); ylim([-pi pi]);
box on;
camlight;
shading(gca,'interp')
lighting gourard; 
