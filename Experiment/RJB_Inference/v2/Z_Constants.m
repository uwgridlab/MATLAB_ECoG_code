%% CONSTANTS

SIDS = {
    '7662c2', ... 
    '30052b', ...
    '4568f4', ...
    '3745d1', ...
    '26cb98', ...
    'fc9643', ...
    '58411c', ...
    '0dd118', ...
    '7ee6bc', ...
    '38e116', ...
    'f83dbb', ...
};

% change to S1, S2, etc when making final figures
SCODES = {
    '7662c2', ... 
    '30052b', ...
    '4568f4', ...
    '3745d1', ...
    '26cb98', ...
    'fc9643', ...
    '58411c', ...
    '0dd118', ...
    '7ee6bc', ...
    '38e116', ...
    'f83dbb', ...
};

OUTPUT_DIR = fullfile(myGetenv('OUTPUT_DIR'), 'POMDP', 'figures');
TouchDir(OUTPUT_DIR);
META_DIR = fullfile(myGetenv('OUTPUT_DIR'), 'POMDP', 'meta');
TouchDir(META_DIR);

BANDS = [1 4; 4 7; 8 15 ; 16 31; 70 150; 1 10];
BAND_NAMES = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma', 'ERP'};
BAND_TYPE = [1 1 1 1 1 2]; % 1 codes for extract the hilbert amplitude, 0 codes for keep raw time series

N_FOLDS = 10;
PRE_RT_SEC = .25;
FB_RT_SEC = .25;
