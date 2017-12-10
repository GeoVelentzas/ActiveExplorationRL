function visualizeHyperSessions( Hsess )
%input: struct output from RunHyperSessions(number, task) 

% helper variables
b = [0.0    0.0   0.0;              %color of action 1
     0.3    0.3   0.3;              %color of action 2
     0.3    0.0   0.0;              %color of action 3
     0.0    0.0   0.2;              %color of action 4
     0.3    0.0   0.3;              %color of action 5
     0.6    0.6   0.6];             %color of action 6
%b = colormap(lines(8));
T =  size(Hsess.Engagement,2);      %size of timesteps
nexp = Hsess.nHyper;                %numbers of experiments
for action = 1:6
    n{action} = action:6:nexp*6;                                                %indexes for each action 
    Actions{action} = Hsess.ActionsTaken(n{action}, :, :);                      %Actions{a}: (nAxnexp)xTxnS 
    Sigmas{action} = Hsess.Sigmas(n{action}, :,:);                              %Sigmas{a}:  (nAxnexp)xTxnS
    Metaparams{action} = Hsess.Metaparams(n{action}, :, :);                     %Metaparams{a}: (nAxnexp)xTxnS
    Qvalues{action} = Hsess.Qvalues(n{action}, :, :);                           %Qvalues{a}: (nAxnexp)xTxnS
    ExpectedActionParams{action} = Hsess.ExpectedActionParams(n{action},:,:);   %ExpActPar{a}: (nAxnexp)xTxnS
    OptimalActions{action} = Hsess.OptimalActions(n{action}, :, :);             %OptAct{a}: (nAxnexp)xTxnS
end
for state = 1:5                                                                 
    m{state} = state:5:nexp*5;                                                  %indexes for each state
    Betas{state} = Hsess.Betas(m{state}, :);                                    %Betas{s}: nexpxT
    H{state} = Hsess.H(m{state}, :);
end

