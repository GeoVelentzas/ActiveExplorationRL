clear; close all; clc;
addpath(genpath('./'));
load('T'); load('O');
P = [0 0 0 0 0 0];
env = environment(T,O,P);
load('robot2.mat');


%%
solved = false;
experiments = 10;
states = [1:120]; states(118) = [];
S = zeros(120, experiments);
E = cell(120,experiments);
h = waitbar(0, 'testing ...');
for s_init = states
    for i = 1: experiments
        env = environment(T,O,P);
        solved = false;
        s = s_init;
        env.s = s_init;
        while ~solved
            s = env.s;
            E{s_init,i} = [E{s_init,i} env.cEng];
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

bar(mean(S,2)); xlim([0 120]); title('Average Cummulative Rewards from starting states');


