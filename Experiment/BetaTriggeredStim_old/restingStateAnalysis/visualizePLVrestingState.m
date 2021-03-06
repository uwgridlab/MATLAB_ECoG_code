%% DJC 2-11-2016 - script to visualize PLVs within resting state and between resting state
% For use with data generated by PLVBetaRestingStateDJCbatchProcess
% modifiy 9-28-2017 to use different frequency bands, and to have a better
% colorscale

close all;clear all;clc
Z_ConstantsRest
%there appears to be no montage for this subject currently - assume all are
%64 channel grids right now which is fine because it's from TDT recording
% not looking at subject 1 right now

saveFigures = 0;
prePost = 0;
diffs = 1;


%%
for z = 1:length(SIDS)
    sid = SIDS{z};
    switch(sid)
        case 'd5cd55'
            stims = [54 62];
            betaChan = 53;
            Montage.BadChannels = []; % djc - 9-28-2017
            
        case 'c91479'
            stims = [55 56];
            betaChan = 64;
            Montage.BadChannels = []; % djc - 9-28-2017
            
        case '7dbdec'
            stims = [11 12];
            betaChan = 4;
            Montage.BadChannels = []; % djc - 9-28-2017
            
        case '9ab7ab'
            stims = [59 60];
            betaChan = 51;
            Montage.BadChannels = [29]; % djc - 9-28-2017
            
        case '702d24'
            stims = [13 14];
            betaChan = 5;
            Montage.BadChannels = []; % djc - 9-28-2017
            
        case 'ecb43e'
            Montage.BadChannels = [54];
            stims = [56 64];
            betaChan = 55;
            Montage.BadChannels = []; % djc - 9-28-2017
            
        case '0b5a2e'
            stims = [22 30];
            betaChan = 31;
            %Montage.BadChannels = [25 29];
            Montage.BadChannels = [25 29 26 30]; % djc - 9-28-2017
    end
    
    % post load
    subjid = sid;
    
    if prePost
        
        suffixPost = 'postSegmentedShuffled';
        load(fullfile(META_DIR,strcat(subjid,'_',suffixPost)))
        postPLVs = signif_beta_plvs;
        
        
        % pre load
        suffixPre = 'preSegmentedShuffled';
        load(fullfile(META_DIR,strcat(subjid,'_',suffixPre)))
        prePLVs = signif_beta_plvs;
        
        % Pre
        figure
        climsSingle = [0 1];
        imagesc(prePLVs,climsSingle)
        CT=cbrewer('seq', 'RdPu', 16);
        colormap(CT);
        colorbar
        title(['Subject ' num2str(z) ' Significant Pre Stim Beta PLV '])
        xlabel('Channel')
        ylabel('Channel')
        
        highlight(gca,[betaChan-0.5 length(postPLVs)+1],[betaChan-0.5 betaChan+0.5],[0.8 0.8 0.8])
        highlight(gca,[betaChan-0.5 betaChan+0.5],[0 betaChan-0.5],[0.8 0.8 0.8])
        %
        % highlight(gca,[0 betaChan+0.5],[betaChan-0.5 betaChan+0.5],[0.9 0.9 0.9])
        %highlight(gca,[betaChan-0.5 betaChan+0.5],[betaChan-0.5 length(postPLVs)+1],[0.9 0.9 0.9])
        
        gcf;
        if saveFigures
            SaveFig(OUTPUT_DIR, sprintf('prePLV-%s', sid), 'eps', '-r600');
            SaveFig(OUTPUT_DIR, sprintf('prePLV-%s', sid), 'png', '-r600');
        end
        
        
        % Post
        figure
        climsSingle = [0 1];
        imagesc(postPLVs,climsSingle)
        CT=cbrewer('seq', 'RdPu', 16);
        colormap(CT);
        colorbar
        title(['Subject ' num2str(z)  ' Significant Post Stimulation Beta PLV '])
        xlabel('Channel')
        ylabel('Channel')
        
        highlight(gca,[betaChan-0.5 length(postPLVs)+1],[betaChan-0.5 betaChan+0.5],[0.8 0.8 0.8])
        highlight(gca,[betaChan-0.5 betaChan+0.5],[0 betaChan-0.5],[0.8 0.8 0.8])
        
        %highlight(gca,[0 betaChan+0.5],[betaChan-0.5 betaChan+0.5],[0.9 0.9 0.9])
        %highlight(gca,[betaChan-0.5 betaChan+0.5],[betaChan-0.5 length(postPLVs)+1],[0.9 0.9 0.9])
        
        gcf;
        if saveFigures
            
            SaveFig(OUTPUT_DIR, sprintf('postPLV-%s', sid), 'eps', '-r600');
            SaveFig(OUTPUT_DIR, sprintf('postPLV-%s', sid), 'png', '-r600');
        end
        
        
        
    end
    %%
    if diffs
        % difference load
        if strcmp(sid,'0b5a2e')
            suffixDiffs = 'PreVsPost_v2';
        else
            suffixDiffs = 'PreVsPost';
        end
        load(fullfile(META_DIR,strcat(subjid,'_',suffixDiffs)))
        diffsPLV = cat(3,masked_delta_plvdiff2,masked_theta_plvdiff2,masked_alpha_plvdiff2,...
            masked_beta_plvdiff2,masked_gamma_plvdiff2,masked_HG_plvdiff2);
        freqNames = {'delta','theta','alpha','beta','gamma','high gamma'};
        
        % Diffs
        figure
        fig = gcf;
        fig.Units = 'normalized';
        fig.Position = [ -0.0125    0.4227    0.7359    0.5065];
        climsDiff = [-1 1];
        diffsPLV(isnan(diffsPLV)) = 0;
        
        % change bad channels montage DJC
        
        diffsPLV(Montage.BadChannels,:,:) = 0;
        diffsPLV(:,Montage.BadChannels,:) = 0;
        
        for i = 1:length(freqNames)
            subplot(2,3,i)
            
            imagesc(diffsPLV(:,:,i),climsDiff)
            
            CT=flipud(cbrewer('div', 'PuOr', 11));
            colormap(CT);
            h1 = highlight(gca,[betaChan-0.5 length(diffsPLV(:,:,1))+1],[betaChan-0.5 betaChan+0.5],[0.8 0.8 0.8]);
            highlight(gca,[betaChan-0.5 betaChan+0.5],[0 betaChan-0.5],[0.8 0.8 0.8]);
            
            h2 = highlight(gca,[stims(1)-0.5 length(diffsPLV(:,:,1))+1],[stims(1)-0.5 stims(1)+0.5],[0.5 0.5 0.5]);
            highlight(gca,[stims(1)-0.5 stims(1)+0.5],[0 stims(1)-0.5],[0.5 0.5 0.5]);
            
            h3 = highlight(gca,[stims(2)-0.5 length(diffsPLV(:,:,1))+1],[stims(2)-0.5 stims(2)+0.5],[0.5 0.5 0.5]);
            highlight(gca,[stims(2)-0.5 stims(2)+0.5],[0 stims(2)-0.5],[0.5 0.5 0.5]);
            
            
            colorbar
            %  title(['Subject ' num2str(z)  ' Significant differences in Pre-Post ' freqNames{i} ' PLV'])
            title(['Pre-Post ' freqNames{i} ' PLV'])
            
            if i == 6
                legend([h1 h2 h3],{'beta channel','stimulation channel','stimulation channel'},'Location','southwest');
                
            end
            %highlight(gca,[0 betaChan+0.5],[betaChan-0.5 betaChan+0.5],[0.9 0.9 0.9])
            % highlight(gca,[betaChan-0.5 betaChan+0.5],[betaChan-0.5 length(postPLVs)+1],[0.9 0.9 0.9])
            set(gca,'fontsize',14)
        end
        xlabel('Channel')
        ylabel('Channel')
        gcf;
        if saveFigures
            
            SaveFig(OUTPUT_DIR, sprintf('diffsPLV-%s', sid), 'eps', '-r600');
            SaveFig(OUTPUT_DIR, sprintf('diffsPLV-%s', sid), 'png', '-r600');
        end
    end
end