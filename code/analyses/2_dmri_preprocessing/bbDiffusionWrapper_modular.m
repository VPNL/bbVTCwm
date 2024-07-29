
%Diffusion tool combine Vistasoft, MRtrix, LiFE and AFQ to produce functional defined fasciculus.
%It requires these toolboxs installed, and also required the fROI defined by vistasoft.
%In oder for this code to run, you will likely need to upgrade several
%software packages, specifically this code was tested using: MRtrix RC3,
%fslv6.0.1, ANTs from 2017, AFQ from 2019, cuda9.1, and infant freesurferv7.0.0. Please note that
%running older version will lead to subtly inoptimal results. I made a few
%suggestions which outputs to ckeck for qulity assurance. You can do sou
%using mrview.
%The pipeline is orgnized as bellow and was written by Mareike Grotheer in
%2019 and updated by Xiaoqian Yan & Emily Kubota in 2022


%% Set paths and parameters
addpath(genpath('/share/kalanit/software/vistasoft/'))
addpath(genpath('/share/kalanit/software/spm8/'))
fatDir = '/oak/stanford/groups/kalanit/biac2/kgs/projects/babybrains/mri';
codeDir = '/oak/stanford/groups/kalanit/biac2/kgs/projects/bbDWI_development/code';
topupDir = '/oak/stanford/groups/kalanit/biac2/kgs/projects/bbDWI_development/code/bbDiffusion';
fsDir = '/oak/stanford/groups/kalanit/biac2/kgs/projects/anatomy/freesurferRecon/babybrains';
addpath(genpath(codeDir))
setenv('SUBJECTS_DIR',fsDir)
T = readtable('../../../data/sessions.csv');
runName={'IFOD2_5mil'};

sessid = T.sessid;
dataset_yr = T.year;
fsid = T.fsid;
age = T.age;


t1_name='t2_biascorr_acpc.nii.gz';
aseg_file_name = 'asegWithVentricles_reslice.nii.gz';
useBabyAFQ =1;
useAdultAFQ=0;
revPhase=1; %the baby project is using reverse phase encoding correction
doDenoise=1; % denoise the data? Enter 0 or 1
doGibbs=0; % do gibss ringing correction? Enter 0 or 1
doEddy=1; % do eddy correction? Enter 0 or 1
doBiasCorr=1; % do bias correction? Enter 0 or 1
doRicn=0; % ricn denoise is not yet implemented for revPhase data
lmax='auto'; %todate MRtrix automatically choose appropricate lmax when using dhollander
mrtrixversion=3; %going back to an older version will require serious changes to the pipeline
multishell=1; % the baby project has 3 shells
track_tool='freesurfer'; % chose between freesurfer or fsl. Fsl does not work well though.
algo='IFOD2'; % several options, IFOD2 is the most modern.
background=0; % run multible MRtrix comments at the same time. 1 will not work.
verbose=1; % print output to window
clobber=1; %overwrite existing files
seeding='seed_gmwmi'; % seeding mechanisms, this uses ACT
nSeeds=5000000; % how many seeds
ET=0; % do you want to use ensemble tractography? Enter 1 or 0
runLife=0; % do you want to run life?
classifyConnectome = 1; % do you want to classify the connectome with AFQ? Enter 1 or 0
cleanConnectome = 1; % do you want to clean the connectome with AFQ? Enter 1 or 0
generatePlots =1; % do you want to generates some simple plots of fiber tracts for quality assurance? Enter 1 or 0
cutOff=0.05;

%%
for s=1:length(sessid)
    tic
    close all;
    for r=1:length(runName)
        runDir = fullfile(fatDir,sessid{s},'dwi',runName{r});
        if ~exist(runDir)
            mkdir(runDir)
        end 
        anatDir = fullfile(fatDir,sessid{s},'dwi',runName{r},'t1');
         if ~exist(anatDir,'dir')
             cmd = ['ln -s ',fullfile(fatDir,sessid{s},'preprocessed_acpc'),' ',anatDir];
             system(cmd)
         end 
        
        if exist(anatDir,'dir')
         %  step 1: preprocess data
             bbDiffusion_preprocess(fatDir,topupDir,sessid{s},dataset_yr{s},runName{r},revPhase)
            
        %  step 2: create connectomes
           bbDiffusion_createConnectomes(fatDir,[sessid{s},'/dwi'],runName{r},t1_name,...
               multishell, ... % true/false
               track_tool,...
               aseg_file_name,...
               algo,...
               seeding,...
               nSeeds,...
               background,...
               verbose,... %verbose
               clobber,... %clobber
               mrtrixversion,...
               ET,...
               cutOff,...
               runLife)
            
%             step3: bundle segmentations
%             if you are running this part only, you need to load the dt6 info
%             files first, which is saved in step 2
            if ~exist(fullfile(fatDir,[sessid{s},'/dwi'],runName{r},'dti94trilin/fibers/afq'),'dir')
                
                load(fullfile(fatDir,[sessid{s},'/dwi'],runName{r},'dt6Info.mat'));
                fgNameBaby='WholeBrainFG';
                babyAge = [];
                bbDiffusion_bundleSegmentation(fatDir,[sessid{s},'/dwi'],runName{r},...
                    fgNameBaby,babyAge,aseg_file_name,useBabyAFQ,generatePlots,t1_name)
            end
            
%             close all
            
         end

    end
end 



