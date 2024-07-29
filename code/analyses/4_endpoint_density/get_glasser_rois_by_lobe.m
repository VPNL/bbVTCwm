function [labels,lobes] = get_glasser_rois_by_lobe(hem)


fsDir = '/oak/stanford/groups/kalanit/biac2/kgs/anatomy/freesurferRecon/babybrains';
glasserDir = fullfile(fsDir,'fsaverage_cyto','label','glasserAtlas');

cd(glasserDir) 

colorLUT = readtable('GlasserLobeMapping.xlsx');
    
labels = strcat(hem,'.',colorLUT.GlasserROI,'_ROI.label');
lobes = colorLUT.Lobe;