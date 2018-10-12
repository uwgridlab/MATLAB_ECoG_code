%% Multisubject analysis with general linear mixed model
% peak to peak values used
% 
% David.J.Caldwell 9.19.2018

%close all;clear all;clc
clear all
Z_Constants;
SUB_DIR = fullfile(myGetenv('subject_dir'));
OUTPUT_DIR = fullfile(myGetenv('OUTPUT_DIR'));

%% parameters


SIDS = {'d5cd55','c91479','7dbdec','9ab7ab','702d24','ecb43e','0b5a2e','0b5a2ePlayback'};
valueSet = {{'s',180,1,[54 62],[1 49 58 59],[44 45 46 47 48 52 53 55 60 61 63],53},2.5,...
    {'m',[0 180],2,[55 56],[1 2 3 31 57],[31 39 40 47 48 63 64],64},3,...
    {'s',180,3,[11 12],[57],[4 5 10 13 18 19 20],4},3.5,...
    {'s',270,4,[59 60],[1 9 10 35 43],[41 42 43 44 45 49 50 51 52 53 57 58 61 62],51},0.75,...
    {'m',[90,270],5,[13 14],[23 27 28 29 30 32 44 52 60],[5],5},0.75,...
    {'t',[90,180],6,[56 64],[57:64],[46 48 54 55 63],55},1.75...
    {'m',[90,270],7,[22 30],[24 25 29],[13 14 15 16 20 21 23 24 29 31 32 39 40],31},...
    {'m',[90,270],8,[22 30],[24 25 29],[13 14 15 16 20 21 23 24 29 31 32 39 40],31}};
M = containers.Map(SIDS,valueSet,'UniformValues',false);
%%

BetaMags5 = [];
BetaMags3 = [];
BetaMags1 = [];
BetaBase = [];
BetaSID = {};
NumStims = {};
TotalMags = [];
Chan = {};
Type = {};
%answer = input('use zscore or raw values? Enter "zscore" or "raw"  \n','s');

% exclude playback for now
% which
subdir = 'PeaktoPeakEP';

