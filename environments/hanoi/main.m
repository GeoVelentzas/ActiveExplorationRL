clear; close all; clc;
addpath(genpath('./'));

%% 
nsess = inf;                 %choose number of sessions to visualize...
sim = true;
%% initializations
load('T');                  %transition matrix
load('O');                  %optimal actions at each state
load('P');                  %optimal parameters for optimal actions
load('V');
load('ParamType');
env = environment(T,O,P,V,ParamType); %environment for state transitions and rewards
E = [5];                     %engagement array
S = [];                     %uncertainty of actions array...
O = [];                     %track if the actions chosen are optimal
OP= [];                     %optimal parameters for the actions taken
B = [];                     %inverse temperature at this state
%% choose a robot to load or a new agent...
rob = 'Gunner';             %chose an agent
load([rob,'.mat']);         %load the agent (named "robot")
robot1 = robot;
robot2 = agent(120,6,100);
%robot = robot2;
visual = true;
cp = false;
newrob = false;
P2 = P; P2(2) = -10;
P1 = P; %no need
ChangeTime = [];
NewRobotTime = [];
TrainedRobotTime = [1];
starting_state = 1;  %% you can change this
s_init = starting_state;
ff = false;
back = false;
figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color',[0.9 0.9 0.9]);
btn1 = uicontrol('Style', 'pushbutton', 'String', 'New Robot',...
        'Position', [20 75 120 50],...
        'Callback', 'robot = robot2; newrob = true; NewRobotTime = [NewRobotTime length(E)];');      
btn2 = uicontrol('Style', 'pushbutton', 'String', 'Trained Robot',...
        'Position', [20 125 120 50],...
        'Callback', 'robot = robot1; newrob=false; TrainedRobotTime = [TrainedRobotTime length(E)];');  
btn3 = uicontrol('Style', 'pushbutton', 'String', 'Change Point!',...
        'Position', [20 175 120 50],...
        'Callback', 'env.P(6)=min(env.P(6)+20, 85); cp=true; ChangeTime = [ChangeTime length(E)];');  
btn4 = uicontrol('Style', 'pushbutton', 'String', 'Fast Forward',...
        'Position', [20 225 120 50],...
        'Callback', 'visual=false; ff=true;');  
btn5 = uicontrol('Style', 'pushbutton', 'String', 'Show Robot',...
        'Position', [20 275 120 50],...
        'Callback',  'visual=true; ff=false; back=true;');  
btn6 = uicontrol('Style', 'pushbutton', 'String', 'Stop Sim',...
        'Position', [20 325 120 50],...
        'Callback', 'sim=false;');  
    
