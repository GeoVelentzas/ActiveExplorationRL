% Fran�ois: j'ai d� �crire ma propre fonction select_action qui hopefully
% fonctionne de la m�me fa�on que drand01
% ligne 44 ajout� le d�nom nbA-1 pour que somme(proba)=1
% Mehdi: je remplace l'appel a select_action pour retablir l'access
% drand01() pour qu'on ait tous les deux la même version du code


function [ Y, proba ] = valueBasedDecision( values, decisionRule, beta, biais )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    % In this version of valueBasedDecision, we can have N controllers
    % values contains N lines (1 line per controller), 1 column for each competing action
    % values contains only action values in the current state
    % beta contains 1 line, and N columns
    % biais is of the same size as values: bias for controller 1 for action
    % 1, for action 2, ...
    
    nbC = size(values,1); % nb controllers %THIS IS JUST 1
    nbA = size(values,2); % nb actions
    
    switch (decisionRule),
        case 'matching',
            if (sum(beta) ~= 0),
                proba = (beta*values) / sum(beta);
            else
                proba = ones(1,nbA) / nbC;
            end;
            Y = drand01(proba); % rolls a dice and chooses an action depending on its proba
            %Y =select_action(proba); % ma version de ce qui est surement la m�me chose
        case 'max'
            if (sum(beta) ~= 0),
                proba = (beta*values) / sum(beta);
            else
                proba = ones(1,nbA) / nbC;
            end;
            Y = argmax(proba);
        case 'softmax'
            combVal = min(beta*values+biais,ones(1,nbA)*700);
            proba = exp(combVal) / sum(exp(combVal));
            Y = drand01(proba); % rolls a dice and chooses an action depending on its proba 
            %Y =select_action(proba); % ma version de ce qui est surement la m�me chose
        case 'epsilon'
            proba = (ones(1,nbA) * beta + biais) / (nbA - 1); % beta == epsilon
            [~, idxBest] = max(values+biais);
            proba(idxBest) = biais(idxBest)/ (nbA - 1) + 1 - beta; 
            Y = drand01(proba); % rolls a dice and chooses an action depending on its proba 
            %Y =select_action(proba); % ma version de ce qui est surement la m�me chose
    end;
    proba = max(proba,ones(1,nbA)*1e-100);
end

