function visualizeHyperSessions( Hsess )
%input: struct output from RunHyperSessions(number, task) 

%% helper variables
b = [0.0    0.0   0.0;              %color of action 1
     0.3    0.3   0.3;              %color of action 2
     0.3    0.0   0.0;              %color of action 3
     0.0    0.0   0.2;              %color of action 4
     0.3    0.0   0.3;              %color of action 5
     0.6    0.6   0.6];             %color of action 6
T =  size(Hsess.Engagement,2);      %size of timesteps
nexp = Hsess.nHyper;                %numbers of experiments

%% helper cells - variables
for action = 1:6
    n{action} = action:6:nexp*6;                                                %indexes for each action 
    Actions{action} = Hsess.ActionsTaken(n{action}, :, :);                      %Actions{a}: (nAxnexp)xTxnS 
    Sigmas{action} = Hsess.Sigmas(n{action}, :,:);                              %Sigmas{a}:  (nAxnexp)xTxnS
    Metaparams{action} = Hsess.Metaparams(n{action}, :, :);                     %Metaparams{a}: (nAxnexp)xTxnS
    ExpectedActionParams{action} = Hsess.ExpectedActionParams(n{action},:,:);   %ExpActPar{a}: (nAxnexp)xTxnS
    OptimalActions{action} = Hsess.OptimalActions(n{action}, :, :);             %OptAct{a}: (nAxnexp)xTxnS
end
for state = 1:5                                                                 
    m{state} = state:5:nexp*5;                                                  %indexes for each state
    Betas{state} = Hsess.Betas(m{state}, :);                                    %Betas{s}: nexpxT
end

%% actions taken at each state and optimal actions with tolerance interval
figure(1); suptitle('actions taken and optimal actions')
for state = 1:5
    subplot(5,2,state*2-1);
    for action = 1:6
        plot(Actions{action}(:,:,state)', '.', 'Color', b(action,:), 'MarkerSize', 1); hold on; box on;
    end
    xlim([0 T]); ylim([-100 100]);
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
        %plot(TT, YY+12, '--', 'Color', b(action, :), 'MarkerSize', 5); hold on; box on;
        %plot(TT, YY-12, '--', 'Color', b(action, :), 'MarkerSize', 5); hold on; box on;
        fill(t,y, b(action,:), 'EdgeColor', 'None'); hold on; box on; alpha(0.5);
    end
    xlim([0 T]); ylim([-100 100]);
end

%% estimated means of gaussian exploration for optimal actions + 3*sigmas
figure(1);
for state=1:5
    subplot(5,2,state*2);
    for action=1:6
        M = nanmean(ExpectedActionParams{action}(:,:,state),1);
        S = nanmean(Sigmas{action}(:,:,state),1);
        m1 = nanmean(OptimalActions{action}(:,:,state), 1);
        mask = (m1+pi)./(m1+pi);
        %plot(M.*mask, '.', 'Color', b(action,:), 'MarkerSize', 3); hold on; box on;
        plot((M+3*S).*mask, '.', 'Color', b(action,:), 'MarkerSize', 4); hold on; box on;
        plot((M-3*S).*mask, '.', 'Color', b(action,:), 'MarkerSize', 4); hold on; box on;
    end
    xlim([0 T]); ylim([-100 100]);
end

end
