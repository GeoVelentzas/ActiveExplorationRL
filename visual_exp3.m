%visual 2;
clear all;
load NewExperiment3

expnumber= size(Eng, 1);


n1 = 1:6:expnumber*6;
A1 = Actions(n1,:,:);

n2 = 2:6:expnumber*6;
A2 = Actions(n2,:,:);

n3 = 3:6:expnumber*6;
A3 = Actions(n3,:,:);

n4 = 4:6:expnumber*6;
A4 = Actions(n4,:,:);

n5 = 5:6:expnumber*6;
A5 = Actions(n5,:,:);

n6 = 6:6:expnumber*6;
A6 = Actions(n6,:,:);

%%
b = [0.0    0.0   0.0;
     0.3    0.3   0.3;
     0.5    0.0   0.0;
     0.0    0.0   0.2;
     0.3    0.0   0.3;
     0.6    0.6   0.6];

%% State1; actions 2,1; t=3001
figure(1);
subplot(3,2,1);
M1S1 = [];
M2S1 = [];

for i=1:size(A2,1);
    M2S1 = [M2S1; repnan(A2(i,:,1))];
end
M2S1 = nanmean(M2S1); 
plot(1:3000, M2S1(1:3000), '.','Color', b(2,:)); hold on;

for i=1:size(A1,1);
    M1S1 = [M1S1; repnan(A1(i,:,1))];
end
M1S1 = nanmean(M1S1); 
plot(3001:10001, M1S1(3001:10001), '.', 'Color', b(1,:));
xlim([0 10001]);  ylim([-100 100]);

%% State2; actions 3, sinusoidal
subplot(3,2,2);
M3S2 = [];
for i=1:size(A3,1);
    M3S2 = [M3S2; repnan(A3(i,:,2))];
end
M3S2 = nanmean(M3S2); 
plot( M3S2, '.','Color', b(3,:)); hold on;
xlim([0 10001]);  ylim([-100 100]);

%% State3, actions 4, 2 cp 6001
subplot(3,2,3);
M4S3 = [];
M2S3 = [];

for i=1:size(A4,1);
    M4S3 = [M4S3; repnan(A4(i,:,3))];
end
M4S3 = nanmean(M4S3); 
plot(1:7000, M4S3(1:7000), '.','Color', b(4,:)); hold on;

for i=1:size(A2,1);
    M2S3 = [M2S3; repnan(A2(i,:,3))];
end
M2S3 = nanmean(M2S3); 
plot(7001:10001, M2S3(7001:10001), '.', 'Color', b(2,:));
xlim([0 10001]);  ylim([-100 100]);

%% State 4, actions 5,4, cp5001
subplot(3,2,4);
M5S4 = [];
M4S4 = [];

for i=1:size(A5,1);
    M5S4 = [M5S4; repnan(A5(i,:,4))];
end
M5S4 = nanmean(M5S4); 
plot(1:5000, M5S4(1:5000), '.','Color', b(5,:)); hold on;

for i=1:size(A4,1);
    M4S4 = [M4S4; repnan(A4(i,:,4))];
end
M4S4 = nanmean(M4S4); 
plot(5001:10001, M4S4(5001:10001), '.', 'Color', b(4,:));
xlim([0 10001]);  ylim([-100 100]);

%% State 5, actions 6
subplot(3,2,5);
M6S5 = [];

for i=1:size(A6,1);
    M6S5 = [M6S5; repnan(A6(i,:,5))];
end
M6S5 = nanmean(M6S5); 
plot(M6S5, '.','Color', b(6,:)); hold on;

xlim([0 10001]);  ylim([-100 100]);
%%
subplot(3,2,6);
q1 = quantile(Eng,0.25);
q3 = quantile(Eng,0.75);
q2 = quantile(Eng, 0.5);
x = 1:10001;
X = [x fliplr(x)];
Y = [q1 fliplr(q3)];
patch(X,Y, [0.8 0.8 0.8],'EdgeColor', 'none'); hold on;
plot(q2,'k-','LineWidth',2); hold on; box on;
xlim([0 10001]);  ylim([0 10]);
%%



x = 1:size(OptimalActions,2);
X=[x,fliplr(x)];            
for i = 1:5
    ax = subplot(3,2, i);
    %these lines are for the tolerance interval of the parameter
    for j = 1:6
        y = OptimalActions(j,:,i);
        if sum(~isnan(y))~=0
            y1  = y-11.18; %correct is 1.18*tol
            y2  = y+11.18;
            Y = [y1, fliplr(y2)];
            TT = X; TT(isnan(Y)) = nan;
            Y(isnan(Y)) = []; TT(isnan(TT)) = [];
            patch(TT,Y,b(j,:),'EdgeColor', 'none'); hold on; box on; alpha 0.3
            plot(TT(1:length(TT)/2),Y(1:length(Y)/2), '--', 'Color', b(j,:), 'LineWidth', 0.7);
            plot(TT(length(TT)/2+1:end),Y(length(Y)/2+1:end),'--',  'Color', b(j,:), 'LineWidth', 0.7);
        end
        %plot(OptimalActions(j,:,i)','-s', 'Color', b(j,:), 'MarkerSize', 10, 'MarkerFaceColor', b(j,:)); hold on;
    end

end
%for i = 1:5
%    subplot(3,2,i);
%    plot([5001 5001], [-100,100], ':', 'Color', [0 0 0] );
%end
