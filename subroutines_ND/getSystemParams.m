function [mySystem, cnst] = getSystemParams(dims,spaceSetting)
disp('requested system parameters');

% START GENERAL SYSTEM PROPERTIES -------------------------------------------
mySystem.params.initialSeed = 1;   % initial random seed, default 1
mySystem.params.useMex = false;    % use MEX compiled subroutines wherever applicable
mySystem.params.debugmode = false; % check consistency in each iteration, computationally expensive
% END SYSTEM PROPERTIES -------------------------------------------

mySystem.params.IMinflRate = 1;

% START INITIALIZE TUMOR CELLS -------------------------------------------
mySystem.params.TUpprol = 0.5055;   % HISTO GENERATED - probability of proliferation
mySystem.params.TUpmig = 0.35;      % probability of migrating, default 0.35
mySystem.params.TUpdeath = 1-(1-0.0319)^4;  % HISTO GENERATED - probability of spontaneous death
mySystem.params.TUpmax = 10;        % max. proliferation capacity, default 10
mySystem.params.TUpblock = 0;       % [added] probability of blocking lymphocyte attack, default 0
mySystem.params.TUps = 0.7;         % probability of symmetric division, default 0.7
% END INITIALIZE TUMOR CELLS ---------------------------------------------

% START INITIALIZE LYMPHOCYTES ------------------------------------------
mySystem.params.IM1kmax = 5;         % killing capacity of immune cells, default 5
mySystem.params.IM1pmax = 10;        % proliferation capacity of immune cells, default 10
mySystem.params.IM1pprol = 0.0449;   % HISTO GENERATED - probability of proliferation
mySystem.params.IM1pmig = 0.8;       % probability of migrating, default 0.7
mySystem.params.IM1pkill = 0.1;      % probability of killing, default 0.1
mySystem.params.IM1pdeath = 1-(1-0.0037)^4;  % HISTO GENERATED - probability of spontaneous death
mySystem.params.IM1rwalk = 0.8;      % random influence on movement, default 0.75
mySystem.params.IM1speed = 97;       % speed of immune cell movement, default 97
mySystem.params.IM1influxProb = 0.3; % probability of immune cell influx, def. 0.72
mySystem.params.IM1inflRate = mySystem.params.IMinflRate;     % how many immune cells appear simultaneously
mySystem.params.engagementDuration = 48; % how many intermed. steps is a killing cell engaged? default 48 (=6 hrs)
% END INITIALIZE LYMPHOCYTES --------------------------------------------

% [added] START INITIALIZE NEW TYPE....? ------------------------------------------
mySystem.params.IM2kmax = 5;         % killing capacity of immune cells, default 5
mySystem.params.IM2pmax = 10;        % proliferation capacity of immune cells, default 10
mySystem.params.IM2pprol = 0.0449;   % HISTO GENERATED - probability of proliferation
mySystem.params.IM2pmig = 0.8;       % probability of migrating, default 0.7
mySystem.params.IM2pkill = 0.1;      % probability of killing, default 0.1
mySystem.params.IM2pdeath = 1-(1-0.0037)^4;  % HISTO GENERATED - probability of spontaneous death
mySystem.params.IM2rwalk = 0.8;      % random influence on movement, default 0.75
mySystem.params.IM2speed = 97;       % speed of immune cell movement, default 97
mySystem.params.IM2influxProb = 0.3;   % probability of immune cell influx, def. 0
mySystem.params.IM2inflRate = mySystem.params.IMinflRate;     % how many immune cells appear simultaneously
mySystem.params.engagementDuration = 48; % how many intermed. steps is a killing cell engaged? default 48 (=6 hrs)
% END INITIALIZE NEW TYPE....? --------------------------------------------

% START INITIALIZE NECROSIS AND FIBROSIS  ---------------------------------
mySystem.params.distMaxNecr = 134;     % if necrosis occurs, then it occurs within 2 mm (134 = approx. 2 mm)
mySystem.params.probSeedNecr = 0.00004; % seed necrosis
mySystem.params.probSeedFibr = 0.00025;   % probability of turning into fibrosis
seedFrac = 0.3;
mySystem.params.necrFrac = seedFrac;  % size of necrotic seed, 0...1, default 0.3
mySystem.params.fibrFrac = seedFrac;  % size of fibrotic seed, 0...1, default 0.3
mySystem.params.stromaPerm = 0.0025;        % 0 = stroma not permeable, 1 = fully permeable
% END INITIALIZE NECROSIS AND FIBROSIS  ---------------------------------

% [added] START DEFINING IMMUNOTHERAPY CONSTANTS -----------------------------------------
mySystem.params.effImmuno = 0; % efficacy of immunotherapy, also dependend on amount of receptors, default 0 (no immunotherapy)
% END DEFINING IMMUNOTHERAPY CONSTANTS -----------------------------------------

% START DEFINING ADDITIONAL CONSTANTS -----------------------------------
cnst.verbose = true;            % draw intermediary steps? default true
cnst.createNewSystem = true;    % create new system at the start, default true
cnst.saveImage = true;          % save image directly after each iteration, default true
cnst.doImage = false;           % plot result again afterwards, default false
cnst.doVideo = false;           % create a video afterwards, default false
cnst.doSummary = true;          % summarize the result, default true
cnst.inTumor = 1;               % defines "in tumor" ROI, default 1
cnst.marginSize = 5;            % default "invasive margin" ROI, default 5
cnst.around = 120;              % defines "adjacent tissue" ROI, default 120 = 1 mm
cnst.requireAlive = 150;        % require tumor to be alive for some time
% END DEFINING ADDITIONAL CONSTANTS -----------------------------------

% START DEFINING DIMENSION VARIABLES  -----------------------------------
if strcmp(dims,'2D') % parameters that are specific for 2D
defRadius = 4;
mySystem.params.smoothSE = strel('disk',defRadius); % smoothing structuring element for region growth
mySystem.params.fillSE = strel('disk',defRadius); % smoothing structure for hypoxia map
mySystem.grid.N = spaceSetting(1);  % domain dimension vertical, default 380
mySystem.grid.M = spaceSetting(2);  % domain dimension horizontal, default 380
mySystem.params.mycellsize = 7;   % ball size in scatter plot, default 7

elseif strcmp(dims,'3D') % parameters that are specific for 3D
mySystem.params.smoothSE = ones(3,3,3); % smoothing structuring element for region growth
mySystem.grid.N = spaceSetting(1);  % domain dimension 1, default 80
mySystem.grid.M = spaceSetting(2);  % domain dimension 2, default 50
mySystem.grid.P = spaceSetting(3);  % domain dimension 3, default 30

else
    error('dimension must be 2D or 3D')
end

% START PLAUSIBILITY CHECK ----------------------------------------------
checkPlausibility(mySystem);
% END PLAUSIBILITY CHECK ------------------------------------------------

end