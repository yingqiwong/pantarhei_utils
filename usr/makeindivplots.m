

Addpaths

clear all;

folder    = '../../pantarhei/out/sweep/olv_bas__GaussianPeriodic/dfg01/D10/';
RunID = 'olv05_bas95';
fignameprefix = [folder, RunID '/' RunID];

[fp,fn] = GetOutputMatFiles(folder, RunID);

%% load variables

load(fp, 'rho0','h','N','D','grav','delta0','w0');
[t,x,f,u,w] = ExtractFieldwTime(folder, RunID, {'f','u','w'});


%%

PlayFieldwTime(folder, RunID, {'f'}, {[]}, 'save',1, 'Nstd', 2);

PlotVertProfiles(folder, RunID, {'f'}, [], 'xdsc',1,  'save',1);

PlotFieldwTime(folder, RunID, 'f',[],'Nstd',5,'save',1);

PlotFieldVectors(folder, RunID, {'f','ustar','wstar'}, [], [], [], 'save', 1, 'Nplt', 3);















