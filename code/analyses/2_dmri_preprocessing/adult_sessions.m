% Information for adult data for Emily Kubota 2024 paper

addpath(genpath('/share/kalanit/software/vistasoft/'))
addpath(genpath('/share/kalanit/software/spm8/'))

codeDir = '/oak/stanford/groups/kalanit/biac2/kgs/projects/bbDWI_development/code';
topupDir = '/oak/stanford/groups/kalanit/biac2/kgs/projects/bbDWI_development/code/bbDiffusion';


addpath(genpath(codeDir))

fatDir = '/oak/stanford/groups/kalanit/biac2/kgs/projects/QSM/dwi'; % this is the directory where the diffusion data for 
fsDir = 'fsDir = '/oak/stanford/groups/kalanit/biac2/kgs/anatomy/freesurferRecon/babybrains'; % this is the directory for the free surfer segmentations


setenv('SUBJECTS_DIR',fsDir)
% list of adult session
sessid= {'BF','ERK','JY','ST','NK','JD','VN','HW','XY','AX','ANC', 'MF', 'LM', 'JM', 'HS', 'JT', 'KW', 'HC','BR','CT','GK'};


%% preprocessign parameters
% everything in the pipeline is the same as babies except the anatomy for
% which we use a t1 for the adults but a t2 for the infants


runName={'IFOD2_5mil'};
t1_name='T1_biascorr.nii.gz';
aseg_file_name = 'aparc+aseg.nii.gz';
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