%% actions taken - optimal actions - means of thetas + 3sigmas
figure(1); suptitle('actions - optimal actions');
for state = 1:5
    subplot(5,2,state*2-1);
    for action = 1:6
        plot(Actions{action}(:,:,state)', '.', 'Color', b(action,:), 'MarkerSize', 1); hold on; box on;
%         title(['actions in state ', num2str(state)]); xlabel('timesteps');
        xlim([0 T]); ylim([-100 100]);
    end
end
for state = 1:5
    subplot(5,2,state*2);
    for action = 1:6
        TT = ones(nexp,1)*(1:T);
        YY = OptimalActions{action}(:,:,state);
        TT(isnan(YY))= [];
        YY(isnan(YY))= [];
        t = [TT fliplr(TT)];
        y = [YY-12 fliplr(YY+12)];
%         plot(TT, YY+12, '--', 'Color', b(action, :), 'MarkerSize', 5); hold on; box on;
%         plot(TT, YY-12, '--', 'Color', b(action, :), 'MarkerSize', 5); hold on; box on;
        fill(t,y, b(action,:), 'EdgeColor', 'None'); hold on; box on; alpha(0.5);
%         title(['optimal actions in state ', num2str(state)]);  xlabel('timesteps')
        xlim([0 T]); ylim([-100 100]);
    end
end
for state=1:5
    subplot(5,2,state*2);
    for action=1:6
        M = nanmean(ExpectedActionParams{action}(:,:,state),1);
        S = nanmean(Sigmas{action}(:,:,state),1);
        m1 = nanmean(OptimalActions{action}(:,:,state), 1);
        mask = (m1+pi)./(m1+pi);
%         plot(M.*mask, '.', 'Color', b(action,:), 'MarkerSize', 3); hold on; box on;
        plot((M+3*S).*mask, '.', 'Color', b(action,:), 'MarkerSize', 4); hold on; box on;
        plot((M-3*S).*mask, '.', 'Color', b(action,:), 'MarkerSize', 4); hold on; box on;
%         tile(['average chosen parameter at state', num2str(state)]);
        xlim([0 T]); ylim([-100 100]);
    end
end
drawnow;
%% engagement - probabilities
figure(2);
q1 = quantile(Hsess.Engagement, 0.25);
q2 = quantile(Hsess.Engagement, 0.5);
q3 = quantile(Hsess.Engagement, 0.75);

% engagement
subplot(2,1,1); 
plot(q2, 'k'); hold on; box on;
t = 1:T;
x = [t fliplr(t)];
y = [q1 fliplr(q3)];
fill(x, y, 'k', 'EdgeColor', 'None'); alpha(0.5);
title('engagement');
xlim([0 T]); ylim([0 10]);

%probabilities
subplot(2,1,2); 
phit = mean(Hsess.Hits, 1);
plot(smooth(phit), 'k'); hold on; box on;
pdhit = mean(Hsess.DHits, 1);
plot(smooth(pdhit), 'r')
title('probabilities');
xlim([0 T]); ylim([0 1]);
drawnow;
%% sigmas - betas
figure(3); suptitle('sigmas - betas');
for state=1:5
    subplot(5,2,state*2-1);
    for action=1:6
        q1 = quantile(Sigmas{action}(:,:,state), 0.25);
        q2 = quantile(Sigmas{action}(:,:,state), 0.5);
        q3 = quantile(Sigmas{action}(:,:,state), 0.75);
        plot(q2, '-', 'Color', b(action,:), 'LineWidth', 1); hold on; box on;
        t = 1:T; x = [t fliplr(t)]; y = [q1 fliplr(q3)];
        fill(x,y,b(action,:), 'EdgeColor', b(action,:)); alpha(0.4);
        xlim([0 T]);
    end
    subplot(5,2,state*2);
    q1 = quantile(Betas{state}, 0.25);
    q2 = quantile(Betas{state}, 0.5);
    q3 = quantile(Betas{state}, 0.75);
    plot(q2, 'k-', 'LineWidth', 1); hold on; box on;
    t = 1:T; x = [t fliplr(t)]; y = [q1 fliplr(q3)];
    fill(x,y, 'k', 'EdgeColor', 'k'); alpha(0.4); 
    xlim([0 T]);
end
drawnow;
%% metaparams - q-values
% figure(4); suptitle('metaparams-qvalues');
% for state=1:5
%     subplot(5,2,state*2-1);
%     for action=1:6
%         q1 = quantile(Metaparams{action}(:,:,state), 0.25);
%         q2 = quantile(Metaparams{action}(:,:,state), 0.5);
%         q3 = quantile(Metaparams{action}(:,:,state), 0.75);
%         plot(q2, '-', 'Color', b(action,:), 'LineWidth', 1); hold on; box on;
%         t = 1:T; x = [t fliplr(t)]; y = [q1 fliplr(q3)];
%         fill(x,y,b(action,:), 'EdgeColor', b(action,:)); alpha(0.4);
%         xlim([0 T]);
%     end
%     subplot(5,2,state*2);
%     for action=1:6
%         q1 = quantile(Qvalues{action}(:,:,state), 0.25);
%         q2 = quantile(Qvalues{action}(:,:,state), 0.5);
%         q3 = quantile(Qvalues{action}(:,:,state), 0.75);
%         plot(q2, '-', 'Color', b(action,:), 'LineWidth', 1); hold on; box on;
%         t = 1:T; x = [t fliplr(t)]; y = [q1 fliplr(q3)];
%         fill(x,y,b(action,:), 'EdgeColor', b(action,:)); alpha(0.4);
%         xlim([0 T]);
%     end
% end
%%
% figure(5);
% for state=1:5
%     subplot(3,2,state);
%     plot(H{state}', '.', 'MarkerSize', 1); hold on; box on;
%     xlim([0 T]);
% end

%% cube: Sigmas - Actions - Beta (for one session)

state = 4; experiment = 1; interval = 4990:5500;
S = []; 
A = [];
B = Betas{state}(experiment,:);
for action = 1:6
    S = [S; Sigmas{action}(experiment,interval,state)];
    A = [A; Actions{action}(experiment,interval,state)];
end
S = S(:,Hsess.StatesVisited(experiment,interval)==state);
A = A(:,Hsess.StatesVisited(experiment,interval)==state);
B = B(:,Hsess.StatesVisited(experiment,interval)==state);
figure;
h1 = axes;

h = ribbon(S'); colormap(b); hold on; grid off; box on;
set(h1, 'Ydir', 'reverse')
shading interp

len = size(S,2);
ylim([0 len]); xlim([0 7]); zlim([0 40]);
for action = 1:6
plot([0.5+(action),0.5+(action)], [0 len], '--', 'Color', [0.7 0.7 0.7])
plot3([7,7], [0 len], [0 0],'k')
plot3([0 7], [0 0] , [0 0], 'k')
    scatter(action*ones(1,length(find(~isnan(A(action,:))))), find(~isnan(A(action,:))), 15, b(action,:), 'o', 'filled');
    plot([0.5+(action-1),0.5+(action-1)], [0 len], '--', 'Color', [0.7 0.7 0.7])
end
plot3([7 7], [0 len],[40 40], 'k') 
plot3([7 7], [len len],[0 40], 'k') 
plot3([7 7], [0 0],[0 40], 'k')
plot3([0 7], [0 0],[40 40], 'k')
plot3([0 0], [len len],[0 40], 'Color', [0.5 0.5 0.5])
plot3([0 0], [0 len],[40 40], 'Color', [0.5 0.5 0.5])
plot3([0 7], [len len],[40 40], 'Color', [0.5 0.5 0.5])

mnB = min(B);
mxB = max(B);
plot3(7*ones(1, length(B)), 1:len, (B-mnB)/(mxB-mnB)*40, 'k-.', 'LineWidth', 2 );
alpha(1.0)



















