function [E, U, D] = runInteractive(robot, nsess)

addpath(genpath('./'));

%% initializations
load('T');                  %transition matrix
load('O');                  %optimal actions at each state
load('P1');                 %optimal parameters for optimal actions
env = environment(T,O,P);   %environment for state transitions and rewards
E = [];                     %engagement array
U = [];                     %uncertainty of actions array...
D = [];                     %keep difference of optimal parameter value and chosen

s_init = 1;

figure(1);
figure(2);
%% initialize world and start fisualization
for session = 1:nsess
    
    canvas = world(s_init);
    canvas.visualize();
    solved = false;
    pause(0.2);
    s = s_init;
    env.s = s_init;
    
    while ~solved
        [robot, a, p] = robot.decide(s);
        [env,r] = env.step(a,p);
        E = [E env.cEng];
        U = [U robot.sigmas(s,a)];
        D = [D abs(env.optimalP-p)];
    
        figure(1); cla;
        title(['action: ', num2str(a), ' ,parameter: ', num2str(p), ' ,uncertainty: ', num2str(robot.sigmas(s,a))]);
        canvas = canvas.robotAction(a, p);
        sp = env.s;
        robot = robot.learn(s,a,p,r,sp);
        s = env.s;
        if s == 118
            solved = true;
        end
        
        eng = E(max(1,length(E)-50):end);
        unc = U(max(1,length(U)-50):end);
        dif = D(max(1,length(D)-50):end);
        figure(2);
        subplot(3,1,1);
        plot(eng, 'k-.'); box on; xlim([0 50]); ylim([0 10]); title('engagement');
        subplot(3,1,2);
        bar(unc, 'r'); box on; xlim([0 50]); ylim([0 40]); title('uncertainty');
        subplot(3,1,3);
        bar(dif, 'g'); box on; xlim([0 50]); ylim([0 40]); title('difference of parameter from the optimal one');
    end
    
    %reseting session...
    if session ~= nsess
        figure(1);
        txt1 = 'Reseting...';
        text(0,0,txt1,'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center'); hold off;
        pause(1);
    end
    
    %re-initialize in a new state
    s_init = 118;
    while s_init ==118
        s_init = randi(120);
    end

end

figure(1);
txt1 = 'End of Simulation';
text(0,0,txt1,'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center'); hold off;




end
