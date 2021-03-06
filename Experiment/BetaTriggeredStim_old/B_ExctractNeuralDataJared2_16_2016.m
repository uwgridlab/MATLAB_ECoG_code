%% Constants
close all; clear all;clc
cd 'C:\Users\David\Desktop\Research\RaoLab\MATLAB\Code\Experiment\BetaTriggeredStim'
Z_Constants;
addpath ./scripts/ %DJC edit 7/20/2015;

%% parameters
% FOR 0b5a2e
% need to be fixed to be nonspecific to subject
% SIDS = SIDS(2:end);
SIDS = SIDS(9);

for idx = 1:length(SIDS)
    sid = SIDS{idx};
    %DJC edited 7/20/2015 to fix tp paths
    switch(sid)
        case '8adc5c'
            % sid = SIDS{1};
            tp = 'D:\Subjects\8adc5c\data\D6\8adc5c_BetaTriggeredStim';
            block = 'Block-67';
            stims = [31 32];
            chans = [8 7 48];
        case 'd5cd55'
            % sid = SIDS{2};
            tp = 'D:\Subjects\d5cd55\data\D8\d5cd55_BetaTriggeredStim';
            block = 'Block-49';
            stims = [54 62];
            chans = [53 61 63];
        case 'c91479'
            % sid = SIDS{3};
            tp = 'D:\Subjects\c91479\data\d7\c91479_BetaTriggeredStim';
            block = 'BetaPhase-14';
            stims = [55 56];
            chans = [64 63 48];
        case '7dbdec'
            % sid = SIDS{4};
            tp = 'D:\Subjects\7dbdec\data\d7\7dbdec_BetaTriggeredStim';
            block = 'BetaPhase-17';
            stims = [11 12];
            chans = [4 5 14];
        case '9ab7ab'
            %             sid = SIDS{5};
            tp = 'D:\Subjects\9ab7ab\data\d7\9ab7ab_BetaTriggeredStim';
            block = 'BetaPhase-3';
            stims = [59 60];
            chans = [51 52 53 58 57];
            % chans = 29;
        case '702d24'
            tp = 'D:\Subjects\702d24\data\d7\702d24_BetaStim';
            block = 'BetaPhase-4';
            stims = [13 14];
            chans = [4 5 21];
        case 'ecb43e' % added DJC 7-23-2015
            tp = 'D:\Subjects\ecb43e\data\d7\BetaStim';
            block = 'BetaPhase-3';
            stims = [56 64];
            chans = [47 55];
        case '0b5a2e' % added DJC 7-23-2015
            tp = 'D:\Subjects\0b5a2e\data\d8\0b5a2e_BetaStim\0b5a2e_BetaStim';
            block = 'BetaPhase-2';
            stims = [22 30];
            %             chans = [23 31 21 14 15 32 40];
            % DJC 2-5-2016 - prototype just on channel 23
            %             chans = [1:64];
            chans = 23;
        case '0b5a2ePlayback' % added DJC 7-23-2015
            tp = 'D:\Subjects\0b5a2e\data\d8\0b5a2e_BetaStim\0b5a2e_BetaStim';
            block = 'BetaPhase-4';
            stims = [22 30];
            %             chans = [23 31 21 14 15 32 40];
            %             chans = [23 31];
            chans = 23;
            
        otherwise
            error('unknown SID entered');
    end
    
    chans(ismember(chans, stims)) = [];
    
    %% load in the trigger data
    % 9-2-2015 DJC added mod DJC
    
    tank = TTank;
    tank.openTank(tp);
    tank.selectBlock(block);
    
    if strcmp(sid,'0b5a2ePlayback')
        load(fullfile(META_DIR, ['0b5a2e' '_tables_modDJC.mat']), 'bursts', 'fs', 'stims');
        
        % this was for discovering the delay, now it's known to be about
        % 577869
        %         tic;
        %         [smon, info] = tank.readWaveEvent('SMon', 2);
        %         smon = smon';
        %
        %         fs = info.SamplingRateHz;
        %
        %         stim = tank.readWaveEvent('SMon', 4)';
        %         toc;
        %
        %         tic;
        %         mode = tank.readWaveEvent('Wave', 2)';
        %         ttype = tank.readWaveEvent('Wave', 1)';
        %
        %         beta = tank.readWaveEvent('Blck', 1)';
        %
        %         raw = tank.readWaveEvent('Blck', 2)';
        %
        %         toc;
        
        delay = 577869;
    else
        
        % below is for original miah style burst tables
        %         load(fullfile(META_DIR, [sid '_tables.mat']), 'bursts', 'fs', 'stims');
        % below is for modified burst tables
        load(fullfile(META_DIR, [sid '_tables_modDJC.mat']), 'bursts', 'fs', 'stims');
    end
    % drop any stims that happen in the first 500 milliseconds
    stims(:,stims(2,:) < fs/2) = [];
    
    % drop any probe stimuli without a corresponding pre-burst/post-burst
    bads = stims(3,:) == 0 & (isnan(stims(4,:)) | isnan(stims(6,:)));
    stims(:, bads) = [];
    
    
    % adjust stim and burst tables for 0b5a2e playback case
    
    if strcmp(sid,'0b5a2ePlayback')
        
        stims(2,:) = stims(2,:)+delay;
        bursts(2,:) = bursts(2,:) + delay;
        bursts(3,:) = bursts(3,:) + delay;
        
    end
    
    
    
    figure
    %% process each ecog channel individually
    
    sigChans = {};
    
    for chan = chans
        
        %% load in ecog data for that channel
        fprintf('loading in ecog data:\n');
        tic;
        grp = floor((chan-1)/16);
        ev = sprintf('ECO%d', grp+1);
        achan = chan - grp*16;
        
        %         [eco, efs] = tdt_loadStream(tp, block, ev, achan);
        [eco, info] = tank.readWaveEvent(ev, achan);
        efs = info.SamplingRateHz;
        eco = eco';
        
        toc;
        
        fac = fs/efs;
        
        %% preprocess eco
        %             presamps = round(0.050 * efs); % pre time in sec
        % pre time
        presamps = round(0.025 * efs); % pre time in sec
        
        % if doing zscore, try 0.3, otherwise .120 is good. Looks like
        % conditioning stimuli sometimes begin around 80 ms after? so if
        % you zscore normalize bad news bears
        postsamps = round(0.120 * efs); % post time in sec, % modified DJC to look at up to 300 ms after
        
        sts = round(stims(2,:) / fac);
        edd = zeros(size(sts));
        
        
        temp = squeeze(getEpochSignal(eco', sts-presamps, sts+postsamps+1));
        foo = mean(temp,2);
        lastsample = round(0.040 * efs);
        foo(lastsample:end) = foo(lastsample-1);
        
        last = find(abs(zscore(foo))>1,1,'last');
        last2 = find(abs(diff(foo))>30e-6,1,'last')+1;
        
        zc = false;
        
        if (isempty(last2))
            if (isempty(last))
                error ('something seems wrong in the triggered average');
            else
                ct = last;
            end
        else
            if (isempty(last))
                ct = last2;
            else
                ct = max(last, last2);
            end
        end
        % try getting rid of this part for 0b5a2e to conserve that initial
        % spike DJC 1-7-2016
        while (~zc && ct <= length(foo))
            zc = sign(foo(ct-1)) ~= sign(foo(ct));
            ct = ct + 1;
        end
        % consider 3 ms? DJC - 1-5-2016
        if (ct > max(last, last2) + 0.10 * efs) % marched along more than 10 msec, probably gone to far
            ct = max(last, last2);
        end
        
        % DJC - 8-31-2015 - i believe this is messing with the resizing
        % in the figures
        %             subplot(8,8,chan);
        %             plot(foo);
        %             vline(ct);
        %
        for sti = 1:length(sts)
            win = (sts(sti)-presamps):(sts(sti)+postsamps+1);
            
            %             interpolation approach
            eco(win(presamps:(ct-1))) = interp1([presamps-1 ct], eco(win([presamps-1 ct])), presamps:(ct-1));
        end
        % %         tried doing 1-200 rather than 1-40 - DJC 1-7-2016
        %                         eco = toRow(bandpass(eco, 1, 40, efs, 4, 'causal'));
        %                 eco = toRow(notch(eco, 60, efs, 2, 'causal'));
        %
        %% process triggers
        
        if (strcmp(sid, '8adc5c'))
            pts = stims(3,:)==0;
        elseif (strcmp(sid, 'd5cd55'))
            %         pts = stims(3,:)==0 & (stims(2,:) > 4.5e6);
            pts = stims(3,:)==0 & (stims(2,:) > 4.5e6) & (stims(2, :) > 36536266);
        elseif (strcmp(sid, 'c91479'))
            pts = stims(3,:)==0;
        elseif (strcmp(sid, '7dbdec'))
            pts = stims(3,:)==0;
        elseif (strcmp(sid, '9ab7ab'))
            pts = stims(3,:)==0;
        elseif (strcmp(sid, '702d24'))
            pts = stims(3,:)==0;
            %modified DJC 7-27-2015
        elseif (strcmp(sid, 'ecb43e'))
            pts = stims(3,:) == 0;
        elseif (strcmp(sid, '0b5a2e'))
            pts = stims(3,:) == 0;
        elseif (strcmp(sid, '0b5a2ePlayback'))
            pts = stims(3,:) == 0;
        else
            error 'unknown sid';
        end
        
        
        %         presamps = round(0.10 * efs); % pre time in sec
        
        % if doing zscore, try 0.3, otherwise .120 is good. Looks like
        % conditioning stimuli sometimes begin around 80 ms after? so if
        % you zscore normalize bad news bears
        %         postsamps = round(0.120 * efs); % post time in sec, % modified DJC to look at up to 300 ms after
        
        ptis = round(stims(2,pts)/fac);
        
        t = (-presamps:postsamps)/efs;
        
        
        wins = squeeze(getEpochSignal(eco', ptis-presamps, ptis+postsamps+1));
        %     awins = adjustStims(wins);
        % normalize the windows to each other, using pre data
        awins = wins-repmat(mean(wins(t<0,:),1), [size(wins, 1), 1]);
        %         awins = wins;
        
        pstims = stims(:,pts);
        
        % calculate EP statistics
        stats = quantifyEPs(t, awins);
        
        
        % considered a baseline if it's been at least N seconds since the last
        % burst ended
        
        baselines = pstims(5,:) > 2 * fs;
        
        % modified 9-10-2015 - DJC, find pre condition for each type of
        % test pulse
        
        %         pre = pstims(7,:) < 0.250*fs;
        
        if (sum(baselines) < 100)
            warning('N baselines = %d.', sum(baselines));
        end
        
        types = unique(bursts(5,pstims(4,:)));
        
        %DJC - modify suffix to list conditioning type
        suffix = arrayfun(@(x) num2str(x), types, 'uniformoutput', false);
        %
        suffix = cell(1,3);
        suffix{1} = 'Negative phase of Beta';
        suffix{2} = 'Positive phase of Beta';
        suffix{3} = 'Null Condition';
        
        
        nullType = 2;
        % .250 originally
        
        for typei = 1:length(types)
            if (types(typei) == nullType)
                probes = pstims(5,:) < .250*fs & bursts(5,pstims(4,:))==types(typei);
                if (sum(probes) < 100)
                    warning('N probes = %d.', sum(probes));
                end
                label = bursts(4,pstims(4,:));
                label(baselines) = 0;
                
                label(probes) = 1 ;
                
                keeps = probes | baselines;
                
                load('line_colormap.mat');
                kwins = awins(:, keeps);
                klabel = label(keeps);
                ulabels = unique(klabel);
                colors = cm(round(linspace(1, size(cm, 1), length(ulabels))), :);
                
                %%
                % move stats up here DJC 2-11-2016 in order to only plot if
                % significant
                
                a1 = 1e6*min((awins(t>0.010 & t < 0.030,keeps)));
                a1NullMean = mean(a1);
                a1 = a1 - mean(a1(label(keeps)==0));
                [anovaNull,tableNull,statsNull] = anova1(a1', label(keeps), 'off');
                [cNull,mNull,hNull,gnamesNull] = multcompare(statsNull,'display','off');
                
                figure
                % this sets the figure to be the whole screen
                %                     set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                %                     subplot(3,1,1);
                
                % try subtracting the mean, other idea is to build two
                % distributions from zscore
                % 2-4-2016 - DJC post conversation with Miah
                
                
                % original
                prettyline(1e3*t,1e6*awins(:, keeps), label(keeps), colors);
                xlim(1e3*[-0.025 max(t)]);
                
                %                     xlim(1e3*[min(t) max(t)]);
                yl = ylim;
                yl(1) = min(-10, max(yl(1),-140));
                yl(2) = max(10, min(yl(2),100));
                ylim(yl);
                ylim([-80 70])
                
                highlight(gca, [0 t(ct)*1e3], [], [.5 .5 .5]) %this is the part that plots that stim window
                vline(0);
%                 xlabel('time (ms)');
%                 ylabel('ECoG (uV)');
                %                 title(sprintf('EP By N_{CT}: %s, %d, {%s}', sid, chan, suffix{typei}))
%                 title(sprintf('Null Condition'))
                leg = {'Baseline','Test Pulse'};
                
                leg{end+1} = 'Stim Window';
                %     leg{end+1} = 'EP_P';
                legend(leg, 'location', 'Southeast')
                set(gca,'fontsize',18)
                set(gca,'fontsize',18,'XTickLabel','','YTickLabel','')

%                 NumTicks = 5;
%                 L = get(gca,'XLim');
%                 set(gca,'XTick',linspace(L(1),L(2),NumTicks))
%                 NumTicks = 4;
%                 L = get(gca,'YLim');
%                 set(gca,'YTick',linspace(L(1),L(2),NumTicks))
%                 

                
                % try subtracting mean of baselines, DJC 2-4-2016, post
                % convo with miah
                %                     subplot(3,1,2)
                %
                %                     prettyline(1e3*t, bsxfun(@minus,1e6*awins(:, keeps),1e6*mean(awins(:,baselines),2)), label(keeps), colors);
                %
                %                     % try zscore?
                %                     %                                 prettyline(1e3*t((1e3*t)>10), zscore(1e6*awins((1e3*t)>10, keeps)), label(keeps), colors);
                %                     %     ylim([-130 50]);
                %
                %                     % changed DJC 1-7-2016 to look at -8 to 80
                %                     xlim(1e3*[-0.025 max(t)]);
                %                     xlim(1e3*[min(t) max(t)]);
                %                     %                 xlim([-5 300]);
                %
                %                     %     vline([6 20 40], 'k');
                %                     %     highlight(gca, [25 33], [], [.6 .6 .6])
                %                     %             highlight(gca, [0 4], [], [.3 .3 .3]);
                %                     %             vline(0.030*1e3);
                %                     %             vline(0.080*1e3);
                %                     yl = ylim;
                %                     yl(1) = min(-10, max(yl(1),-140));
                %                     yl(2) = max(10, min(yl(2),100));
                %                     ylim(yl);
                %                     % DJC - ylim for zscores
                %                     %                                 ylim([-2 2])
                %
                %                     % DJC set highlight to 1 1 1 to block it out
                %                     highlight(gca, [0 t(ct)*1e3], [], [.5 .5 .5]) %this is the part that plots that stim window
                %                     vline(0);
                %                     %                 vline(80);
                %
                %
                %                     xlabel('time (ms)');
                %                     ylabel('ECoG (uV)');
                %                     %                 title(sprintf('EP By N_{CT}: %s, %d, {%s}', sid, chan, suffix{typei}))
                %                     title('Mean Subtracted')
                %                     %                     leg = {'Pre','Post'};
                %                     %
                %                     %                     leg{end+1} = 'Stim Window';
                %                     %                     %     leg{end+1} = 'EP_P';
                %                     %                     legend(leg, 'location', 'Southeast')
                %
                %
                %                     %% added DJC 2-11-2016 to try and do quick stats
                %
                %                     subplot(3,1,3)
                %                     %                 figure
                %                     prettybar(a1, label(keeps), colors, gcf);
                %                     set(gca, 'xtick', []);
                %                     ylabel('\DeltaEP_N (uV)');
                %                     title(sprintf('Change in EP_N by N_{CT}: One-Way Anova F=%4.2f p=%0.4f', tableNull{2,5}, tableNull{2,6}));
                % %                                     figure
                % %                                     figure
                % %                                     [pNull,tblNull,statsNull] = kruskalwallis(a1',label(keeps));
                % %
                
                SaveFig(OUTPUT_DIR, sprintf(['epSTATS-%s-%dUNFILT2-17' suffix{typei}], sid, chan), 'eps', '-r600');
                SaveFig(OUTPUT_DIR, sprintf(['epSTATS-%s-%dUNFILT2-17' suffix{typei}], sid, chan), 'png', '-r600');
                
                
            elseif (types(typei) ~= nullType)
                %     % if (all)
                %     probes = pstims(5,:) < .250*fs;
                %     % if (falling)
                probes = pstims(5,:) < .250*fs & bursts(5,pstims(4,:))==types(typei);
                %     if (rising)
                %         probes = pstims(5,:) < .250*fs * bursts(5,pstims(4,:))==1;
                
                if (sum(probes) < 100)
                    warning('N probes = %d.', sum(probes));
                end
                
                label = bursts(4,pstims(4,:));
                label(baselines) = 0;
                %modify this to change groupings/stratifications - djc 8/31/2015
                
                labelGroupStarts = [1 3 5];
                %                                 labelGroupStarts = 1:10;
                %     labelGroupStarts = 1:5;
                labelGroupEnds   = [labelGroupStarts(2:end) Inf];
                
                for gIdx = 1:length(labelGroupStarts)
                    labeli = label >= labelGroupStarts(gIdx) & label < labelGroupEnds(gIdx);
                    label(labeli) = gIdx;
                end
                
                keeps = probes | baselines;
                
                %     lows = awins(awins==repmat(min(awins(180:320,keeps)), size(awins,1), 1));
                %     figure
                %     scatter(jitter(label, 0.1), lows)
                
                
                load('line_colormap.mat');
                kwins = awins(:, keeps);
                klabel = label(keeps);
                ulabels = unique(klabel);
                colors = cm(round(linspace(1, size(cm, 1), length(ulabels))), :);
                
                %%
                a1 = 1e6*min((awins(t>0.010 & t < 0.030,keeps)));
                a1CondMean = mean(a1);
                a1 = a1 - mean(a1(label(keeps)==0));
                [anovaResultCond,tableCond,statsCond] = anova1(a1', label(keeps), 'off');
                [cCond,mCond,hCond,gnamesCond] = multcompare(statsCond,'display','off');
                
                figure
                
                % original
                prettyline(1e3*t,1e6*awins(:, keeps), label(keeps), colors);
                %
                %                 % try subtracting mean of baselines, DJC 2-4-2016, post
                %                 % convo with miah
                xlim(1e3*[-0.025 max(t)]);
                
                %                     xlim(1e3*[min(t) max(t)]);
                yl = ylim;
                yl(1) = min(-10, max(yl(1),-140));
                yl(2) = max(10, min(yl(2),100));
                ylim(yl);
                ylim([-80 70])
                highlight(gca, [0 t(ct)*1e3], [], [.5 .5 .5]) %this is the part that plots that stim window
                vline(0);
%                 xlabel('time (ms)');
%                 ylabel('ECoG (uV)');
                %                 title(sprintf('EP By N_{CT}: %s, %d, {%s}', sid, chan, suffix{typei}))
                %                     title(sprintf('{%s}',suffix{typei}))
%                 title(sprintf('{%s}',suffix{typei}))
                
                leg = {'Baseline'};
                leg{end+1} = '1-2';
                leg{end+1} = '3-4';
                leg{end+1} = '>5';
%                 for d = 1:length(labelGroupStarts)
%                     if d == length(labelGroupStarts)
%                         leg{end+1} = sprintf('%d<=CT', labelGroupStarts(d));
%                     else
%                         leg{end+1} = sprintf('%d<=CT<%d', labelGroupStarts(d), labelGroupEnds(d));
%                     end
%                 end
                leg{end+1} = 'Stim Window';
                %     leg{end+1} = 'EP_P';
                legend(leg, 'location', 'Southeast')
                set(gca,'fontsize',18,'XTickLabel','','YTickLabel','')
                
%                 NumTicks = 6;
%                 L = get(gca,'XLim');
%                 set(gca,'XTick',linspace(L(1),L(2),NumTicks))
%                 
%                 NumTicks = 4;
%                 L = get(gca,'YLim');
%                 set(gca,'YTick',linspace(L(1),L(2),NumTicks))
                
                %
                % try zscore?
                %                                 prettyline(1e3*t((1e3*t)>10), zscore(1e6*awins((1e3*t)>10, keeps)), label(keeps), colors);
                %     ylim([-130 50]);
                
                % second mean subtracted
                
                %                     subplot(3,1,2)
                %                     prettyline(1e3*t, bsxfun(@minus,1e6*awins(:, keeps),1e6*mean(awins(:,baselines),2)), label(keeps), colors);
                %
                %
                %                     % changed DJC 1-7-2016
                %                     xlim(1e3*[-0.025 max(t)]);
                %
                % %                     xlim(1e3*[min(t) max(t)]);
                %                     %                 xlim([-5 300]);
                %                     %     vline([6 20 40], 'k');
                %                     %     highlight(gca, [25 33], [], [.6 .6 .6])
                %                     %             highlight(gca, [0 4], [], [.3 .3 .3]);
                %                     %             vline(0.030*1e3);
                %                     %             vline(0.080*1e3);
                %                     yl = ylim;
                %                     yl(1) = min(-10, max(yl(1),-140));
                %                     yl(2) = max(10, min(yl(2),100));
                %                     ylim(yl);
                %                     highlight(gca, [0 t(ct)*1e3], [], [.5 .5 .5]) %this is the part that plots that stim window
                %                     vline(0);
                %                     %                 vline(80);
                %
                %                     % DJC - 2-11-2016 - set y limits for z-score
                %                     %                 ylim([-2 2])
                %
                %                     xlabel('time (ms)');
                %                     ylabel('ECoG (uV)');
                %                     title('Mean Subtracted')
                %
                %                     %                 title(sprintf('EP By N_{CT}: %s, %d, {%s}', sid, chan, suffix{typei}))
                %                     %                     title(sprintf('%s CCEPs for Channel %d stimuli in {%s}',sid,chan,suffix{typei}))
                %                     %                     leg = {'Pre'};
                %                     %                     for d = 1:length(labelGroupStarts)
                %                     %                         if d == length(labelGroupStarts)
                %                     %                             leg{end+1} = sprintf('%d<=CT', labelGroupStarts(d));
                %                     %                         else
                %                     %                             leg{end+1} = sprintf('%d<=CT<%d', labelGroupStarts(d), labelGroupEnds(d));
                %                     %                         end
                %                     %                     end
                %                     %                     leg{end+1} = 'Stim Window';
                %                     %                     %     leg{end+1} = 'EP_P';
                %                     %                     legend(leg, 'location', 'Southeast')
                %                     %
                %
                %                     %% added DJC 2-11-2016 to try and do quick stats
                %                     % start with negative surface deflection 10 -> 30
                %
                %
                %                     %                 figure
                %                     subplot(3,1,3)
                %                     prettybar(a1, label(keeps), colors, gcf);
                %                     set(gca, 'xtick', []);
                %                     ylabel('\DeltaEP_N (uV)');
                %
                %                     title(sprintf('Change in EP_N by N_{CT}: One-Way Anova F=%4.2f p=%0.4f', tableCond{2,5}, tableCond{2,6}));
                % %                                     figure
                % %                                     [pCond,tblCond,statsCond] = kruskalwallis(a1',label(keeps));
                %
                SaveFig(OUTPUT_DIR, sprintf(['epSTATS-%s-%dUNFILT2-17' suffix{typei}], sid, chan), 'eps', '-r600');
                SaveFig(OUTPUT_DIR, sprintf(['epSTATS-%s-%dUNFILT2-17' suffix{typei}], sid, chan), 'png', '-r600');
            end
        end
        %         sigChans{chan} = {mCond cCond a1CondMean mNull cNull a1NullMean};
        %         save(fullfile(OUTPUT_DIR, [sid 'epSTATSsig.mat']), 'sigChans');
    end
end
