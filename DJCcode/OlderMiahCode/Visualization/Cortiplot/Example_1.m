
% Example use of the PlotCorticalDisplay function
%
%
% Note: this example requires that you've completed the reconstructions for
% deca10.  These are the NEW reconstructions, via
% ReconstructCorticalSurface!

% Load a montage for the data we want to plot.  Note that these montages 
% are automatically generated by ScreenBadChannels.  Montages have the
% following fields:
%   Montage.Montage - [64 16 4]
%      List of each individual strip/subset of electrodes recorded in the
%      montage. For example, a 64 grid, 16 strip and 4 strip would be
%      denoted [64 16 8]
%   Montage.MontageString - 'Grid(:) OF(1:16) AST([1 2 3 8])'
%      Concatenated string of the montage
%   Montage.MontageTokenized - {'Grid(:)','OF(1:16)','AST([1 2 3 8])'}
%      Tokenized cell array of the montage's string
%   Montage.MontageTrodes - [84x3]
%      Exact voxel locations of the electrodes specified in this montage.
%      Note that this is not ALL the electrodes for this subject, just the
%      ones recorded in the montage in the order in which they were
%      recorded. The 18th channel recorded would be located at
%      Montage.MontageTrodes(18,:) on the brain
%   Montage.BadChannels - [12]
%      List of bad channels
%
%   See the exampleMontage.mat file for an example
%

load exampleMontage.mat

% Now we need to establish what datafiles we want loaded so they can be
% available to the callback that's called every time an electrode is drawn.
% This needs to be established beforehand, otherwise we would be loading
% the files every time the callback is run, loading the same dataset N
% times. The example files contain three variables: 'allEpochs' and
% 'allZScores' in the first, and 'stages' in the second. They will both be
% loaded into shared memory. NOTE: Duplicate variables WILL BE OVERWRITTEN.
% If you need to concatenate data (i.e. you have a 40x3 variable in one mat
% and a 20x3 variable in another that you want as a 60x3 variable in the
% callback), you need to do this before you use this function and save the 
% intermediate result yourself.

dataFilesNeededToPlot = {'exampleData1.mat','exampleData2.mat'};

% Now we need to choose the callback. For this example, we're using one
% called c_ExampleCallback.  Open that file to see how it is laid out.
% Note: you don't need to assign it to a temporary variable like this. This
% is just for clarity's sake

callbackFunction = @c_ExampleCallback;

% Now we're on to the main call!  The parameters for PlotCorticalDisplay
% are:
%     
%   PlotCorticalDisplay(subjectID, side, Montage, dataFilesToLoad, callbackFunction, varargin)
%      subjectID - unencoded subject ID, i.e. 'deca10'
%      side - which hemisphere to plot (r/rh/l/lh/b/both)
%      Montage - the montage struct described above
%      dataFilesToLoad - 1xN cell array with the mat files containing the
%         data to plot
%      callbackFunction - a handle to the callback function you want to use
%      varargin - any further parameters are passed directly into the
%         callback function. Useful for plotting specific channels, setting
%         color limits, etc

PlotCorticalDisplay('38e116','r',Montage,dataFilesNeededToPlot,@c_ExampleCallback,[1 0 0]);

