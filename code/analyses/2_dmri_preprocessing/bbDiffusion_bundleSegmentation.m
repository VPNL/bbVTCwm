% 
function bbDiffusion_bundleSegmentation(fatDir,sessid,runName,fgNameBaby,babyAge,aseg_file_name,useBabyAFQ,generatePlots,t1_name)

% 8) Run AFQ to classify the fibers
if useBabyAFQ>0
    if strcmp(babyAge,'adult')
        
        cmd_str=['mri_convert ' fullfile(fatDir, sessid, runName,'t1','T1_biascorr.nii.gz') ' ',...
            fullfile(fatDir, sessid, runName,'t1','T1_biascorr_resliced2dwi.nii.gz') ' --reslice_like ',...
            fullfile(fatDir, sessid, runName,'dti94trilin','mrtrix','b0.nii.gz')];
        system(cmd_str);
        
        cmd_str=['fslmaths ' fullfile(fatDir, sessid, runName,'t1','T1_biascorr_resliced2dwi.nii.gz') ' -mas ',...
            fullfile(fatDir, sessid, runName,'dti94trilin','mrtrix','brainMask.nii.gz') ' ',...
            fullfile(fatDir, sessid, runName,'t1','T1_biascorr_resliced2dwi_masked.nii.gz')];
        system(cmd_str);
        t1_full_path = fullfile(fatDir,sessid,runName,'t1','T1_biascorr_resliced2dwi_masked.nii.gz');
        
    else
        %prepare t2 for alignment
        cmd_str=['mri_convert ' fullfile(fatDir, sessid, runName,'t1','t2_biascorr_acpc.nii.gz') ' ',...
            fullfile(fatDir, sessid, runName,'t1','t2_biascorr_acpc_resliced2dwi.nii.gz') ' --reslice_like ',...
            fullfile(fatDir, sessid, runName,'dti94trilin','mrtrix','b0.nii.gz')];
        system(cmd_str);
        
        cmd_str=['fslmaths ' fullfile(fatDir, sessid, runName,'t1','t2_biascorr_acpc_resliced2dwi.nii.gz') ' -mas ',...
            fullfile(fatDir, sessid, runName,'dti94trilin','mrtrix','brainMask.nii.gz') ' ',...
            fullfile(fatDir, sessid, runName,'t1','t2_biascorr_acpc_resliced2dwi_masked.nii.gz')];
        system(cmd_str);
        
        t1_full_path = fullfile(fatDir,sessid,runName,'t1','t2_biascorr_acpc_resliced2dwi_masked.nii.gz');
    end
    
    
    babyAFQRoiDir=fullfile(fatDir, sessid, runName,'dti94trilin','babyAFQROIs');
    out_fg=babyFatSegmentConnectomeMRtrix3_withOR(fatDir, babyAFQRoiDir,...
        sessid, runName, strcat(fgNameBaby,'.mat'),1,t1_full_path,aseg_file_name,babyAge);
end
%% 9) Optional: Clean Connectome with AFQ

    if useBabyAFQ>0
        fgNameBaby=strcat(fgNameBaby,'_classified_withBabyAFQ');
        out_fg=fatCleanConnectomeMRtrix3(fatDir, sessid, runName, strcat(fgNameBaby,'.mat'))
        fgNameBaby=strcat(fgNameBaby,'_clean');
    end
    
%% 10) Optional: Generate a few plots for quality assurance
fgNameBaby='WholeBrainFG_classified_withBabyAFQ_clean';
%fgNameBaby='WholeBrainFG_ET_msmtdhollanderwmCsdnorm_seed_gmwmi_classified_withBabyAFQ_clean';
%fgName='WholeBrainFG_classified_clean';

colorsBaby=load('colors_final.csv');
colorsBaby(27:28,:) = [0 0 0.8;0 0 1];
colorsAdult=load('colors_final.csv');

