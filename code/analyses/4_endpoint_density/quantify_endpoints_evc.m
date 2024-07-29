T = setSessionbbDwi;
T = bbDiffusion_getProcessedSubs(T,{'IFOD2_5mil'});
extractor_dir = '/oak/stanford/groups/kalanit/biac2/kgs/projects/emily/smooth_tiling/extractor_outputs';
eccen = {'zerofivedegrees','fivetendegrees','tentwentydegrees'};
rois={'mOTS','pOTS','mFus','pFus','PPA','OTS'};
hems={'lh','rh'};

for s  = 1:height(T)
    n_streamlines=[];
    eccen_holder=[];
    hem=[];
    sessid=[];
    subj=[];
    age=[];
    disk_roi=[];
    for h=1:2 %
        for i = 1:length(rois)
            n_fibers = zeros(length(eccen),1);
            for tt = 1:length(eccen)
                tck = fullfile(extractor_dir, T.fsid{s},'dwi',[hems{h},'_MPM','_',rois{i}, '_',eccen{tt},'_wholebrain_extracted.tck']);
                if exist(tck,'file')
                    sub_bundle = read_mrtrix_tracks(tck);
                    n_fibers(tt) = str2double(sub_bundle.count);
                else
                    n_fibers(tt)=0;
                end 
            end
          
                n_streamlines=[n_streamlines;sum(n_fibers)];
                eccen_holder=[eccen_holder;eccen(tt)];
                hem=[hem;hems{h}];
                sessid=[sessid;T.sessid(s)];
                subj=[subj;T.subj(s)];
                age=[age;T.age(s)];
                disk_roi=[disk_roi;rois(i)];
                
        end
    end
    H=table;
    H.sessid=sessid;H.subj=subj;H.age=age;H.froi=disk_roi;H.hem=hem;H.n_streamlines=n_streamlines;
      outdir = '/oak/stanford/groups/kalanit/biac2/kgs/projects/emily/smooth_tiling/r/data';
      writetable(H,fullfile(outdir,'evc2froi_total',[T.subj{s},'_mri',int2str(T.age(s)),'.csv']))
end