for sid = SIDS
    
        sid = sid{:};
    subjid = sid;
    info = M(sid);
    type = info{1};
    subjectNum = info{3};
    desiredF = info{2};
    stims = info{4};
    bads = info{5};
    goodEPs = info{6};
    betaChan = info{7};
    stimLevel = info{8};
    chans = [1:64];
    badsTotal = [stims bads];
    chans(ismember(chans, badsTotal) | ~ismember(chans,goodEPs)) = [];
    
    
    switch sid
        case 'd5cd55'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',subdir,'d5cd55epSTATS-PP-sig'))
            stims = [54 62];
            goods = [35 36 37 44 45 46 52 53 55 60 61 63];
            
            betaChan = 53;
            typeCell = {'180'};
            typeCell = {'180'};
            stimLevel = 2500;
            
        case 'c91479'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',subdir,'c91479epSTATS-PP-sig'))
            betaChan = 64;
            stims = [55 56];
            goods = [38 39 40 46 47 48 62 64];
            
            typeCell = {'180','0'};
            stimLevel = 3000;
            
        case '7dbdec'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',subdir,'7dbdecepSTATS-PP-sig'))
            stims = [11 12];
            goods = [4 5 10 13 21 22 23];
            
            betaChan = 4;
            typeCell = {'180'};
            stimLevel = 3500;
            
        case '9ab7ab'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',subdir,'9ab7abepSTATS-PP-sig'))
            betaChan = 51;
            stims = [59 60];
            goods = [42 43 50 51 52 53 57 58];
            typeCell = {'270'};
            stimLevel = 750;
            
        case '702d24'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',subdir,'702d24epSTATS-PP-sig'))
            betaChan = 5;
            stims = [13 14];
            %                     goods = 5;
            goods = [4 5 6 12 20 21 22];
            
            typeCell = {'270','90'};
            stimLevel = 750;
            
        case 'ecb43e'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',subdir,'ecb43eepSTATS-PP-sig'))
            dataForPPanalysis{64} = [];
            
            betaChan = 55;
            goods = [55 63 54 46 47 48 46];
            stims = [56 64];
            typeCell = {'270','90','Null','Random'};
            stimLevel = 1750;
            
        case '0b5a2e'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',subdir,'0b5a2eepSTATS-PP-sig'))
            betaChan = 23;
            stims = [22 30];
            goods = [12 13 14 15 16 21 23 31 32 39 40];
            typeCell = {'270','90','Null'};
            stimLevel = 1750;
            
            
        case '0b5a2ePlayback'
            load(fullfile(OUTPUT_DIR,'BetaTriggeredStim',subdir,'0b5a2ePlaybackepSTATS-PP-sig'))
            betaChan = 14;
            stims = [22 30];
            goods = [12 13 14 15 16 21 23 31 32 39 40];
            typeCell = {'270','90','Null'};
            stimLevel = 1750;
            
            
    end
    
    % here's where I pick those channels!
    chan = betaChan;
    chans = betaChan;
    
    % figure out number of test conditions
    numTypes = length(dataForPPanalysis{betaChan});
    
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
        
        for i = 1:numTypes
            
            if i ~= nullType
                tempMag = 1e6*dataForPPanalysis{chan}{i}{1};
                tempLabel = dataForPPanalysis{chan}{i}{4};
                tempKeeps = dataForPPanalysis{chan}{i}{5};
                
                tempBase = tempMag(tempLabel==0 & tempKeeps);
                tempResp1 = tempMag(tempLabel==1& tempKeeps);
                tempResp2 = tempMag(tempLabel==2& tempKeeps);
                tempResp3 = tempMag(tempLabel==3& tempKeeps);
                
                
                if (strcmp(subdir,'NeuroModulation') | strcmp(subdir,'NeuroModulationV2')| strcmp(subdir,'NeuroModulationV4')  | strcmp(subdir,'NeuroModulationV3')) & strcmp(answer,'zscore')
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
                Type = [Type{:} vecTypeC];
                
                % 6-17-2016 - have to transpose for 'conf'
                if (strcmp(subdir,'NeuroModulation')| strcmp(subdir,'NeuroModulationV4') | strcmp(subdir,'NeuroModulationV2')  | strcmp(subdir,'NeuroModulationV3')) & strcmp(answer,'zscore')
                    typeResp = [tempBase' tempResp1' tempResp2' tempResp3'];
                else
                    typeResp = [tempBase tempResp1 tempResp2 tempResp3];
                end
                TotalMags = [TotalMags typeResp];
                num5S = repmat('Ct>=5',length(tempResp3),1);
                num3S= repmat('3<=Ct<=4',length(tempResp2),1);
                num1S = repmat('1<=Ct<=2',length(tempResp1),1);
                numBaseS = repmat('Base',length(tempBase),1);
                
                %             numNullS = repmat('Null',length(tN),1);
                
                b5C = cellstr(num5S)';
                b3C = cellstr(num3S)';
                b1C = cellstr(num1S)';
                BC = cellstr(numBaseS)';
                %             nC = cellstr(numNullS)';
                NumStims = [NumStims{:} BC b1C b3C b5C];
            end
        end
        
        lengthToRep = length(t3)+length(t2)+length(t1)+length(tB);
        sidString = repmat(sid,lengthToRep,1);
        
        sidCell = cellstr(sidString)';
        
        BetaMags5 = [BetaMags5 t3];
        BetaMags3 = [BetaMags3 t2];
        BetaMags1 = [BetaMags1 t1];
        BetaBase = [BetaBase tB] ;
        BetaSID = [BetaSID{:} sidCell];
        StimLevel = [StimLevel repmat(stimLevel,lengthToRep,1)'];
    end
end


%%
tableBetaStim = table(TotalMags',StimLevel',categorical(NumStims)',categorical(BetaSID)',...
    'VariableNames',{'Magnitude','stimLevel','NumStims','SID'});
% group stats

statarray = grpstats(tableBetaStim,{'SID','NumStims'},{'mean','sem'},...
                     'DataVars','Magnitude');
                 %%
                 numSubj = 7;
numDims = 4;
j = 1;


new_order = [3 1 2 4];
new_order = repmat(new_order,1,numSubj);
subj_mult = repmat([0:4:24],numDims,1);
subj_mult = subj_mult(:);
new_order = new_order+subj_mult';
statarray = statarray(new_order,:);

new_sid_order = [6 5 3 4 2 7 1];
new_sid_order = repmat(new_sid_order,numDims,1);
new_sid_order = new_sid_order(:);
subj_num_stim = repmat([1:4],1,numSubj);

new_sid_order = 4*new_sid_order + subj_num_stim' - 4;
statarray = statarray(new_sid_order,:);
                 
%hierarchicalBoxplot(anovaTotalMags,{categorical(anovaNumStims),categorical(anovaBetaSID)})
 %%                
% fit glme         
glme = fitglme(tableBetaStim,'Magnitude~NumStims+stimLevel+(1|SID)+(-1 + NumStims | SID) + (-1 + stimLevel | SID)',...
    'Distribution','Normal','Link','Identity','FitMethod','Laplace','DummyVarCoding','effects','EBMethod','Default')
disp(glme)
anova(glme)
[psi,dispersion,stats] = covarianceParameters(glme)
psi
dispersion
stats
%%
% test effect between different stim levels 

% between 3<CT<4 and Base
H = [0,0,0,1,-1];

[pVal,F,DF1,DF2] = coefTest(glme,H);
fprintf(['p value between 3<ct<4 and base = ' num2str(pVal) '\n']);

% between 1<ct<2 and Base

H = [0,0,1,0,1];

[pVal,F,DF1,DF2] = coefTest(glme,H);
fprintf(['p value between 1<ct<2 and base = ' num2str(pVal) '\n']);

% between >5 and base
H = [0,0,1,1,2];

[pVal,F,DF1,DF2] = coefTest(glme,H);
fprintf(['p value between >5 and base = ' num2str(pVal) '\n']);

% between 1<ct<2 and >5

H = [0,0,2,1,1];

[pVal,F,DF1,DF2] = coefTest(glme,H);
fprintf(['p value between 1<ct<2 and >5 = ' num2str(pVal) '\n']);

% between 3<CT<4 and > 5

H = [0,0,1,2,1];

[pVal,F,DF1,DF2] = coefTest(glme,H);
fprintf(['p value between 3<ct<4 and > 5 ' num2str(pVal) '\n']);

%%
[pVal,F,DF1,DF2] = coefTest(glme)

%% MULTIPLE SUBJECTS - plot
% 
% D5cd55 - subject 1
% C91479 - subject 2
% 7dbdec - subject 3
% 9ab7ab - subject 4
% 702d24 - subject 5
% Ecb43e - subject 6
% 0b5a2e - subject 7 

figure

sem = table2array(statarray(:,{'sem_Magnitude'}));
means = table2array(statarray(:,{'mean_Magnitude'}));

load('line_red.mat');
colors = flipud(cm(round(linspace(1, size(cm, 1), numDims)), :));


k = 25;


% generate error bars 

for i = 1:height(statarray)
    
    if j == 5
        j = 1;
    end
 
    h = errorbar(i,means(i),sem(i),'o','linew',3,'color',colors(j,:),'capsize',10);
    ylim([0 800])

    set(h, 'MarkerSize', 5, 'MarkerFaceColor', colors(j,:), ...
        'MarkerEdgeColor', colors(j,:));
    hold on
    
    ax = gca;

    if j ==2
        text(i+0.15,min(means(:,1))-6,sprintf([num2str(floor(i/4)+1)]),'fontsize',14)
        
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


%%
% figure
% plotResiduals(glme,'histogram','ResidualType','Pearson')
% figure
% plotResiduals(glme,'fitted','ResidualType','Pearson')
% figure
% plotResiduals(glme,'lagged','ResidualType','Pearson')
% 
% %%
% 
% tableBetaStim = table(anovaTotalMags',anovaStimLevel',categorical(anovaType)',categorical(anovaNumStims)',categorical(anovaBetaSID)',...
%     'VariableNames',{'Magnitude','stimLevel','Type','NumStims','SID'});
% glme = fitglme(tableBetaStim,'Magnitude~NumStims+Type+stimLevel+(1|SID)+(Type|SID)',...
%     'Distribution','Normal','Link','Identity','FitMethod','Laplace','DummyVarCoding','effects')
% disp(glme)
% anova(glme)
% [psi,dispersion,stats] = covarianceParameters(glme)
% psi
% dispersion
% stats
% 
% %%
% 
% H = [0,0,1,-1,0,0,0,0,0];
% 
% [pVal,F,DF1,DF2] = coefTest(glme,H)
% 
% H = [0,0,0,1,-1,0,0,0,0];
% 
% [pVal,F,DF1,DF2] = coefTest(glme,H)
% 
% 
% H = [0,0,0,1,0,-1,0,0,0];
% 
% [pVal,F,DF1,DF2] = coefTest(glme,H)
% 
% 
% H = [0,0,1,0,0,-1,0,0,0];
% 
% [pVal,F,DF1,DF2] = coefTest(glme,H)