set(btn1,'BackgroundColor',[0.8 0.8 1]);
set(btn2,'BackgroundColor',[0.8 0.8 1]);
set(btn3,'BackgroundColor',[0.8 0.8 1]);
set(btn4,'BackgroundColor',[0.8 0.8 1]);
set(btn5,'BackgroundColor',[0.8 0.8 1]);
set(btn6,'BackgroundColor',[1 0 0]);
%% initialize world and start fisualization
session = 0;
steps = 0;
while sim
    session = session + 1;    
    canvas = world(s_init);
    if visual
        canvas.visualize();
    end
    solved = false;
    pause(0.2);
    s = s_init;
    env.s = s_init;
    while ~solved
        steps = steps + 1;
        if ~sim
            break;
        end
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
        if visual
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
        box on; xlim(lim); ylim([0 10]); title('engagement');
        %subplot(3,10,6:10);
        subplot(3,10,16:17);
        bar(robot.Q(s,:), 0.4, 'FaceColor',[0 .5 .5],'EdgeColor',[0.9 0 0.9]); hold off; box on; xlim([0.5 6.5]); ylim([-5 5]);
        title('Q-Values');
        
        subplot(3,10,18:20); 
        cla;
        box on; 
        op = env.optimalP;
        patch([op+11 op-11 op-11 op+11], [0 0 1 1], [0.8 0.8 0.8], 'EdgeColor', 'None'); 
        xlim([-100 100]); ylim([0 0.15]); hold on; title('parameter pdf'); set(gca,'ytick',[]);
        x = -200:0.05:200;
        m = robot.ACT(a);
        sigma = robot.sigmas(s,a);
        distrib = normpdf(x,m,sigma);
        patch([-200:0.05:200 200:-0.05:-200], [distrib 0*[-200:0.05:200]],[1 0 0], 'EdgeColor', 'None'); xlim([-100 100]); alpha(0.5); 
        
        subplot(3,10,26);
        if O(end)
            %bar(1,'g'); box on; ylim([0 1]); title('AT');
            bar1(1,'g','None',1); box on; ylim([0 1]); title('AT'); xlim([0 1]); set(gca,'xtick',[]); set(gca,'ytick',[]);
        else
            %bar(1,'r'); box on; ylim([0 1]); title('AT');
            bar1(1,'r','None',1); box on; ylim([0 1]); title('AT'); xlim([0 1]); set(gca,'xtick',[]); set(gca,'ytick',[]);
        end
        if O(end)
            subplot(3,10,27); cla;
            %bar(OP(end), 'b'); box on; ylim([-100 100]); title('OP')
            bar1(OP(end),'b','None',0.6); box on; ylim([-100 100]); title('OP'); hold on; plot([-1 2], [0 0], 'k'); hold off; xlim([-1 2]); set(gca,'xtick',[]); 
            subplot(3,10,28); cla;
            %bar(p, 'b'); box on; ylim([-100 100]); title('PT');
            bar1(p,'b','None',0.6); box on; ylim([-100 100]); title('PT'); hold on; plot([-1 2], [0 0], 'k'); hold off; xlim([-1 2]); set(gca,'xtick',[]); 
        else
            subplot(3,10,27); cla;
            bar(0,'b');  box on; ylim([-100 100]); title('OP'); set(gca,'xtick',[]); 
            subplot(3,10,28); cla;
            bar(0,'b');  box on; ylim([-100 100]); title('PT'); set(gca,'xtick',[]);
        end
        subplot(3,10,29); cla;
        %bar(B(end),'k'); ylim([5 15]); title('\beta(s)');
        bar1(B(end),'k','None',0.8); box on; ylim([5 15]); title('\beta(s)'); hold on; plot([-1 2], [0 0], 'k'); xlim([-1 2]); set(gca,'xtick',[]);
        subplot(3,10,30); cla;
        %bar(S(end),'r'); ylim([0 40]); title('\sigma(s,a)');
        bar1(S(end),'r','None',0.8); box on; ylim([0 40]); title('\sigma(s,a)'); hold on; plot([-1 2], [0 0], 'k'); xlim([-1 2]); set(gca,'xtick',[]);
        end
        
        if ff
            figure(1);
            subplot(3,10,[1:5, 11:15, 21:25]); cla;
            subplot(3,10,16:17); cla;
            subplot(3,10,6:10); cla;
            subplot(3,10,18:20); cla;
            subplot(3,10,26); cla;
            subplot(3,10,27); cla;
            subplot(3,10,28); cla;
            subplot(3,10,29); cla;
            subplot(3,10,30); cla;
            ff = false;
        end
        
        
        if ~visual
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
            box on; xlim(lim); ylim([0 10]); title('engagement');

            if (~newrob)&&(cp)&&env.ParamType(s)==6;
                subplot(3,10,18:20);
                cla;
                box on;
                op = env.P(env.ParamType(s));
                patch([op+11 op-11 op-11 op+11], [0 0 1 1], [0.8 0.8 0.8], 'EdgeColor', 'None');
                xlim([-100 100]); ylim([0 0.15]); hold on; title('changing parameter'); set(gca,'ytick',[]);
                x = -200:0.05:200;
                m = robot.ACT(a);
                sigma = robot.sigmas(s,a);
                distrib = normpdf(x,m,sigma);
                patch([-200:0.05:200 200:-0.05:-200], [distrib 0*[-200:0.05:200]],[1 0 0], 'EdgeColor', 'None'); xlim([-100 100]); alpha(0.5);
            elseif (newrob)
                subplot(3,10,18:20);
                cla;
                box on;
                op = env.optimalP;
                patch([op+11 op-11 op-11 op+11], [0 0 1 1], [0.8 0.8 0.8], 'EdgeColor', 'None');
                xlim([-100 100]); ylim([0 0.15]); hold on; title('parameter pdf'); set(gca,'ytick',[]);
                x = -200:0.05:200;
                m = robot.ACT(a);
                sigma = robot.sigmas(s,a);
                distrib = normpdf(x,m,sigma);
                patch([-200:0.05:200 200:-0.05:-200], [distrib 0*[-200:0.05:200]],[1 0 0], 'EdgeColor', 'None'); xlim([-100 100]); alpha(0.5);
                                
            end
            drawnow;
        end
        
        
        % visualize movement...
        if visual
            if ~back
                figure(1);
                canvas = canvas.robotAction(a, p, env.cEng);
            elseif back
                if env.s==26
                    back = false;
                end
            end
        end
        sp = env.s;
        robot = robot.learn(s,a,p,r,sp);
        s = env.s;
        if s == 26
            solved = true;
        end
        
    end
    
    %reseting session...
    if session ~= nsess
        if visual&&sim
            figure(1);
            txt1 = 'Reseting...';
            text(0,0,txt1,'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', 'Color', [1 1 1]); hold off;
            pause(0.5);
        end
    end
    
    %re-initialize in a new state
    s_init = 26;
    while s_init ==26
        s_init = randi(27);
        if cp
            s_init = starting_state;
        elseif newrob
            s_init = starting_state;
        end
    end

end


figure(1);
subplot(3,10,6:10); cla;
for c= ChangeTime
    plot([c c], [0 10], '--', 'Color', [0.7 0.7 0.7], 'LineWidth', 2); ylim([0 10]); hold on;
end
for nrt = NewRobotTime
    plot([nrt nrt], [0 10], '-', 'Color', [0.99 0.3 0.3], 'LineWidth', 2);
end
for trt =TrainedRobotTime
    plot([trt trt], [0,10], '-', 'Color', [0.5 0.5 0.9], 'LineWidth', 2);
end
plot(1:length(E), E, 'k', 'LineWidth', 2); title('engagement'); xlabel('episodes');
















