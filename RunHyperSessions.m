function [ Hsess ] = RunHyperSessions( nhyper, task )

Hsess.Sigmas = [];              %[(nAxnhyper)xTxnS]
Hsess.Betas = [];               %[(nSxnhyper)xT]
Hsess.Engagement = [];          %[nhyperxT]
Hsess.ActionsTaken = [];        %[(nAxnhyper)xTxnS]
Hsess.OptimalActions = [];      %[(nAxnhyper)xTxnS]
Hsess.StatesVisited = [];       %[nhyperxT]
Hsess.Metaparams = [];          %[(nAxnhyper)xTxnS]
Hsess.Hits = [];                %[nhyperxT]
Hsess.DHits = [];               %[nhyperxT]
Hsess.ExpectedActionParams = [];%[(nAxnhyper)xTxnS]
Hsess.Qvalues = [];             %[(nAxnhyper)xTxnS]
Hsess.nHyper = nhyper;          %number of hypersessions
Hsess.Task = task;              %type of task (e.g 'non-stationary1')
Hsess.H = [];


for i = 1:nhyper
    disp(['running session: ', num2str(i)]);
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
    Hsess.ExpectedActionParams = [Hsess.ExpectedActionParams; Sess.ExpectedActionParams];
    Hsess.Qvalues = [Hsess.Qvalues; Sess.Qvalues];
    Hsess.H = [Hsess.H; Sess.H];
end









