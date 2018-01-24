clear; close all; clc;
addpath(genpath('./'));
load('T'); load('O');

env = environment(T,O);
load('robot.mat');

%%
solved = false;
experiments = 10;
states = [1:120]; states(118) = [];
S = zeros(120, experiments);
h = waitbar(0, 'testing ...');
for s_init = states
    for i = 1: experiments
        solved = false;
        s = s_init;
        env.s = s_init;
        while ~solved
            s = env.s;
            [robot, a, p] = robot.decide(s);
            [env,r] = env.step(a, p);
            sp = env.s;
            robot = robot.learn(s,a,p,r,sp);
            S(s_init, i) = S(s_init, i) + r;
            if env.s == 118
                solved = true;
                %disp('solved');
            end
        end
    end
    waitbar(s_init/length(states));
end
close(h);
