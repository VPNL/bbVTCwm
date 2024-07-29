fsDir = '/oak/stanford/groups/kalanit/biac2/kgs/anatomy/freesurferRecon/babybrains';
setenv('SUBJECTS_DIR',fsDir);
T = bbDiffusion_getProcessedSubs(T,{'IFOD2_5mil'});
hems = {'lh','rh'};
rois={'mFus','mOTS','OTS','PPA','pOTS','pFus'};
eccen={'zerofivedegrees','fivetendegrees','tentwentydegrees'};

%% scale map
for s = 1:length(fsid)
    fsdir_sub = sprintf('%s/%s/surf/smooth_tiling_endpoints',fsDir,fsid{s});
    if exist(fsdir_sub,'dir')
        for h=1:2
            
            for i = 1:length(rois) % loop over disks
                for e = 1:length(eccen)
                    endpoints = cvnloadmgz(sprintf('%s/%s/surf/smooth_tiling_endpoints/%s_MPM_%s_%s_wholebrain_extracted_track_%s_proj_max.mgh',...
                        fsDir,fsid{s},hems{h},rois{i},eccen{e},hems{h}));
                    scaled_endpoints = endpoints/sum(endpoints);
                    outdir = fullfile(fsDir,fsid{s},'surf','smooth_tiling_endpoints');
                    cvnwritemgz(fsid{s},sprintf('MPM_%s_%s_wholebrain_endpoints_scaled',rois{i},eccen{e}),scaled_endpoints,hems{h},outdir)
                end
            end
        end
    end
end