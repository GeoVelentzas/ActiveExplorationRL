clear; close all;
env = environment('./grid.txt', false, false);
V = 0*env.Map;
Q = zeros(size(env.Map,1), size(env.Map,2), 4);
gamma = 0.9;
a = 0.2;
%visualize(env);

for i=1:10
    disp(i);
    env = environment('./grid.txt', false, false);
    starting = (find(env.Map ==0));
    env.S = datasample(starting, 1);
    while env.S~=env.Goal
        [si, sj] = ind2sub(size(env.Map), env.S);
        s = env.S;
        action_choices = Q(si,sj,:);
        action = find(action_choices == max(action_choices(:)),1);
        
        %action = randi(4);
        par = randi(1);
        %pause(0.5);
        [env,r] = env.step(action,par);
        sp = env.S;
        [spi, spj] = ind2sub(size(env.Map), env.S);
        Q(si,sj,action) = Q(si,sj,action) + a*(r + gamma*max(Q(spi,spj,:))-Q(si,sj,action));
        V(s) = V(s) + a*(r+gamma*V(sp)-V(s));
        %showV(V);
        %showQ(Q);
        %[si, sj] = ind2sub(size(env.Map), env.S);
        %disp(r);
    end
    disp('GOAL');
end

