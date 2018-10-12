%% script to plot phase distributions of beta triggered stim signal
% takes in fit signals from all subjects, for all channels, and generates
% plots

% David.J.Caldwell 8.26.2018
%%
%close all;clear all;clc
baseDir = 'C:\Users\djcald.CSENETID\Data\Output\BetaTriggeredStim\PhaseDelivery';
addpath(baseDir);

OUTPUT_DIR = 'C:\Users\djcald.CSENETID\Data\Output\BetaTriggeredStim\PhaseDelivery\plots';
TouchDir(OUTPUT_DIR);

SIDS = {'d5cd55','c91479','7dbdec','9ab7ab','702d24','ecb43e','0b5a2e','0b5a2ePlayback'};
valueSet = {{'s',180,1,[54 62],[1 49 58 59],53},...
    {'m',[0 180],2,[55 56],[2 3 31 57],64},...
    {'s',180,3,[11 12],[57],4},...
    {'s',270,4,[59 60],[1 9 10 35 43],51},...
    {'m',[90,270],5,[13 14],[23 27 28 29 30 32 44 52 60],5},...
    {'m',[90,180],6,[56 64],[57:64],55},...
    {'m',[90,270],7,[22 30],[24 25 29],31},...
    {'m',[90,270],8,[22 30],[24 25 29],31}};
M = containers.Map(SIDS,valueSet,'UniformValues',false);
%SIDS = {'0b5a2ePlayback'}
SIDS = {'d5cd55'};
modifier = '_51samps_12_20_60ms_randomstart';
modifier = '_51samps_12_20_40ms_randomstart';

%SIDS = {'d5cd55','c91479','7dbdec','9ab7ab'};
%SIDS = {'c91479'}
%gcp;  %parallel pool
%
% settings
hilbPlot = 0;
acausalPlot = 0;
rawPlot = 1;
saveIt = 0;
closeAll = 0;

% don't plot direction of magnitude of phase difference
magnitudeOnly = 1;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for sid = SIDS
    sid = sid{:};
    info = M(sid);
    type = info{1};
    subjectNum = info{3};
    desiredF = info{2};
    stims = info{4};
    bads = info{5};
    betaChan = info{6};
    chans = [1:64];
    badsTotal = [stims bads];
    chans(ismember(chans, badsTotal)) = [];
    Montage.MontageTokenized = {'Grid(1:64)'};
    
    %      load([sid '_phaseDelivery_allChans_51samps.mat']);
    
    load([sid '_phaseDelivery_allChans' modifier '.mat']);
    
    fprintf(['running for subject ' sid '\n']);
    
    if strcmpi(sid,'0b5a2eplayback')
        locs = trodeLocsFromMontage('0b5a2e', Montage, false);
        sid = '0b5a2e';
    else
        locs = trodeLocsFromMontage(sid, Montage, false);
    end
    
    markerMin = 5;
    markerMax = 30;
    minData = -1;
    maxData = 1;
    
    threshold = 0;
    
    %%
    if strcmp(type,'m')
        %%
        if rawPlot
            signalType = 'unfiltered';
            
            plot_phase_cortex(r_square_pos,threshold,phase_at_0_pos,signalType,desiredF(1),markerMin,...
                markerMax,[],[],sid,subjectNum,locs,chans,badsTotal,betaChan,magnitudeOnly)
            
            plot_phase_cortex(r_square_neg,threshold,phase_at_0_neg,signalType,desiredF(2),markerMin,...
                markerMax,[],[],sid,subjectNum,locs,chans,badsTotal,betaChan,magnitudeOnly)
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if acausalPlot
            signalType = 'filtered';
            
            plot_phase_cortex(r_square_pos_acaus,threshold,phase_at_0_pos_acaus,signalType,desiredF(1),markerMin,...
                markerMax,minData,maxData,sid,subjectNum,locs,chans,badsTotal,betaChan,magnitudeOnly)
            
            rSquareThresh_neg = (r_square_neg) > threshold;
            plot_phase_cortex(r_square_neg_acaus,threshold,phase_at_0_neg_acaus,signalType,desiredF(2),markerMin,...
                markerMax,[],[],sid,subjectNum,locs,chans,badsTotal,betaChan,magnitudeOnly)
            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    elseif strcmp(type,'s')
        %%
        if rawPlot
            signalType = 'unfiltered';
            
            plot_phase_cortex(r_square,threshold,phase_at_0,signalType,desiredF,markerMin,...
                markerMax,[],[],sid,subjectNum,locs,chans,badsTotal,betaChan,magnitudeOnly)
            
            
            %   objhl = findobj(objh, 'type', 'patch'); % objects of legend of type patch
            %set(objhl, 'Markersize', 12); % set marker size as desired
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if acausalPlot
            %%
            signalType = 'filtered';
            
            plot_phase_cortex(r_square_acaus,threshold,phase_at_0_acaus,signalType,desiredF,markerMin,...
                markerMax,[],[],sid,subjectNum,locs,chans,badsTotal,betaChan,magnitudeOnly)
            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

