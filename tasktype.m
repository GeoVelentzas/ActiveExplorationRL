function BBT = tasktype( BBT, t, s, type )

global cpTime

persistent switched;
if isempty(switched) 
    switched = false;
end

switch(type)
    case 'non-stationary1'
     if (t >= 5001)&&(~switched)&&(s==1) %from [2 3 4 5 6] to [1 4 3 2 5]with different parameter values...
         
         BBT.optimal(1) = 1;
         BBT.P(1, :, :) = 0; %flush
         BBT.P(1, :, 1) = 1; %all actions lead to the same state
         BBT.P(1, 1, 1) = 0; %correct action doesn't lead to the same state
         BBT.P(1, 1, 2) = 1; %correct action leads to the next state
         BBT.engMu(1) = 0;
         
         BBT.optimal(2) = 4;
         BBT.P(2, :, :) = 0; %flush
         BBT.P(2, :, 2) = 1; %all actions lead to the same state
         BBT.P(2, 4, 2) = 0; %correct action doesn't lead to the same state
         BBT.P(2, 4, 3) = 1; %correct action leads to the next state
         BBT.engMu(2) = -20;
         
         
         BBT.optimal(3) = 3;
         BBT.P(3, :, :) = 0; %flush
         BBT.P(3, :, 3) = 1; %all actions lead to the same state
         BBT.P(3, 3, 3) = 0; %correct action doesn't lead to the same state
         BBT.P(3, 3, 4) = 1; %correct action leads to the next state
         BBT.engMu(3) = 10;
         
         BBT.optimal(4) = 2;
         BBT.P(4, :, :) = 0; %flush
         BBT.P(4, :, 4) = 1; %all actions lead to the same state
         BBT.P(4, 2, 4) = 0; %correct action doesn't lead to the same state
         BBT.P(4, 2, 5) = 1; %correct action leads to the next state
         BBT.engMu(4) = 10;

         BBT.optimal(5) = 5;
         BBT.P(5, :, :) = 0; %flush
         BBT.P(5, :, 5) = 1; %all actions lead to the same state
         BBT.P(5, 5, 5) = 0; %correct action doesn't lead to the same state
         BBT.P(5, 5, 1) = 1; %correct action leads to the next state
         BBT.engMu(5) = 0;
         switched = true;
         cpTime = t;
         
     end
    
    
    case 'non-stationary2'
     if (t == 5001) %WRITE SOME CODE FOR AUTOMATIC CHANGES...
         BBT.optimal(1) = 1; %THE OPTIMAL ACTION IN STATE 1 IS NOW ACTION 1... IT WAS ACTION 2
         BBT.P(1, 1:2, :) = 0; %IN ORDER TO CHANGE THE TRANSITIONS OF THE FIRST 2 ACTIONS
         BBT.P(1, 1, 2) = 1; %ACTION 1 NOW LEADS TO STATE 2...
         BBT.P(1, 2, 1) = 1; %ACTION 2 LEADS BACK TO STATE 1...
         % change of state 2 optimal continuous parameter
         BBT.engMu(1) = -0; %engMu([2 4]) = 50; engMu([1 3 end]) = -50;
     end
     if mod(t, 2000) == 0
        BBT.engMu(2) = BBT.engMu(2) - sign(BBT.engMu(2))*100;
     end
     BBT.engMu(3) = 90*sin(2*pi/10000*t);


end
end

