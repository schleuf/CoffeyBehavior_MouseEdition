% Title: main_MouseSABehavior_20240429
% Author: Sierra Schleufer Ph.D. & Kevin Coffey, Ph.D.
% Affiliation: University of Washington, Psychiatry
% email address: mrcoffey@uw.edu  

% ------------- Description --------------
% This is the main analysis script for Golden Oral Fentanyl SA Behavior.
% ----------------------------------------

%% -------------------- BEGIN CODE --------------------
% --- All User Definable Inputs are in this section ---
close all
clear all

% IMPORT PATHS
main_folder = pwd;
cd(main_folder)
addpath(genpath(main_folder))
masterTable_flnm = '.\data_masterTable.mat'; % the masterTable .mat file loaded in if createNewMasterTable == false
beh_datapath = {'.\All Behavior'}; % Used to generate a new masterTable if createNewMasterTable == true
masterSheet_flnm = '.\Subject Key.xlsx'; % Key describing information specific to each animal
BE_intake_canonical_flnm = '.\BE Measured Intake.xlsx'; % Data table for measured intake only used if runType == 'BE'
experimentKey_flnm = '.\Experiment Key.xlsx'; % Key for date, session type, experiment type, drug concentration, dose.

% MISC. SETTINGS
runNum = '1_2_3_4_6'; % options: 'all' or desired runs separated by underscores. Must match numbers in Experiment Key (e.g. '1', '1_3_4', '3_2')
runType = 'All'; % options: 'ER' (SA & Extinction & Reinstatement), 'BE' (Behavioral Economics), 'SA' (Self Administration), 'All' (All run seperately)
createNewMasterTable = false; % true: generates & saves a new master table from medPC files in datapath. false: reads mT in from masterTable_flnm if set to false, otherwise 
firstHour = true; % true: acquire data from the first-hour of data and analyze in addition to the full sessions (Important for camparing behavior to 1h reinstatement session).
excludeData = true; % true: excludes data based on the 'RemoveSession' column of Subject Key
acquisition_thresh = 10; % to be labeled as "Acquire", animal must achieve an average number of infusions in Training sessions greater than this threshold
acquisition_testPeriod = {'Training', 'last', 10}; % determines sessions to average infusions across before applying acquisition_thresh. second value can be 'all', 'first', or 'last'. if 'first' or 'last', there should be a 3rd value giving the number of days to average across, or it will default to 1. 
pAcq = true; % true: plot aquisition histogram to choose threshold 
interpWeights = false; % true: interpolate daily weights from weekly weights
interpWeight_sessions = [1,6,11,16,21]; % [sessions with true weights for interpolation]

run_BE_analysis = true; % Run Behavioral Economics analysis?
run_withinSession_analysis = true; % Run within-sessions analysis?
run_individualSusceptibility_analysis = true; % Run individual risk analysis?

% FIGURE OPTIONS
% Currently, if figures are generated they are also saved. 
saveTabs = true; % true: save matlab tables of analyzed datasets
dailyFigs = false; % true: generate daily figures from dailySAFigures.m
pubFigs = true; % true: generate publication figures from pubSAFigures.m
indivIntake_figs = false; % true: generate figures for individual animal behavior across & within sessions (useful for troubleshooting but produces a lot of figures)
groupIntake_figs = true; % true: generate figures grouped by sex, strain, etc. for animal behavior across & within sessions
severity_figs = true; % true: generate severity figures
figsave_type = {'.png','.fig'}; % file types for figure outputs. May be any MATLAB standard image or figure type

% color settings chosen for publication figures.
gramm_C57_Sex_colors = {'hue_range',[40 310],'lightness_range',[95 65],'chroma_range',[50 90]};
gramm_CD1_Sex_colors = {'hue_range',[85 -200],'lightness_range',[85 75],'chroma_range',[75 90]};
gramm_Strain_Acq_colors = {'hue_range',[25 385],'lightness_range',[95 60],'chroma_range',[50 70]};
col_M_c57 = [0, 0.7333, 0.5647];
col_F_c57 = [1, 0.4196, 0.2902];
col_M_CD1 = [0.6392, 0.5373, 1];
col_F_CD1 = [0.7765, 0.5922, 0];

% SAVE PATHS
% Each dataset run (determined by runNum and runType) will have its own
% folder created in the allfig_savefolder. All other paths will be
% subfolders within it designated for the various figure types and matlab
% data saved. 
% Currently only daily & publication figures are saved with current date in
% the file name, so be aware of overwrite risk for other figures.
allfig_savefolder = 'Output\';
dailyfigs_savepath = 'Daily Figures\';
pubfigs_savepath = 'Publication Figures\';
indivIntakefigs_savepath = 'Individual Intake Figures\';
groupIntakefigs_savepath ='Group Intake Figures\'; 
groupOralFentOutput_savepath = 'Severity Output\';
tabs_savepath = 'Behavior Tables\';

