SIDS = {'8adc5c', 'd5cd55', 'c91479', '7dbdec', '9ab7ab', '702d24', 'ecb43e','0b5a2e','0b5a2ePlayback','0a80cf'};

OUTPUT_DIR = fullfile(myGetenv('OUTPUT_DIR'), 'LarryDavidStephen', 'output');
TouchDir(OUTPUT_DIR);
META_DIR = fullfile(myGetenv('OUTPUT_DIR'), 'LarryDavidStephen', 'meta');
TouchDir(META_DIR);

%OUTPUT_DIR = char(System.IO.Path.GetFullPath(OUTPUT_DIR)); % modified DJC 7-23-2015 - temporary fix to save figures