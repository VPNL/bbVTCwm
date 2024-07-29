% quantify the endpoint density within each glasser roi

fsDir = '/oak/stanford/groups/kalanit/biac2/kgs/anatomy/freesurferRecon/babybrains';
T = setSessionbbDwi;
T = bbDiffusion_getProcessedSubs(T,{'IFOD2_5mil'});
hems = {'lh','rh'};
rois = {'mFus','pFus','mOTS','pOTS','OTS','PPA'};


%% scale map 

for s = 1:height(T)
    froi = [];
    hem = [];
    glasser_roi = [];
    sessid=[];
    sub = [];
    age=[];
    endpoint_density = [];
    lobe =[];
    fsdir_sub = sprintf('%s/%s/surf/smooth_tiling_endpoints',fsDir,T.fsid{s});
    if exist(fsdir_sub,'dir')
        for h=1:2
            for i = 1:length(rois) % loop over disks
                endpoint_file = sprintf('%s/%s/surf/smooth_tiling_endpoints/%s.MPM_%s_wholebrain_endpoints_scaled.mgz',...
                    fsDir,T.fsid{s},hems{h},rois{i});
                glasserdir = sprintf('%s/%s/label/glasserAtlas',fsDir,T.fsid{s});
                cd(glasserdir)
                [labels,lobes] = get_glasser_rois_by_lobe(hems{h});
                
                if exist(endpoint_file,'file')
                    endpoints = cvnloadmgz(endpoint_file);
                    if length(endpoints > 0)
                    for l = 1:length(labels)
                        label = read_label_kgs(fullfile(glasserdir,labels{l}));
                        label = sort(label);
                        idx = label(1:end,1)+1;
                       % density = sum(endpoints(idx))/size(idx,1); %divide by the size of the roi
                        density = sum(endpoints(idx)); %divide by the size of the roi
                        froi = [froi;rois(i)];
                        hem = [hem;hems(h)];
                        glasser_roi = [glasser_roi;labels(l)];
                        lobe = [lobe;lobes(l)];
                        sub = [sub;T.fsid(s)];
                        age=[age;T.sess(s)];
                        sessid=[sessid;T.sessid(s)];
                        endpoint_density = [endpoint_density;density];
                    end
                    end 
                end
            end
        end
    end
    H = table;H.froi = froi;H.hem = hem;H.glasser_roi = glasser_roi;
    H.sub = sub;H.age=age;H.sessid=sessid;H.endpoint_density = endpoint_density;H.lobe = lobe;

    outdir = '/oak/stanford/groups/kalanit/biac2/kgs/projects/emily/smooth_tiling/r/data';

    writetable(H,fullfile(outdir,'endpoints',[T.fsid{s},'.csv']))

end