%% HOUSEKEEPING

dt = char(datetime('today')); % Used for Daily & Publication figure savefile names

runNum = categorical(string(runNum));
runType = categorical(string(runType));
if runType == 'All'
    runType = categorical(["ER", "BE", "SA"]);
end

% Import Master Key
opts = detectImportOptions(masterSheet_flnm);
opts = setvartype(opts,{'TagNumber','ID','Cage','Sex','Strain','TimeOfBehavior'},'categorical'); % Must be variables in the master key
mKey=readtable(masterSheet_flnm,opts);

% Create subdirectories
toMake = {tabs_savepath, dailyfigs_savepath, pubfigs_savepath, ...
          indivIntakefigs_savepath, groupIntakefigs_savepath, groupOralFentOutput_savepath};
new_dirs = makeSubFolders(allfig_savefolder, runNum, runType, toMake, excludeData, firstHour);
sub_dir = new_dirs{1};
if firstHour
    fH_sub_dir = new_dirs{2};
end

% import experiment key
expKey = readtable(experimentKey_flnm);

%% IMPORT DATA
if createNewMasterTable
    mT = createMasterTable(beh_datapath, masterSheet_flnm, experimentKey_flnm, 'data_masterTable');
else
    load(masterTable_flnm)
end

%% ------------- FILTER DATA --------------
% exclude data
if excludeData
    mT = removeExcludedData(mT, mKey);
end

% get index for different experiments 
dex = getExperimentIndex(mT, runNum, runType);

% Check to be sure run types that are requested actually exist in the dataset
if any(contains(fieldnames(dex), 'ER'))
    if isempty(dex.ER)
        runType(runType == 'ER') = [];
    end
end

if any(contains(fieldnames(dex), 'BE'))
    if isempty(dex.BE)
        runType(runType == 'BE') = [];
    end
end

% Determine Acquire vs Non-acquire
Acquire = getAcquire(mT, acquisition_thresh, acquisition_testPeriod, pAcq);
if ~any(ismember(mT.Properties.VariableNames, 'Acquire'))
    mT=[mT table(Acquire)];
else
    mT.Acquire = Acquire;
end

% Weight Interpolation
if interpWeights
    mT = interpoweight(mT, interpWeight_sessions);
end

% Get data from the first hour of the session 
if firstHour
    hmT = getFirstHour(mT);
end

%% get group statistics and save tables of data analyzed
groupStats = struct;
if firstHour; hour_groupStats = struct; end
for et = 1:length(runType)
    groupStats.(char(runType(et))) = grpstats(mT(dex.(char(runType(et))),:), ["Sex", "Strain", "Session"], ["mean", "sem"], ...
                          "DataVars",["ActiveLever", "InactiveLever", "EarnedInfusions", "HeadEntries", "Latency", "Intake"]);
    if firstHour
        hour_groupStats.(char(runType(et))) = grpstats(hmT(dex.(char(runType(et))),:),["Sex", "Strain", "Session"], ["mean", "sem"], ...
                                   "DataVars",["ActiveLever", "InactiveLever", "EarnedInfusions", "HeadEntries", "Latency", "Intake"]);
    end
    if saveTabs
        writeTabs(mT(dex.(char(runType(et))),:), [sub_dir, tabs_savepath, 'run_', char(runNum), '_exp_', char(runType(et)), '_inputData'], {'.mat', '.xlsx'})
        writeTabs(groupStats.(char(runType(et))), [sub_dir, tabs_savepath, 'run_', char(runNum), '_exp_', char(runType(et)), '_GroupStats'], {'.mat', '.xlsx'})
        if firstHour
            writeTabs(hmT(dex.(char(runType(et))),:), [fH_sub_dir, tabs_savepath, 'run_', char(runNum), '_exp_', char(runType(et)), '_inputData'], {'.mat', '.xlsx'})
            writeTabs(hour_groupStats.(char(runType(et))), [fH_sub_dir, tabs_savepath, 'run_', char(runNum), '_exp_', char(runType(et)), '_GroupStats'], {'.mat', '.xlsx'})
        end
    end
end

%% Save Master Table and generate figures for daily spot checks

