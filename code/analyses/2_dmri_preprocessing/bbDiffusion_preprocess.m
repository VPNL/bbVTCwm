function bbDiffusion_preprocess(fatDir, topupDir,sessid,dataset_yr,runName,revPhase)
% preprocess baby diffusion data using fat. 
% 
% inputs: 
%   fatDir: directory where dwi data is stored 
%   topupDir: directory where topup_params are stored.
%   sessid: subject specific folder 
%   dataset year: 2019 or 2021 
%   runName: folder for run (e.g., run1)
%   revPhase: 1 or 0 (baby data is multishell, so this will usually be 1).


session=strsplit(sessid,'/');
subject=session{1};
age=session{2};
anatid=strcat(subject,'/',age,'/preprocessed_acpc/');
%Ok, here we go

%1) Prepare fat data and directory structure

%    The following parameters need to be adjusted to fit your system
babyFatPrepareMRtrix3(fatDir,sessid, anatid, runName)

%         %2) Preprocess the data using mrTrix3
%--> After this step check that dwi_processed.nii.gz looks ok
sessid = [sessid,'/dwi'];
cd(fullfile(fatDir,sessid,runName))

cmd_str=['cp -r ' fullfile(topupDir,['topup_params_',dataset_yr]) ' ' fullfile(fatDir,sessid,runName)];
system(cmd_str);
cmd_str=['mv ' fullfile(fatDir,sessid,runName,['topup_params_',dataset_yr],'*') ' ' fullfile(fatDir,sessid,runName)];
system(cmd_str);
rmdir(fullfile(fatDir,sessid,runName,['topup_params_',dataset_yr]))
cmd_str=['mv ' fullfile(fatDir,sessid,runName,'dwiMultiShell.bvec') ' ' fullfile(fatDir,sessid,runName,'raw')];
system(cmd_str);

if revPhase == 1
    fatPreProcMRtrix3NiiWithAdvancedMotion_multishell(fatDir,sessid,runName)
else
    fatPreProcMRtrix3NiiWithAdvancedMotion_singleshell(fatDir,sessid,runName)
end

%3) We need to make a few changes to the nifti for it to work with
%the rest of the pipeline
cmd = ['mrconvert dwi_processed.nii.gz'...
    ' -fslgrad dwi_processed.bvec dwi_processed.bval dwi_processed.nii.gz'...
    ' -stride -1,2,3,4 -export_grad_fsl dwi_processed.bvec dwi_processed.bval -force'];
[status,results] = AFQ_mrtrix_cmd(cmd, false, true,3);

nii=niftiRead(fullfile(fatDir,sessid,runName,'dwi_processed.nii.gz'));
nii.phase_dim=2;
niftiWrite(nii,fullfile(fatDir,sessid,runName,'dwi_processed.nii.gz'));