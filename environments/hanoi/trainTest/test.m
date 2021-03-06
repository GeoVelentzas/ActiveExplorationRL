% test for a changing Parameter set...
clear; close all; clc;
addpath(genpath('../'));

load('T'); load('O'); load('V'); load('P'); load('ParamType');
env = environment(T,O,P,V,ParamType);
% load('robot3');
% load('Sloth');
% load('Han');
load('Gunner');


final = 26;
episodes = 9000;
s_init = 1;
E = [];
CP = [];
h = waitbar(episodes);
i = 1;
cps = [1000 1500 2000 4000 5000];
while i<=episodes 
env.s = s_init;

while env.s~=final;
    i = i+1;
    if mod(i,1000)==0
        CP = [CP i];
        %for j = 1:6
        %    env.P(j)= min(env.P(j)+10, 85);
        %end
        env.P(6) = min(env.P(6)+20, 85);
    end
    E = [E env.cEng];
    s = env.s;
    validAction = false;
    while ~validAction
        [temp,a,p] = robot.decide(s);
        validAction = env.V(s,a);
    end
    robot = temp;
    [env,r] = env.step(a,p);
    sp = env.s;
    robot = robot.learn(s,a,p,r,sp);
end


s_init = randi(27);
while s_init==26
    s_init=randi(27);
end
waitbar(i/episodes);
end
close(h);
plot(E,'k','LineWidth',2); hold on; xlim([0 episodes]);
for cp = CP
    plot([cp cp], [0 10], 'k--');
end