clear; close all; clc;
addpath(genpath('./'));
load('T'); load('O');
env = environment(T,O);
load('robot.mat');
load('states_visual');

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

solved = false;
s = s_init;
env.s = s_init;
while ~solved
    pause;
    [robot, a, p] = robot.decide(s);
    disp(['action: ', num2str(a), ' param: ', num2str(p)]);
    [env,r] = env.step(a,p);
    disp(['next state: ', num2str(env.s), ' reward: ', num2str(r)]);
    disp(states_visual(env.s,:));
    sp = env.s;
    robot = robot.learn(s,a,p,r,sp);
    s = env.s;
    if s == 118
        solved = true;
    end
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    