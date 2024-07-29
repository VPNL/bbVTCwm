% scale maps so map sums to 1 

fsDir = '/oak/stanford/groups/kalanit/biac2/kgs/anatomy/freesurferRecon/babybrains';
setenv('SUBJECTS_DIR',fsDir);
T = setSessionbbDwi;
T = bbDiffusion_getProcessedSubs(T,{'IFOD2_5mil'});
hems = {'lh','rh'};
rois={'mOTS','pOTS','mFus','pFus','PPA','OTS'};

%% scale map 
for s = 1:height(T)
    fsdir_sub = sprintf('%s/%s/surf/smooth_tiling_endpoints',fsDir,T.fsid{s});
    if exist(fsdir_sub,'dir')
        for h=1:2
          
            for i = 1:length(rois) % loop over disks
                endpoints = cvnloadmgz(sprintf('%s/%s/surf/smooth_tiling_endpoints/%s_MPM_%s_wholebrain_extracted_track_%s_proj_max.mgh',...
                    fsDir,T.fsid{s},hems{h},rois{i},hems{h}));
                scaled_endpoints = endpoints/sum(endpoints);
                outdir = fullfile(fsDir,T.fsid{s},'surf','smooth_tiling_endpoints');
                cvnwritemgz(T.fsid{s},sprintf('MPM_%s_wholebrain_endpoints_scaled',rois{i}),scaled_endpoints,hems{h},outdir)
            end
        end
    end
end