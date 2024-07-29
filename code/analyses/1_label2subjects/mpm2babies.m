% Maps the mpm labels to each baby session.

fsDir = '/oak/stanford/groups/kalanit/biac2/kgs/anatomy/freesurferRecon/babybrains';
setenv('SUBJECTS_DIR', fsDir);

T = setSessionbbDwi;
labelDir = fullfile(fsDir,'fsaverage_cyto','label','kubota_mpm_labels');
cd(labelDir)

hems = {'lh','rh'};

for s = 1:height(T)
    labelDir_sub = fullfile(fsDir,T.fsid{s},'label','kubota_mpm_labels');
    if ~exist(labelDir_sub,'dir')
        mkdir(labelDir_sub)
        for h = 1:2
            cd(labelDir)
            labels = dir(['*',hems{h},'*']);
            %labels = dir(['*reflected*']);

            for l = 1:length(labels)
                cmd = ['mri_label2label ',...
                    ' --srcsubject fsAverage',...
                    ' --srclabel ',fullfile(labelDir,labels(l).name),...
                    ' --trgsubject ',T.fsid{s},...
                    ' --trglabel ',fullfile(labelDir_sub,labels(l).name),...
                    ' --regmethod surface ',...
                    ' --hemi ',hems{h}];
                system(cmd)
            end
        end
    end
end 
    
    
