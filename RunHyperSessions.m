function [ Hsess ] = RunHyperSessions( nhyper, task )
Hsess.Sigmas = [];
Hsess.Betas = [];
Hsess.Engagement = [];
Hsess.ActionsTaken = [];
Hsess.OptimalActions = [];
Hsess.StatesVisited = [];
Hsess.Metaparams = [];
Hsess.Hits = [];
Hsess.DHits = [];
Hsess.nHyper = nhyper;
Hsess.Task = task;

for i = 1:nhyper
    [Sess]= RunSession(task);
    Hsess.Sigmas = [Hsess.Sigmas; Sess.Sigmas];
    Hsess.Betas = [Hsess.Betas; Sess.Betas];
    Hsess.Engagement = [Hsess.Engagement; Sess.Engagement];
    Hsess.ActionsTaken = [Hsess.ActionsTaken; Sess.ActionsTaken];
    Hsess.OptimalActions = [Hsess.OptimalActions; Sess.OptimalActions];
    Hsess.StatesVisited = [Hsess.StatesVisited; Sess.StatesVisited];
    Hsess.Metaparams = [Hsess.Metaparams; Sess.Metaparams];
    Hsess.Hits = [Hsess.Hits; Sess.Hits];
    Hsess.DHits = [Hsess.DHits; Sess.DHits];
end