clear; close all; clc;
addpath(genpath('./'));
load('T');

% create the environment with a Given Transition Matrix
env = environment(T);
robot = agent(size(T,1), size(T,2), 100);
% History of transitions (s,a,r,sp);
H = [];
episodes = 1000;
for i = 1:episodes
    s = env.s;
    [robot,a,p] = robot.decide(s);
    [env,r] = env.step(a, p);
    sp = env.s;
    robot = robot.learn(s,a,p,r,sp);
    H = [H; s,a,p,r,sp];
    if mod(i,20)==0
        env = environment(T); %reinitialize
    end
end

% Plot History
figure(1);
subplot(2,2,1);
scatter(1:episodes, H(:,2)); title('actions taken'); box on;
subplot(2,2,2);
scatter(1:episodes, H(:,1)); title('states visited'); box on;
subplot(2,2,3);
plot(H(:,4)); title('rewards returned'); box on;

