% Maps the cyto labels to each baby session.

fsDir = '/oak/stanford/groups/kalanit/biac2/kgs/anatomy/freesurferRecon/babybrains';
setenv('SUBJECTS_DIR',fsDir)
T = setSessionbbDwi;
T = bbDiffusion_getProcessedSubs(T,{'IFOD2_5mil'});
needs_rosenke=[];

for s=1:height(T)
    rosenke = sprintf('%s/%s/label/rosenke_cyto_atlas',fsDir,T.fsid{s});
    if ~exist(rosenke,'dir')
        needs_rosenke=[needs_rosenke;T.fsid(s)];
    end 
end 

rosenkeDir_fsa = fullfile(fsDir,'fsAverage','label','rosenke_cyto_atlas');
hems = {'lh','rh'};

for s =1:length(needs_rosenke)
    for h=1:2
        cd(rosenkeDir_fsa)
        cytoROIs = dir(strcat('MPM_',hems{h},'*.label'));
        hem = hems{h};
        for s = 1:length(needs_rosenke)
            srcsubject = 'fsAverage';
            trgsubject = needs_rosenke{s};
            cd(fullfile(fsDir,trgsubject,'label'))
            if ~exist('rosenke_cyto_atlas','dir')
                mkdir('rosenke_cyto_atlas')
            end
            
            for ww = 1:length(cytoROIs)
                srclabelfile = fullfile(rosenkeDir_fsa,cytoROIs(ww).name);
                trglabelfile = fullfile(fsDir,trgsubject,'label','rosenke_cyto_atlas',cytoROIs(ww).name)
                cmd = ['mri_label2label --srcsubject ',srcsubject,...
                    ' --srclabel ',srclabelfile,...
                    ' --trgsubject ',trgsubject,...
                    ' --trglabel ',trglabelfile,...
                    ' --regmethod surface --hemi ',hem];
                system(cmd)
            end
        end
    end
end