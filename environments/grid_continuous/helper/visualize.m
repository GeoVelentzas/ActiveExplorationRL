function [ ] = visualize(env)


CW = zeros(size(env.Map,1), size(env.Map,2),3);
CW(:,:,1) = env.Map;
CW(:,:,2) = env.Map;
CW(:,:,3) = env.Map;
[i,j] = ind2sub(size(env.Map), env.S);
CW(i,j,1) = 1; CW(i,j,2) = 1; 
[i,j] = ind2sub(size(env.Map), env.Goal);
CW(i,j,3) = 1;
CW = imcomplement(CW);

imagesc(CW); colormap(gray); ylim([0 10]); axis equal;
set(gca, 'YLim', [0.5 size(env.Map,1)+0.5]);
set(gca, 'Xtick', 0.5:1:size(env.Map,2)+0.5);
set(gca, 'Ytick', 0.5:1:size(env.Map,1)+0.5);
grid on;
drawnow;


end

