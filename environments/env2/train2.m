clear; close all; clc;
addpath(genpath('./'));
load('T'); load('O');
P = [0 0 0 0 0 0];

% create the environment with a Given Transition Matrix
env = environment(T,O,P);
robot = agent(size(T,1), size(T,2), 100);
% History of transitions (s,a,r,sp);
H = [];
curriculum = inf;
repeat = 40;
counter = 0;
counter1 = 0;
%episodes = 12000; %curriculum*repeat*120;
%simple learning...
s_init = 1;
R = [1];
S = [1];
G = [];
C = [1];
E = [];
h = waitbar(0,'Please wait for initial training...');
Trained = false;
i = 0;
while ~Trained
    i = i+1;
%     disp(['state now: ', num2str(env.s)]);
%     pause;
    s = env.s;
    E = [E env.cEng];
    [robot,a,p] = robot.decide(s);
    [env,r] = env.step(a, p);
    sp = env.s;
    robot = robot.learn(s,a,p,r,sp);
    H = [H; s,a,p,r,sp];
    if counter1 == curriculum
        env.s = s_init;
        counter = counter + 1;
%         disp('end of curriculum... repeating');
        counter1 = 0;
        counter = counter + 1;
        C = [C i];
    end
    if counter==repeat
        %s_init = randi(120);
        %s_init = randi(10);
        if s_init==120
            Trained = true;
        end
        s_init = min(s_init+1, 120);
        if s_init==118
            s_init = 119;
        end
%         disp(['New curriculum starting at state: ', num2str(s_init)]);
        env.s = s_init;
        counter = 0;
        R = [R i]; %timesteps of new curriculum to learn
        S = [S s_init];
    end
    if env.s==118
        %env = environment(T,O,P);
        G = [G i];
%         disp(['reached GOAL state! Repeating curriculum...']);
        env.s = s_init;
        S(end) = s_init;
        counter = counter+1;
        counter1 = 0;
        C = [C i];
    end
    counter1 = counter1+1;
    waitbar(s_init / 120)
end
close(h)

% Plot History
% figure(1);
% subplot(2,2,1);
% scatter(1:episodes, H(:,2)); title('actions taken'); box on;
% subplot(2,2,2);
% scatter(1:episodes, H(:,1)); title('states visited'); box on;
% subplot(2,2,3);
% plot(H(:,4)); title('rewards returned'); box on;

figure(1);
subplot(3,1,1);
plot(H(:,4)); title('rewards returned'); box on; hold on;
scatter(R, zeros(1,length(R))); hold on;
scatter(C, zeros(1,length(C)),'*c');
subplot(3,1,2);
scatter(R, S); box on; hold on;
subplot(3,1,3);
scatter(1:size(H,1), H(:,1), '.'); box on; title('states visited');
disp('agent trained....')