if useBabyAFQ>0
    colors=colorsBaby;
    if generatePlots >0
        tract_names={'TR' 'TR' 'CS' 'CS' 'CC' 'CC' 'CH' 'CH',...
            'FMa' 'FMi' 'IFOF' 'IFOF' 'ILF' 'ILF' 'SLF' 'SLF',...
            'UCI' 'UCI' 'AF' 'AF' 'MdLF' 'MdLF' 'OR' 'OR' 'VOF' 'VOF' 'pAF' 'pAF',...
            'pAF_VOT' 'pAF_VOT' 'pAF_sum' 'pAF_sum'};

        for foi= 23:24%1:28
            if rem(foi,2)==0
                hem='rh'
                h=2;
                color=colors(foi,:)
            else
                hem='lh'
                h=1;
                color=colors(foi+1,:)
            end

            if strcmp(tract_names{foi},'TR')
                ROIs= {'ATR_roi1_L.mat',  'ATR_roi2_L.mat', 'ATR_roi3_L.mat'; 'ATR_roi1_R.mat', 'ATR_roi2_R.mat', 'ATR_roi3_R.mat'};
            elseif strcmp(tract_names{foi},'CS')
                ROIs={'CST_roi1_L.mat', 'CST_roi2_L.mat'; 'CST_roi1_R.mat',  'CST_roi2_R.mat'};
            elseif strcmp(tract_names{foi},'CC')
                ROIs={'CGC_roi1_L.mat', 'CGC_roi2_L.mat'; 'CGC_roi1_R.mat', 'CGC_roi2_R.mat'};
            elseif strcmp(tract_names{foi},'CH')
                ROIs={'HCC_roi1_L.mat', 'HCC_roi2_L.mat'; 'HCC_roi1_R.mat', 'HCC_roi2_R.mat'};
            elseif strcmp(tract_names{foi},'FMa')
                ROIs={'FP_R.mat', 'FP_L.mat'; 'FP_R.mat', 'FP_L.mat'; };
            elseif strcmp(tract_names{foi},'FMi')
                ROIs={'FA_R.mat', 'FA_L.mat', 'FA_mid.mat'; 'FA_R.mat', 'FA_L.mat', 'FA_mid.mat'};
            elseif strcmp(tract_names{foi},'IFOF')
                ROIs={'IFO_roi1_L.mat', 'IFO_roi2_L.mat', 'IFO_roi3_L.mat' ; 'IFO_roi1_R.mat', 'IFO_roi2_R.mat', 'IFO_roi3_R.mat'};
            elseif strcmp(tract_names{foi},'ILF')
                ROIs={'ILF_roi1_L.mat', 'ILF_roi2_L.mat'; 'ILF_roi1_R.mat', 'ILF_roi2_R.mat'};
            elseif strcmp(tract_names{foi},'SLF')
                ROIs={'SLF_roi1_L.mat', 'SLF_roi2_L.mat'; 'SLF_roi1_R.mat', 'SLF_roi2_R.mat'};
            elseif strcmp(tract_names{foi},'UCI')
                ROIs={ 'UNC_roi1_L.mat', 'UNC_roi2_L.mat', 'UNC_roi3_L.mat' ; 'UNC_roi1_R.mat', 'UNC_roi2_R.mat', 'UNC_roi3_R.mat'};
            elseif strcmp(tract_names{foi},'AF')
                ROIs={ 'SLF_roi1_L.mat', 'SLFt_roi2_L.mat', 'SLFt_roi3_L.mat'; 'SLF_roi1_R.mat', 'SLFt_roi2_R.mat', 'SLFt_roi3_R.mat'};
            elseif strcmp(tract_names{foi},'MdLF')
                ROIs={ 'MdLF_roi1_L.mat', 'ILF_roi2_L.mat'; 'MdLF_roi1_R.mat','ILF_roi2_R.mat'};
            elseif strcmp(tract_names{foi},'OR')
                ROIs={'OR_leftThal.mat', 'OR_left_roi3.mat','OR_left_roi5.mat'; 'OR_rightThal.mat', 'OR_right_roi3.mat', 'OR_right_roi5.mat'};
            else 
                ROIs=[];
            end
            % removed V1 rois to generated OR bundles, instead used roi3
            % and roi5 - xy noted 2023.12.27

            %outname=strcat(tract_names{foi},'_',subject,'_',age,'_',fgName)
            outname=strcat(hem,'_',tract_names{foi},'_',fgNameBaby,'_withROIs')
            roiDir='babyAFQROIs';
            if isempty(ROIs)
                fatRenderFibersWholeConnectome(fatDir, sessid, runName, ...
                    strcat(fgNameBaby,'.mat'), foi,t1_name, hem, outname,color)
            else
                fatRenderFibersWholeConnectome(fatDir, sessid, runName, ...
                    strcat(fgNameBaby,'.mat'), foi,t1_name, hem, outname, color, roiDir, ROIs(h,:),50)
            end
        end
        % close all;
    end
end

%% 10) optional: plot with no ROIs
if useBabyAFQ>0
    colors=colorsBaby;
    if generatePlots >0
        tract_names={'TR' 'TR' 'CS' 'CS' 'CC' 'CC' 'CH' 'CH',...
            'FMa' 'FMi' 'IFOF' 'IFOF' 'ILF' 'ILF' 'SLF' 'SLF',...
            'UCI' 'UCI' 'AF' 'AF' 'MdLF' 'MdLF' 'OR' 'OR' 'VOF' 'VOF' 'pAF' 'pAF',...
            'pAF_VOT' 'pAF_VOT' 'pAF_sum' 'pAF_sum'}
        for foi = 23:24%1:28
            if rem(foi,2)==0
                hem='rh'
                h=2;
                color=colors(foi,:)
            else
                hem='lh'
                h=1;
                color=colors(foi+1,:)
            end

            outname=strcat(hem,'_',tract_names{foi},'_',fgNameBaby)

            fatRenderFibersWholeConnectome(fatDir, sessid, runName, strcat(fgNameBaby,'.mat'), foi,t1_name, hem,outname,color)
        end
    end
end

end