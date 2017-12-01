function BBT = tasktype( BBT, t, statenow, type )

global cpTime
persistent switched;
if isempty(switched) 
    switched = false;
end

switch(type)
    case 'non-stationary0'
            if (t >= 5001) %from [2 3 4 5 6] to [1 4 3 2 5]with different parameter values...
                BBT.engMu(1) = 0;         
                BBT.engMu(2) = -20;
                BBT.engMu(3) = 10;
                BBT.engMu(4) = 10;
                BBT.engMu(5) = 0;
                switched = true;
                cpTime = t;
            end
    
    case 'non-stationary1'
        if (t == 5001) %from [2 3 4 5 6] to [1 4 3 2 5]with different parameter values...
         
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
     if (t == 3001) %WRITE SOME CODE FOR AUTOMATIC CHANGES...
         BBT.optimal(1) = 1;
         BBT.P(1, :, :) = 0; %flush
         BBT.P(1, :, 1) = 1; %all actions lead to the same state
         BBT.P(1, 1, 1) = 0; %correct action doesn't lead to the same state
         BBT.P(1, 1, 2) = 1; %correct action leads to the next state
         BBT.engMu(1) = 0;
         switched = true;
         cpTime = t;
     end
     if (t == 5001)
         BBT.optimal(4) = 4;
         BBT.P(4, :, :) = 0; %flush
         BBT.P(4, :, 4) = 1; %all actions lead to the same state
         BBT.P(4, 4, 4) = 0; %correct action doesn't lead to the same state
         BBT.P(4, 4, 5) = 1; %correct action leads to the next state
         BBT.engMu(4) = -10;
     end
     
     if (t == 7001)
         BBT.optimal(3) = 2;
         BBT.P(3, :, :) = 0; %flush
         BBT.P(3, :, 3) = 1; %all actions lead to the same state
         BBT.P(3, 2, 3) = 0; %correct action doesn't lead to the same state
         BBT.P(3, 2, 4) = 1; %correct action leads to the next state
         BBT.engMu(3) = 10;
    
     end
     
     BBT.engMu(2) = 80*sin(2*pi/10000*t);


end
end

