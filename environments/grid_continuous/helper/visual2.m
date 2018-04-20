function [ ] = visual2(env, si, sj)

figure(1);
cla;
CW = env.CW;
imagesc(CW); colormap(gray); ylim([0 10]); axis equal; hold on; %grid on;
set(gca, 'YLim', [0.5 size(env.Map,1)+0.5]);
set(gca, 'Xtick', 0.5:1:size(env.Map,2)+0.5);
set(gca, 'Ytick', 0.5:1:size(env.Map,1)+0.5);
plot(sj,si, 'wo', 'MarkerSize', 12, 'MarkerFaceColor', 'w', 'LineWidth', 2);
[gi,gj] = ind2sub(size(env.Map), env.Goal);
plot(gj, gi, 'yo', 'MarkerSize', 12, 'MarkerFaceColor', 'y', 'Linewidth', 2);
drawnow;


end