if dailyFigs
    % Save daily copy of the master table in .mat and xlsx format and save groups stats  
    mTname = [sub_dir, tabs_savepath, dt, '_MasterBehaviorTable.mat'];
    %Generate a set of figures to spotcheck data daily
    dailySAFigures(mT, runType, dex, [sub_dir, dailyfigs_savepath], figsave_type);
    close all
    if firstHour
        dailySAFigures(hmT, runType, dex, [fH_sub_dir, dailyfigs_savepath], figsave_type)
        close all
    end
end

%% Generate Clean Subset of Figures for Publication
if pubFigs %  && strcmp(runType, 'ER')
    pubSAFigures(mT, runType, dex, [sub_dir, pubfigs_savepath], figsave_type);
    if firstHour 
        pubSAFigures(hmT, runType, dex, [fH_sub_dir, pubfigs_savepath], figsave_type); 
    end
    close all;
end

%% Behavioral Economics Analysis 
if any(ismember(runType, 'BE')) && run_BE_analysis
    fig_colors = {[.5,.5,.5], col_F_c57, col_M_c57, col_F_CD1, col_M_CD1};
    [beT, beiT] = BE_processes(mT(dex.BE, :), expKey, BE_intake_canonical_flnm, sub_dir, indivIntake_figs, ...
                 groupIntake_figs, saveTabs, fig_colors, indivIntakefigs_savepath, groupIntakefigs_savepath, ...
                 tabs_savepath, figsave_type);
end

%% Within Session Behavioral Analysis 
if run_withinSession_analysis
    fig_colors = {[.5,.5,.5], col_F_c57, col_M_c57, col_F_CD1, col_M_CD1};
    [mTDL, mPressT, mDrugsLT] = WithinSession_Processes(mT, dex, sub_dir, indivIntake_figs, indivIntakefigs_savepath, groupIntake_figs, groupIntakefigs_savepath, saveTabs, tabs_savepath, figsave_type,fig_colors);
end

%% Statistic Linear Mixed Effects Models
% This section is not very flexible and should be modified for different experiments
statsname=[sub_dir, tabs_savepath, 'Oral SA Group Stats '];

% SA Acquitition All Animals with SA (Figure 1)
if any(ismember(runType,'SA'))
    data = mT(dex.SA,:);
    data=data(data.Acquire == 'Acquire',:);
    dep_var = ["Intake", "EarnedInfusions", "HeadEntries", "Latency", "ActiveLever", "InactiveLever"];

    if ismember('Strain', data.Properties.VariableNames) & ismember('Sex', data.Properties.VariableNames)
        lme_form = " ~ Sex*Strain*Session + (1|TagNumber)" % Possibly ~ Sex*Strain*Session + (Session|TagNumber)"
    elseif ismember('Sex', data.Properties.VariableNames)
        lme_form = " ~ Sex*Session + (1|TagNumber)";
    elseif ismember('Strain', data.Properties.VariableNames)
        lme_form = " ~ Strain*Session + (1|TagNumber)";
    end

    if ~isempty(data)
        Acq_LMEstats = getLMEstats(data, dep_var, lme_form);
        if saveTabs
            save([statsname, 'SA'], 'Acq_LMEstats');
        end
    end
end

