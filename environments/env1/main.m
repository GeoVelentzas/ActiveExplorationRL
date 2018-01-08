clear all; close all; clc;
env = environment();
t = 1;
tnext = t + 3 + ceil(20*rand);
actions = [1 2 3 4 5 6];
while true
    env.visualize();
    env = env.step();
    if t == tnext
        idx = randperm(6);
        idx = idx(1);
        act = actions(idx);
        par = 0.01 + 0.6*rand;
        env = env.robotAction(act, par);
        tnext = t + 3 + ceil(15*rand);
    end
    t = t+1;
end






%%

for i = 1:100;
    env.visualize();
    env = env.step();
    if i==2
        env = env.robotAction(2,0.05);
    end
    if i==20
        env = env.robotAction(3,0.2);
    end
    if i==50
        env = env.robotAction(1,0.1);
    end
    if i==55
        env = env.robotAction(6,0.7);
    end
    if i==70
        env = env.robotAction(4, 0.4);
    end
    if i==80
        env = env.robotAction(5, 0.5);
    end
end

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
