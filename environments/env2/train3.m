clear; close all; %clc;
addpath(genpath('./'));
load('T'); load('O'); load('V');
%P = [0 0 0 0 0 0];
load('P1.mat');

% create the environment with a Given Transition Matrix
env = environment(T,O,P,V);
%robot = agent(size(T,1), size(T,2), 100);
load('robot8'); %load a pretrained agent...
% History of transitions (s,a,r,sp);
H = [];
curriculum = inf;
repeat = 20;
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
    s = env.s;
    E = [E env.cEng];
    [robot,a,p] = robot.decide(s);
    [env,r] = env.step(a, p);
    sp = env.s;
    robot = robot.learn(s,a,p,r,sp);
    H = [H; s,a,p,r,sp];
    if env.s==118
        env = environment(T,O,P,V);
        G = [G i];
        env.s = s_init;
        S(end) = s_init;
        counter = counter+1;
        C = [C i];
    end
    if counter==repeat
        if s_init==120
            Trained = true; %Trained for all states as starting states
        end
        s_init = min(s_init+1, 120); %start training from next state
        if s_init==118
            s_init = 119;
        elseif s_init == 88
            s_init = 91;
        end
        env.s = s_init;
        counter = 0;
        R = [R i]; %timestep of new starting curriculum to learn
        S = [S s_init]; %timestep of new starting state
    end
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
disp('agent trained.... you may save it')