if any(ismember(runType,'ER'))
    % LMEs for Extinction and Reinstatment Experiment (Figure 2)
    % Overall LMEs for Self Administration (not reported)
    ER_Stats=struct;
    data = mT(dex.ER,:);
    data=data(data.Acquire == 'Acquire',:);
    data=data(data.Session<=15,:);
    dep_var = ["Intake", "HeadEntries", "Latency", "ActiveLever", "InactiveLever"];
    if ismember('Strain', data.Properties.VariableNames) & ismember('Sex', data.Properties.VariableNames)
        lme_form = " ~ Sex*Strain*Session + (1|TagNumber)"
    elseif ismember('Sex', data.Properties.VariableNames)
        lme_form = " ~ Sex*Session + (1|TagNumber)";
    elseif ismember('Strain', data.Properties.VariableNames)
        lme_form = " ~ Strain*Session + (1|TagNumber)";
    end

    if ~isempty(data)
       ER_Stats.SA_LME = getLMEstats(data, dep_var, lme_form);
    end
    
    % Idividual Strains over Sessions & Session 15 Comparison (Figure 2)
    datac57=data(data.Strain=='c57',:);
    dataCD1=data(data.Strain=='CD1',:);
    lme_form = " ~ Sex*Session + (Session|TagNumber)";
    ER_Stats.SA_c57_LME = getLMEstats(datac57, dep_var, lme_form);
    ER_Stats.SA_CD1_LME = getLMEstats(dataCD1, dep_var, lme_form);

    % Session 15
    datac57=datac57(datac57.Session==15,:);
    dataCD1=dataCD1(dataCD1.Session==15,:);
    lme_form = " ~ Sex + (Session|TagNumber)";
    ER_Stats.S15_c57_LME = getLMEstats(datac57, dep_var, lme_form);
    ER_Stats.S15_CD1_LME = getLMEstats(dataCD1, dep_var, lme_form);
  
    % Overall LMEs for Extinction (not reported)
    data = mT(dex.ER,:);
    data=data(data.Acquire == 'Acquire',:);
    data=data(data.sessionType=='Extinction',:);
    dep_var = ["HeadEntries", "Latency", "ActiveLever", "InactiveLever"];
    if ismember('Strain', data.Properties.VariableNames) & ismember('Sex', data.Properties.VariableNames)
        lme_form = " ~ Sex*Strain*Session + (1|TagNumber)";
    elseif ismember('Sex', data.Properties.VariableNames)
        lme_form = " ~ Sex*Session + (1|TagNumber)";
    elseif ismember('Strain', data.Properties.VariableNames)
        lme_form = " ~ Strain*Session + (1|TagNumber)";
    end
    ER_Stats.Ext_LMEstats = getLMEstats(data, dep_var, lme_form);

    % Idividual Strains over Sessions Extinction (Figure 2)
    datac57=data(data.Strain=='c57',:);
    dataCD1=data(data.Strain=='CD1',:);
    lme_form = " ~ Sex*Session + (Session|TagNumber)";
    ER_Stats.Ext_c57_LME = getLMEstats(datac57, dep_var, lme_form);
    ER_Stats.Ext_CD1_LME = getLMEstats(dataCD1, dep_var, lme_form);

  % Overall LMEs for Reinstatemet (not reported)
    data = hmT(dex.ER,:);
    data=data(data.Acquire == 'Acquire',:);
    data=data(data.sessionType=='Reinstatement' | data.Session==25,:);
    dep_var = ["HeadEntries", "Latency", "ActiveLever", "InactiveLever"];
    if ismember('Strain', data.Properties.VariableNames) & ismember('Sex', data.Properties.VariableNames)
        lme_form = " ~ Sex*Strain*Session + (1|TagNumber)";
    elseif ismember('Sex', data.Properties.VariableNames)
        lme_form = " ~ Sex*Session + (1|TagNumber)";
    elseif ismember('Strain', data.Properties.VariableNames)
        lme_form = " ~ Strain*Session + (1|TagNumber)";
    end
    ER_Stats.Rei_LME = getLMEstats(data, dep_var, lme_form);

    % Idividual Strains over Sessions Reinstatement (Figure 2)
    datac57=data(data.Strain=='c57',:);
    dataCD1=data(data.Strain=='CD1',:);
    lme_form = " ~ Sex*Session + (Session|TagNumber)";
    ER_Stats.Rei_c57_LMEstats = getLMEstats(datac57, dep_var, lme_form);
    ER_Stats.Rei_CD1_LMEstats = getLMEstats(dataCD1, dep_var, lme_form);

    % Session 26
    datac57=datac57(datac57.sessionType=='Reinstatement',:);
    dataCD1=dataCD1(dataCD1.sessionType=='Reinstatement',:);
    lme_form = " ~ Sex + (Session|TagNumber)";
    ER_Stats.sexRei_c57_LMEstats = getLMEstats(datac57, dep_var, lme_form);
    ER_Stats.sexRei_CD1_LMEstats = getLMEstats(dataCD1, dep_var, lme_form);
    
    if saveTabs
       save([statsname, 'ER'], 'ER_Stats');
    end
end

