function bbDiffusion_createConnectomes(fatDir,sessid,runName,t1_name,...
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

% Creates whole brain connectomes 
% inputs: 
%   fatDir: directory where DWI data is stored 
%   sessid: subject specific folder 
%   runName: name of run folder (e.g., run1)
%   t1_name: name of t1 folder (e.g., t1.nii.gz)
%   algo: algorithm (e.g., IFOD1 or IFOD2)
%   seeding: how to seed connectomes 
%   nSeeds:  number of sessds 
%   background: run multiple at the same time (1 will not work)
%   verbose: give output
%   clobber: overwrite files 
%   mrtrixversion: should be 3
%   ET: whether to use ensemble tractography 
%   cutoff: 
%   runLife: whether to run life (default = 0)

%4) Initiate a dt.mat data structure
%--> After this step, check that t1 and dwi were aligned properly

[dt6folder, dt6file]=fatCreateDT6(fatDir,{sessid},{runName},t1_name,clobber);
save(fullfile(fatDir,sessid,runName,'dt6Info.mat'),'dt6file','dt6folder');

%6) Set up tractography for mrtrix 3
%--> After this step check that dwi_[...]_wmCSD_lmax_auto.mif looks
%ok. You probably also want to check the other files in the mrtrix folder, especially:
%dwi_[...]_ev.mif, dwi_[...]_5tt.mif, dwi_[...]_ev.mif, dwi_[...]_vf.mif and dwi_[...]_voxels.mif

anatFolder=fullfile(fatDir,sessid,runName,'t1');
files = babyFat_AFQ_mrtrixInit(dt6file, ...
    fullfile(fatDir,sessid,runName,dt6folder.name,'mrtrix'),...
    mrtrixversion, ...
    multishell, ... % true/false
    track_tool,... % 'fsl', 'freesurfer'
    1,... %compute5tt
    anatFolder, ...
    aseg_file_name);
%include mt normaize
wmCsd=files.wmCsdMSMTDhollanderNorm;


%7) Create connectomes
%--> After this step check that WholeBrainFG.tck looks ok
[status, results, out_fg] = babyFatCreateConnectomeMRtrix3ACT(fullfile(fatDir,sessid,runName,dt6folder.name),...
    files, ...
    algo, ...
    seeding, ...
    nSeeds, ...
    background, ...
    verbose, ... %verbose
    clobber, ... %clobber
    mrtrixversion, ...
    ET, ...
    cutOff, ...
    wmCsd);

fgName='WholeBrainFG';
fgNameBaby='WholeBrainFG';

%7) Optional: Run LiFE to optimize the ET connectome
if runLife > 0
    out_fg=fatRunLifeMRtrix3(fatDir, sessid, runName,strcat(fgName,'.mat'));
    fgName=strcat(fgName,'_LiFE');
end