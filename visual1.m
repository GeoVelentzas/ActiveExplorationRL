T = episodeLength;
global cpTime
b = [0.0    0.0   0.0;
     0.3    0.3   0.3;
     0.3    0.0   0.0;
     0.0    0.0   0.2;
     0.3    0.0   0.3;
     0.6    0.6   0.6];
      
close all;

%% first figure  - actions + total engagement%%
figure(1);
x = 1:size(OptimalActions,2);
X=[x,fliplr(x)];            
for i = 1:BBT.nS
    ax = subplot(3,2, i);
    %these lines are for the tolerance interval of the parameter
    for j = 1:BBT.nA
        y = OptimalActions(j,:,i);
        if sum(~isnan(y))~=0
          y1  = y-20;
            y2  = y+20;
            Y = [y1, fliplr(y2)];
            TT = X; TT(isnan(Y)) = nan;
            Y(isnan(Y)) = []; TT(isnan(TT)) = [];
            patch(TT,Y,b(j,:),'EdgeColor', 'none'); hold on; box on; alpha 0.1
            plot(TT(1:length(TT)/2),Y(1:length(Y)/2),  'Color', b(j,:), 'LineWidth', 1.2); 
            plot(TT(length(TT)/2+1:end),Y(length(Y)/2+1:end),  'Color', b(j,:), 'LineWidth', 1.2); 
        end
        %plot(OptimalActions(j,:,i)','-s', 'Color', b(j,:), 'MarkerSize', 10, 'MarkerFaceColor', b(j,:)); hold on;
    end
     for j = 1:BBT.nA
         pl(j) = plot(BBR.ActionsTaken(j,:,i)','o', 'Color', b(j,:), 'MarkerSize', 3,'MarkerFaceColor',b(j,:), 'DisplayName', ['a',num2str(j)]);
     end
     title(['State ', num2str(i)]);
    xlim([1 T]); ylim([-100 100]);
end
legend(pl, 'a1', 'a2', 'a3', 'a4', 'a5', 'a6');
subplot(3,2,6);
plot(engagement,'k.')
xlim([1 T]);
title('engagement');

%% second figure - exploration levels - sigmas - EXPERIMENT SPECIFIC FIGURE (NOT GERERAL)
cp = cpTime;
fig  = figure(2);
BS1 = betas2(1,:);
AS1 = BBR.ActionsTaken(:,:,1);
S1 = sigmas2(:,:,1);
S1 = S1(:, cp:end);
AS1 = AS1(:, cp:end);
BS1 = BS1(cp:end);
SV = StatesVisited(cp:end);
S1 = S1(:, SV==1);
AS1 = AS1(:, SV==1);
BS1 = BS1(SV==1);
maxindex = 80;
S1 = S1(:, 1:maxindex);
AS1 = AS1(:,1:maxindex);
BS1 = BS1(1:maxindex);
h1 = axes;
h = ribbon(S1'); colormap(b); hold on;
set(h1, 'Ydir', 'reverse')
shading interp

len = length(AS1(i,:));
mnB = min(BS1)-0.1; 
mxB = max(BS1)+0.1;
for i = 1:BBT.nA
    scatter(i*ones(1, length(find(~isnan(AS1(i,:))))) , find(~isnan(AS1(i,:))),20, b(i,:), 'o', 'filled'); grid off;
    ylim([0 , len]); xlim([0 7]); zlim([0 40]);
    plot([0.5+(i-1),0.5+(i-1)], [0 len], '--', 'Color', [0.7 0.7 0.7])
end
plot([0.5+(i),0.5+(i)], [0 len], '--', 'Color', [0.7 0.7 0.7])
plot3([7,7], [0 len], [0 0],'k')
plot3([0 7], [0 0] , [0 0], 'k')
plot3([7 7], [0 len],[40 40], 'k') 
plot3([7 7], [len len],[0 40], 'k') 
plot3([7 7], [0 0],[0 40], 'k')
plot3([0 7], [0 0],[40 40], 'k')

plot3([0 0], [len len],[0 40], 'Color', [0.5 0.5 0.5])
plot3([0 0], [0 len],[40 40], 'Color', [0.5 0.5 0.5])
plot3([0 7], [len len],[40 40], 'Color', [0.5 0.5 0.5])


plot3(7*ones(1, length(BS1)), 1:len, (BS1-mnB)/(mxB-mnB)*40, 'k-.', 'LineWidth', 2 );
alpha(1.0)


%% Beta exploration levels
figure(3);
for i = 1: BBT.nS
    subplot(3,2,i)
    plot(betas2(i,:)','k-','LineWidth', 2);
    xlim([0 T]);ylim([min(betas2(i,:))-0.2 max(betas2(i,:))+0.2]);
    title(['State ', num2str(i)])
end
%%
x = 1:BBT.nS;
y = cpTime-100:cpTime+1000;
[X,Y] = meshgrid(x, y);
Z = betas2(:,y)';
% ribbon(x,y,z)
ribboncoloredZ(Y,Z);
h2 = gca;
set(h2, 'Xdir', 'reverse')
shading interp
lighting 'gouraud'; box on;
c = jet;
colormap(flipud(c))
%%
figure;
c = gray;
% c(64:end,:) = [];
imagesc((1./Z)'); colormap(c); hold on; colorbar
plot([1 1100],[1.5 1.5], 'k-', 'LineWidth', 0.5)
plot([1 1100],[2.5 2.5], 'k-', 'LineWidth', 0.5)
plot([1 1100],[3.5 3.5], 'k-', 'LineWidth', 0.5)
plot([1 1100],[4.5 4.5], 'k-', 'LineWidth', 0.5)
plot([100 100],[0.5 5.5], 'k--', 'LineWidth', 2)
title('Temperature T=1/\beta')
%%
figure;
for i = 1:BBT.nS
    subplot(3,2,i);
    SS = BBR.PV(i,:);
    SSv = SS(StatesVisited==i*BBR.Hits==1);
    A = SSv; 
    B = SSv;
    A(A<=0) = nan;
    B(B>0) = nan;
    plot(A,'k.');hold on;
    plot(B, 'r.');
    title(['H(t) in State ',num2str(i)]);
end