if any(ismember(runType,'BE'))
    % Behavioral Economics SA Sessions
    BE_Stats=struct;
    data = mT(dex.BE,:);
    data=data(data.Acquire == 'Acquire',:);

    % Individual Strain for SA (BE Experiment)
    data=data(data.Session<=15,:);
    dep_var = ["Intake", "EarnedInfusions", "HeadEntries", "Latency", "ActiveLever", "InactiveLever"];
    datac57=data(data.Strain=='c57',:);
    dataCD1=data(data.Strain=='CD1',:);
    lme_form = " ~ Sex*Session + (Session|TagNumber)";
    BE_Stats.SA_c57_LMEstats = getLMEstats(datac57, dep_var, lme_form);
    BE_Stats.CD1_LMEstats = getLMEstats(dataCD1, dep_var, lme_form);

    % Session 15
    datac57=datac57(datac57.Session==15,:);
    dataCD1=dataCD1(dataCD1.Session==15,:);
    lme_form = " ~ Sex + (Session|TagNumber)";
    BE_Stats.S15_c57_LMEstats = getLMEstats(datac57, dep_var, lme_form);
    BE_Stats.S15_CD1_LMEstats = getLMEstats(dataCD1, dep_var, lme_form);
    
    % Behavioral Economics BE Sessions
    data = beT;
    % Individual Strain for SA (BE Experiment)
    data.Concentration=categorical(data.Concentration);
    data.Concentration=reordercats(data.Concentration,["70","222","125","40","22"]);
    dep_var = ["measuredIntake", "EarnedInfusions", "HeadEntries", "Latency", "ActiveLever", "InactiveLever"];
    datac57=data(data.Strain=='c57',:);
    dataCD1=data(data.Strain=='CD1',:);
    lme_form = " ~ Sex*Concentration + (1|TagNumber)";
    BE_Stats.BE_c57_LMEstats = getLMEstats(datac57, dep_var, lme_form);
    BE_Stats.BE_CD1_LMEstats = getLMEstats(dataCD1, dep_var, lme_form);
    
    if saveTabs
       save([statsname, 'BE'], 'BE_Stats');
    end
end

%% Individual Variability Suseptibility Modeling
% 1) Calculate individual susceptibility (IS) metrics
% 2) Calculate z-scores for each IS metric, sum these scores for each animal to get the Severity score
% 3) Get correlations between IS metric z-scores & correlation plot, calculated within the following groupings: 
%   - all animals, C57s, CD1s, Males, Females, Male C57s, Female C57s, Male CD1s, Female CD1s
% 4) Make violin plots of IS metrics in the following group pairs:
%   - C57s & CD1s, Males & Females, C57 Males & C57 Females, CD1 Males & CD1 Females
% 5) Generate PCA plots from IS metrics that show all animals against the first 3 and the first 2 principle components. Animals are marked with respect to Strain and Sex.
%       SSnote: add calculation of PCA for subgroups
%
% Individual Susceptibility Metrics
%   1) Intake = total fentanyl consumption in SA training (ug/kg)
%   2) Seeking = total head entries in SAtraining
%   3) Cue Association = Average HE Latency in SA 
%   4) Escalation = slope of intake in SA (session 1-10)
%   5) Extinction = total active lever presses during extinction
%   6) Persistance = slope of extinction active lever presses
%   7) Flexibility = total inactive lever presses during extinction
%   8) Relapse = total presses during reinstatement
%   9) Cue Recall = Average HE Latency in reinstatement 
%
% Experiment-dependent use cases: 
%   If the experiment contains ER experiment data, animals involved in these
%       experiments will be analyzed with respect to all IS metrics. 
%   If the experiment contains non-ER experiment data, all animals will be
%       analyzed with respect to Intake, Seeking, Cue Association, and Extinction. 
%
% .mat files saved during the process
%   - ivT: contains IS metrics for all animals
%   - ivZT: contains IS metric Z-scores (separately calculated and saved for ER & nonER groups)
%   - correlations: contains the correlations calculated for all subgroups,
%                   (separately calculated and saved for ER and non ER groups)

if run_individualSusceptibility_analysis
    % subgroups of z-scored data to run correlations across
    corrGroups = {{{'all'}}, ...
                  {{'Strain', 'c57'}}, ...
                  {{'Strain', 'CD1'}}, ...
                  {{'Sex', 'Male'}}, ...
                  {{'Sex', 'Female'}}, ...
                  {{'Strain', 'c57'}, {'Sex', 'Male'}}, ...
                  {{'Strain', 'c57'}, {'Sex', 'Female'}}, ...
                  {{'Strain', 'CD1'}, {'Sex', 'Male'}}, ...
                  {{'Strain', 'CD1'}, {'Sex', 'Female'}}}; 

    % groups to show comparison violin plots for each individual
    % susceptibility metric
    violSubsets = {{'all'}, {'all'}, {'Strain', 'c57'}, {'Strain', 'CD1'}};
    violGroups = {'Strain', 'Sex', 'Sex', 'Sex'};
    violLabels = {'Strain', 'Sex', 'c57 Sex', 'CD1 Sex'};
    pcaGroups = corrGroups;
    ivT = IS_processes(mT, dex, runType, corrGroups, violSubsets, ...
                       violGroups, violLabels, pcaGroups, sub_dir, ...
                       saveTabs, tabs_savepath, severity_figs, ...
                       groupOralFentOutput_savepath, figsave_type);
end
