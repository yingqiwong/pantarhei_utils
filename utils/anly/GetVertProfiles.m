function [t, xp, v] = GetVertProfiles (folder, RunID, varname, varmat, xind, xdsc)
%
% [t, x, v] = GetVertProfiles (folder, RunID, varname, varmat, varargin)
% retrieves vertical profile of model at the middle of the domain (default)
% or at a specified x point
%
% example
% [t, x, v] = GetVertProfiles(folder, RunID, {'f'})
% [t, x, v] = GetVertProfiles(folder, RunID, {'divv'}, {divv})
%
%
% INPUTS
% folder    folder name where runs are stored
% RunID     name of run
% varname   cell vector of variable names
%               NB if you want certain axis limit options, varname has to be precise
% varmat    cell vector of variable matrices to plot
%               if mising or empty, load the variable of varname from file
%               varname, varmat must be same size
% xind      which x index to retrieve (middle by default, can also say 'mean')
% xdsc      whether to divide x by max dsc (false by default)
%
% OUTPUTS
% t         simulation times [Nf x 1]
% xp        x positions {1, Nvar}
% v         variable profiles {1, Nvar}
%
%
% YQW, 17 June 2021

if nargin<4, varmat = []; end
if nargin<5, xind   = 0;  end
if nargin<6, xdsc   = 0;  end

% extract file names
fp = GetOutputMatFiles(folder, RunID);

% get options
Nvar = length(varname);
if isempty(varmat), varmat = cell(Nvar,1); end

% get solution run params
load(fp,'N','h','delta0');

% assign variables to background, u vectors, w vectors
[t, x, varmat] = LoadPlotVars(folder, RunID, varname, varmat);
if ~iscell(varmat), varmat = {varmat}; end



% now collect vectors for plotting
% initialize outputs
v = cell(1,Nvar);

if isnumeric(xind)              
    if xind>0   % if desired x index is provided
        for vi = 1:Nvar, v{vi} = permute(varmat{vi}(:,:,xind,:),[1,2,4,3]); end
    else         % take the middle profile by default
        xmid   = round(0.5*size(varmat{1},3));
        for vi = 1:Nvar, v{vi} = permute(varmat{vi}(:,:,xmid,:),[1,2,4,3]); end
    end
    
elseif isstring(xind)
    if strcmp(xind, 'mean')     % if you want the mean across x
        for vi = 1:Nvar, v{vi} = squeeze(mean(varmat{vi},3)); end
    end
end




% collect vertical points
xp = cell(1,Nvar);
for vi = 1:Nvar
    if     size(v{vi},2)==N
        xp{vi} = x;                         % cell-centered variable (p, f)
    elseif size(v{vi},2)==(N+1)
        xp{vi} = [x-0.5*h, x(end)+0.5*h];   % cell face variable (velocity)
    end
    
    % normalise by seg-comp length?
    if xdsc, xp{vi} = xp{vi}./max(delta0(:)); end
end


end

