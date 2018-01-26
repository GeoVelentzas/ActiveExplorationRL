clear; close all; clc;
addpath(genpath('./'));

%% 
nsess = 1000;                 %choose number of sessions to visualize...
%% initializations
load('T');                  %transition matrix
load('O');                  %optimal actions at each state
load('P1');                 %optimal parameters for optimal actions
load('V');
env = environment(T,O,P,V); %environment for state transitions and rewards
E = [];                     %engagement array
S = [];                     %uncertainty of actions array...
O = [];                     %track if the actions chosen are optimal
OP= [];                     %optimal parameters for the actions taken
B = [];                     %inverse temperature at this state
%% choose a robot to load or a new agent...
rob = 'robot6';             %chose an agent
load([rob,'.mat']);         %load the agent (named "robot")
load('states_visual');      %to display the initial state in command window
robot1 = robot;
robot2 = agent(120,6,100);
robot = robot2;
visual = true;
cp = false;
%P2 = [30 10 10 20 -30 -10]; %new parameters for change point
P2 = P; P2(2) = 20;
P1 = P;
starting_state = 1;  %% you can change this
s_init = starting_state;
figure('units','normalized','outerposition',[0 0 1 1])
btn1 = uicontrol('Style', 'pushbutton', 'String', 'Untrained Robot',...
        'Position', [20 20 100 50],...
        'Callback', 'robot = robot2');  
btn2 = uicontrol('Style', 'pushbutton', 'String', 'Trained Robot',...
        'Position', [20 70 100 50],...
        'Callback', 'robot = robot1;');  
btn3 = uicontrol('Style', 'pushbutton', 'String', 'Change Point!',...
        'Position', [20 120 100 50],...
        'Callback', 'env.P=P2; cp=true;');  
btn4 = uicontrol('Style', 'pushbutton', 'String', 'Non Visual',...
        'Position', [20 170 100 50],...
        'Callback', 'visual=false;');  
btn4 = uicontrol('Style', 'pushbutton', 'String', 'Visual',...
        'Position', [20 220 100 50],...
        'Callback', 'visual=true;');  
%% initialize world and start fisualization
for session = 1:nsess
    
    canvas = world(s_init);
    if visual
        canvas.visualize();
    end
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
        O = [O env.O(s,a)];         %1 if action is optimal 0 otherwise;
        [env,r] = env.step(a,p);    %step of environment...
        E = [E env.cEng];           %engagement
        OP =[OP env.optimalP];      %optimal Parameter value for the action taken (meaningless for non optimal action)
        S = [S robot.sigmas(s,a)];  %uncertainty of the action taken...
        B = [B robot.betas(s)];     %inverse temperature in this state...
    
        %  show data...
        figure(1);
        subplot(3,10,[1:5, 11:15, 21:25]); cla;
        title(['Performing Action: ', num2str(a), ' , Parameter: ', num2str(p)]);       
        eng = E(max(1,length(E)-50):end);
        x = 1:length(E);
        lim = [0 50];
        if length(E)>50
            x = x(end-50:end);
            lim = [x(1) x(end)];
        end
        opt = O(max(1,length(O)-50):end);
        subplot(3,10,6:10);
        plot(x,eng, '-.gs', 'MarkerSize', 5, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'k');
        box on; xlim(lim); ylim([0 10]); title('engagement'); xlabel('episode');
        %subplot(3,10,6:10);
        subplot(3,10,26);
        if O(end)
            bar(1,'g'); box on; ylim([0 1]); title('AT');
        else
            bar(1,'r'); box on; ylim([0 1]); title('AT');
        end
        if O(end)
            subplot(3,10,27);
            bar(OP(end), 'b'); box on; ylim([-100 100]); title('OP');
            subplot(3,10,28);
            bar(p, 'b'); box on; ylim([-100 100]); title('PT');
        else
            subplot(3,10,27);
            bar(0,'b');  box on; ylim([-100 100]); title('OP');
            subplot(3,10,28);
            bar(0,'b');  box on; ylim([-100 100]); title('PT');
        end
        subplot(3,10,29);
        bar(B(end),'k'); ylim([5 15]); title('\beta(s)');
        subplot(3,10,30);
        bar(S(end),'r'); ylim([0 40]); title('\sigma(s,a)');
        
        % visualize movement...
        if visual
            figure(1); 
            canvas = canvas.robotAction(a, p, env.cEng);
        else
            drawnow;
        end
        sp = env.s;
        robot = robot.learn(s,a,p,r,sp);
        s = env.s;
        if s == 118
            solved = true;
        end
        
    end
    
    %reseting session...
    if session ~= nsess
        if visual
            figure(1);
            txt1 = 'Reseting...';
            text(0,0,txt1,'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center'); hold off;
            pause(1);
        end
    end
    
    %re-initialize in a new state
    s_init = 118;
    while s_init ==118
        s_init = randi(120);
        if cp
            s_init = starting_state;
        end
    end

end

figure(1);
canvas.visualize();
txt1 = 'End of Simulation';
text(0,0,txt1,'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center'); hold off;
















