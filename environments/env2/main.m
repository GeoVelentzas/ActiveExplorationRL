clear; close all; clc;
addpath(genpath('./'));
load('T');

% create the environment with a Given Transition Matrix
env = environment(T);

% History of transitions (s,a,r,sp);
H = [];
for i = 1:100
    actions = randperm(6);
    s = env.s;
    a = actions(1);
    p = randn;
    env = env.step(a);
    r = env.r;
    sp = env.s;
    H = [H; s,a,p,r,sp];
end

% Plot History
figure(1);
subplot(2,2,1);
scatter(1:100, H(:,2)); title('actions taken'); box on;
subplot(2,2,2);
scatter(1:100, H(:,1)); title('states visited'); box on;
subplot(2,2,3);
plot(H(:,3)); title('rewards returned'); box on;

