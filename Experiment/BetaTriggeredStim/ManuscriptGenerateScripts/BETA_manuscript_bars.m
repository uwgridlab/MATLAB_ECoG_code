%% 3/14/2017 - DJC - script to generate beta stim figures
% based off live script - BetaANOVAmultipleSubj.mlx

close all;clear all;clc
Z_Constants;
SUB_DIR = fullfile(myGetenv('subject_dir'));
OUTPUT_DIR = fullfile(myGetenv('OUTPUT_DIR'));

anovaBetaMags5 = [];
anovaBetaMags3 = [];
anovaBetaMags1 = [];
anovaBetaBase = [];
anovaBetaSID = {};
anovaNumStims = {};
anovaTotalMags = [];
anovaChan = {};
anovaType = {};
answer = input('use zscore or raw values? Enter "zscore" or "raw"  \n','s');

% exclude playback for now
% which
conf = 'CSNESiteVisit';
%conf = 'NeuroModulation';
%conf = 'NeuroModulationV2';

%conf = 'NeuroModulationV3';
%conf = 'NeuroModulationV4';
% 6/17/_2016 try neuromdoulation
for i = 2:length(SIDS)-4
    sid = SIDS{i}
    switch sid
        case 'd5cd55'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',conf,'d5cd55epSTATSsig'))
            stims = [54 62];
            goods = [35 36 37 44 45 46 52 53 55 60 61 63];
            
            betaChan = 53;
            typeCell = {'180'};
            typeCell = {'180'};
            
        case 'c91479'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',conf,'c91479epSTATSsig'))
            betaChan = 64;
            stims = [55 56];
            goods = [38 39 40 46 47 48 62 64];
            
            typeCell = {'180','0'};
            
        case '7dbdec'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',conf,'7dbdecepSTATSsig'))
            stims = [11 12];
            goods = [4 5 10 13 21 22 23];
            
            betaChan = 4;
            typeCell = {'180'};
        case '9ab7ab'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',conf,'9ab7abepSTATSsig'))
            betaChan = 51;
            stims = [59 60];
            goods = [42 43 50 51 52 53 57 58];
            typeCell = {'270'};
        case '702d24'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',conf,'702d24epSTATSsig'))
            betaChan = 5;
            stims = [13 14];
            %                     goods = 5;
            goods = [4 5 6 12 20 21 22];
            
            typeCell = {'270','90'};
            
        case 'ecb43e'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',conf,'ecb43eepSTATSsig'))
            dataForAnova{64} = [];
            CCEPbyNumStim{64} = [];
            ZscoredDataForAnova{64} = [];
            
            betaChan = 55;
            goods = [55 63 54 46 47 48 46];
            stims = [56 64];
            typeCell = {'270','90','Null','Random'};
            
        case '0b5a2e'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',conf,'0b5a2eepSTATSsig'))
            betaChan = 31;
            stims = [22 30];
            goods = [12 13 14 15 16 21 23 31 32 39 40];
            typeCell = {'270','90','Null'};
            
        case '0b5a2ePlayback'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',conf,'0b5a2ePlaybackepSTATSsig'))
            betaChan = 31;
            stims = [22 30];
            goods = [12 13 14 15 16 21 23 31 32 39 40];
            typeCell = {'270','90','Null'};
            
            
    end
    
    %%
    % here's where I pick those channels!
    chan = betaChan;
    chans = betaChan;
    
    % figure out number of test conditions
    numTypes = length(CCEPbyNumStim{betaChan});
    
    if strcmp(sid,'0b5a2e') || strcmp(sid,'0b5a2ePlayback') || strcmp(sid,'ecb43e')
        nullType = 3;
        
    else
        nullType = NaN;
    end
    
    % cells, rather than stacked, of responses for given num stimuli
    
    for chan = chans
        % for each channel, a single stacked vector of all of the responses for a given number of stimuli
        tB = [];
        t1 = [];
        t2 = [];
        t3 = [];
        tN = [];
        
        switch(answer)
            case 'zscore'
                dataForAnova = ZscoredDataForAnova;
            case 'raw'
                
        end
        
        for i = 1:numTypes
            
            if i ~= nullType
                tempMag = dataForAnova{chan}{i}{1};
                tempLabel = dataForAnova{chan}{i}{2};
                tempKeeps = dataForAnova{chan}{i}{3};
                
                tempBase = tempMag(tempLabel(tempKeeps)==0);
                tempResp1 = tempMag(tempLabel(tempKeeps)==1);
                tempResp2 = tempMag(tempLabel(tempKeeps)==2);
                tempResp3 = tempMag(tempLabel(tempKeeps)==3);
                
                
                if (strcmp(conf,'NeuroModulation') | strcmp(conf,'NeuroModulationV2')| strcmp(conf,'NeuroModulationV4')  | strcmp(conf,'NeuroModulationV3')) & strcmp(answer,'zscore')
                    tB = [tB tempBase'];
                    t1 = [t1 tempResp1'];
                    t2 = [t2 tempResp2'];
                    t3 = [t3 tempResp3'];
                else
                    tB = [tB tempBase];
                    t1 = [t1 tempResp1];
                    t2 = [t2 tempResp2];
                    t3 = [t3 tempResp3];
                end
                
                
                lengthType = length(tempBase)+length(tempResp1)+length(tempResp2)+length(tempResp3);
                vecType = repmat(typeCell{i},lengthType,1);
                vecTypeC = cellstr(vecType)';
                anovaType = [anovaType{:} vecTypeC];
                
                % 6-17-2016 - have to transpose for 'conf'
                if (strcmp(conf,'NeuroModulation')| strcmp(conf,'NeuroModulationV4') | strcmp(conf,'NeuroModulationV2')  | strcmp(conf,'NeuroModulationV3')) & strcmp(answer,'zscore')
                    typeResp = [tempResp3' tempResp2' tempResp1' tempBase'];
                else
                    typeResp = [tempResp3 tempResp2 tempResp1 tempBase];
                end
                anovaTotalMags = [anovaTotalMags typeResp];
                num5S = repmat('Ct>=5',length(tempResp3),1);
                num3S= repmat('3<=Ct<=4',length(tempResp2),1);
                num1S = repmat('1<=Ct<=2',length(tempResp1),1);
                numBaseS = repmat('Base',length(tempBase),1);
                
                b5C = cellstr(num5S)';
                b3C = cellstr(num3S)';
                b1C = cellstr(num1S)';
                BC = cellstr(numBaseS)';
                anovaNumStims = [anovaNumStims{:} b5C b3C b1C BC];
            end
        end
        
        % change tihs to just to lnegth(t3) to do the one way anova below
        lengthToRep = length(t3)+length(t2)+length(t1)+length(tB);
        sidString = repmat(sid,lengthToRep,1);
        
        sidCell = cellstr(sidString)';
        
        
        anovaBetaMags5 = [anovaBetaMags5 t3];
        anovaBetaMags3 = [anovaBetaMags3 t2];
        anovaBetaMags1 = [anovaBetaMags1 t1];
        anovaBetaBase = [anovaBetaBase tB] ;
        anovaBetaSID = [anovaBetaSID{:} sidCell];
        
    end
end

%%

[p,tbl,stats] = anovan(anovaTotalMags,{anovaNumStims,anovaBetaSID},'varnames',{'anovaNumStims','anovaBetaSID'},'model','interaction')


[c,m,h,gnames] = multcompare(stats)
[gnames num2cell(m)]

load('line_red.mat');
colors = cm(round(linspace(1, size(cm, 1), length(m))), :);
close all

fig = figure;
for i = 1:length(m)
    gcf
    h = errorbar(i,flip(m(length(m)-i+1,1)),flip(m(length(m)-i+1,2)),'o','linew',3,'color',colors(i,:),'capsize',10)
    
    ylabel('CCEP Magnitude (\muV)','fontsize',14,'fontweight','bold')
    xlabel('Number of Conditioning Pulses','fontsize',14,'fontweight','bold')
    
    set(h, 'MarkerSize', 5, 'MarkerFaceColor', colors(i,:), ...
        'MarkerEdgeColor', colors(i,:));
    hold on
    
    
end
ax = gca;
ax.XTickLabelMode = 'manual';
xlim([0 5])
ax.XTick = [1 2 3 4];
ax.FontSize = 12;
ax.XTickLabel = {'Baseline','1-2','3-4','>5',''}

title({'CCEP Magnitude across Subjects';},'fontsize',16,'fontweight','bold')
[h,icons,plots,legend_text] = legend({'Baseline','1-2','3-4','>5'},'fontsize',12)


%%
figure
results1 = multcompare(stats,'Dimension',[2])


% figure
% results = multcompare(stats,'Dimension',[3])

figure
[cM,mM,hM,gnamesM] = multcompare(stats,'Dimension',[1 2])
errorbar((1:length(mM(:,1))),flip(mM(:,1)),flip(mM(:,2)),'ro','linestyle','none','linew',2','color','r')
ylabel('CCEP Magnitude (\muV)','fontsize',14,'fontweight','bold')
xlabel('Subject subdivided by number of conditioning pulses','fontsize',14,'fontweight','bold')

ax = gca;
ax.XTickLabelMode = 'manual'
ax.XTick = []
%ax.XTickLabel = {'Baseline','1-2','3-4','>5' }
ax.FontSize = 12;
% ax.FontWeight = 'bold';
% set(gca,'XtickLabel',{'','>5','3->4', '1->2','Baseline'},'fontsize',14,'fontweight','bold')
title({'CCEP Magnitude across Subjects';},'fontsize',16,'fontweight','bold')



%% MULTIPLE SUBJECTS
figure
results1 = multcompare(stats,'Dimension',[2]);

figure
[cM,mM,hM,gnamesM] = multcompare(stats,'Dimension',[1 2]);
numSubj = 7;
numDims = 4;
j = 1;

load('line_red.mat');
colors = cm(round(linspace(1, size(cm, 1), length(m))), :);

mMnew = zeros(size(mM));

k = 25;
% reshape mM to match order of subjects 
for i = 0:numSubj-1
    mMnew((4*i+1:(4*i)+4),:) = mM(k:k+3,:);
    k = k - 4;
end

mM = mMnew;

% generate error bars 

for i = 1:length(mM)
    
    if j == 5
        j = 1;
    end
 
    h = errorbar(i,flip(mM(length(mM)-i+1,1)),flip(mM(length(mM)-i+1,2)),'o','linew',3,'color',colors(j,:),'capsize',10);
    ylim([20 140])

    set(h, 'MarkerSize', 5, 'MarkerFaceColor', colors(j,:), ...
        'MarkerEdgeColor', colors(j,:));
    hold on
    
    ax = gca;

    if j ==2
        text(i+0.25,min(mM(:,1))-13,sprintf([num2str(floor(i/4)+1)]),'fontsize',14)
        
    end
    
    if mod(i,4) == 0 & i < 25
       line = vline(i+0.5);
       line.Color = [0.5 0.5 0.5];
    end
    ax.FontSize = 12;    
    j = j+1;
end
ylabel('CCEP Magnitude (\muV)','fontsize',14,'fontweight','bold')
xlabel('Subject subdivided by number of conditioning pulses','fontsize',14,'fontweight','bold')

% set(gca,'XtickLabel',{'','>5','3->4', '1->2','Baseline'},'fontsize',14,'fontweight','bold')
ax.XTickLabelMode = 'manual';
ax.XTick = [];
title({'CCEP Magnitude across Subjects';},'fontsize',16,'fontweight','bold')



[h,icons,plots,legend_text] = legend({'Baseline','1-2','3-4','>5'},'fontsize',12);

