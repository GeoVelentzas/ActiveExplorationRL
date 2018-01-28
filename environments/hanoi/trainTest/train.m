clear; close all; %clc;
addpath(genpath('../'));
load('T'); load('O'); load('V'); load('P'); load('ParamType');


env = environment(T,O,P,V,ParamType);
%robot = agent(size(T,1), size(T,2), 100);
%load('robot3'); %load a pretrained agent...
% load('Han');
% load('Sloth');
load('Gunner');
% History of transitions (s,a,r,sp);
H = [];
curriculum = inf;
repeat = 5;
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

Trained = false;
counter = 0;
final = 26;
s_init = 1;
env = environment(T,O,P,V,ParamType);
iterations = 3000;
h = waitbar(iterations);
for i = 1:iterations
env.s = s_init;
    
while env.s~=final;
    E = [E env.cEng];
    %disp(['state ', num2str(env.s)]);
    counter = counter +1;
    s = env.s;
    validAction = false;
    while ~validAction
        [temp,a,p] = robot.decide(s);
        validAction = env.V(s,a);
    end
    robot = temp;
    %disp(['action ', num2str(a)]);
    [env,r] = env.step(a,p);
    sp = env.s;
    %disp(['state ', num2str(sp)]);
    robot = robot.learn(s,a,p,r,sp);
end

s_init = randi(27);
while (s_init==26)%||(s_init==12)||(s_init==7)
    s_init= randi(27);
end
waitbar(i/iterations);
end
close(h);
plot(E);
    
    
    
%save('../robots/Gunner.mat', 'robot');
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        
    








