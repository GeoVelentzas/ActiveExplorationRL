clear; close all; clc;
addpath(genpath('./'));


nsess = 30;                 %choose number of sessions to visualize...

%% initializations
load('T');                  %transition matrix
load('O');                  %optimal actions at each state
load('P1');                 %optimal parameters for optimal actions
load('V');
env = environment(T,O,P,V); %environment for state transitions and rewards
E = [];                     %engagement array
U = [];                     %uncertainty of actions array...
D = [];                     %keep difference of optimal parameter value and chosen
O = [];                     %track if the actions chosen are optimal
%% choose a robot to load
%robot : trained for only finding the optimal discrete actions without and engagement feedback
%robot2: trained with maximizing engagement for P=[0 0 0 0 0 0];
%robot3: trained with P1

rob = 'robot6';             %chose an agent
load([rob,'.mat']);         %load the agent (named "robot")
load('states_visual');      %to display the initial state in command window
robot = agent(120,6,100);  %or start a new agent... 

%% prompt to give a starting state
valid_states = 1:120; valid_states(118)=[];
valid_input = false;
while ~valid_input
    s_init = input('give a starting state from 1-120 (state 118 is final) : ');
    if ismember(s_init, valid_states)
        valid_input = true;
    else
        disp('not a valid initial state...');
    end
end
display(['initialized in state ', num2str(s_init)]);
display(states_visual(s_init,:));
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
        validAction = false;
        while ~validAction
            clear temp
            [temp, a, p] = robot.decide(s);
            validAction = env.V(env.s,a);
        end
        robot = temp;
        O = [O env.O(s,a)];
        [env,r] = env.step(a,p);
        E = [E env.cEng];
        U = [U robot.sigmas(s,a)];
        D = [D abs(env.optimalP-p)];
    
        figure(1); cla;
        title(['action: ', num2str(a), ' ,parameter: ', num2str(p), ' ,uncertainty: ', num2str(robot.sigmas(s,a))]);
        canvas = canvas.robotAction(a, p, env.cEng);
        sp = env.s;
        robot = robot.learn(s,a,p,r,sp);
        s = env.s;
        if s == 118
            solved = true;
        end
        
        eng = E(max(1,length(E)-50):end);
        unc = U(max(1,length(U)-50):end);
        opt = O(max(1,length(O)-50):end);
        figure(2);
        subplot(3,1,1);
        plot(eng, 'k-.'); box on; xlim([0 50]); ylim([0 10]); title('engagement');
        subplot(3,1,2);
        bar(unc, 'r'); box on; xlim([0 50]); ylim([0 40]); title('uncertainty');
        subplot(3,1,3);
        bar(imcomplement(opt), 'k'); box on; xlim([0 1]); ylim([0 40]); title('non optimal actions...');
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
















