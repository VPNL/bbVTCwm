function freesurfer_takescreenshots(FSSubj, hemi, labelList, colorList, view, fname)
% Description: this script opens freeview and takes a screenshot of a given
% subject and map/label, view

%% Inputs: for example
% (1) name of fsdirectory, FSSubj = 'bb05_mri_mask';
% (2) hemi = 'lh' or 'rh'
% and (3) labelList, for example labelList={'FG1', FG2}
% (4) colorList = list of colors for labels (hex)
% (5) view='ventral', 'lateral','medial', or 'posterior'
% (6) optional:  title for image/screenshot
%
% 
% Written by MN 2021 
% Adapted by EK 2021
% adapted by XY 2022

%% view settings
% Set here the view settings, this is for ventral view
if strcmp(view, 'ventral')
    settingsView = ' -cam dolly 1.2 azimuth 180 elevation 270 roll 270';
elseif strcmp(view, 'lateral') 
    %XY: this is medial if in the right hemi
%    settingsView = ' -cam dolly 1.2 azimuth 10 elevation -21 roll 0';
    settingsView = ' -cam dolly 1.2 azimuth 0 elevation 0 roll 0';
elseif strcmp(view,'posterior')
    settingsView = ' -cam dolly 1.2 azimuth 65 elevation 0 roll 0';
elseif strcmp(view,'medial')
    %XY: this is lateral if in the right hemi
    settingsView = ' -cam dolly 1.2 azimuth 180 elevation 0 roll 0';
else 
    sprintf('THis view has not yet been defined. Choose ventral or lateral')
end

% set here if label should be displayed as outline (1) or not (0)
labelOutlineFlag = ':label_outline=0';

screenshotCmd = ' -ss screenshot';


%% directory
FSDir = getenv('SUBJECTS_DIR');
% move into subj directory
cd([FSDir FSSubj])

freeviewCMD = sprintf('freeview -f surf/%s.inflated:curvature_method=binary', hemi);

%% load map and label if applicable on surface in freeview, set 3d view  and rotate to  view, take screenshot
if ~isempty(mapName)
%     % Setting to threshold overlay at 3 and don't show negative vals
%     % overlayThreshold = ':overlay_threshold=0.00000610344,.00006:overlay_color=heat' ;
%     overlayThreshold = ':overlay_threshold=0.00000610344,.0003:overlay_color=colorwheel' ;
%     freeviewCMD = [freeviewCMD sprintf(':overlay=%s.mgh%s',  mapName, overlayThreshold)] ;
    freeviewCMD = [freeviewCMD sprintf(':overlay=%s.mgh%s',  mapName)] ;
end
if ~isempty(labelList)
    labelCMD ='';
    for l=1:length(labelList)
        labelName=labelList{l};
         colorname=colorList{l};
         
         %colorname = 'white';
      
%          labelCMD = [labelCMD sprintf(':label=label/rosenke_visfAtlas/%s%s:label_color=%s', labelName,labelOutlineFlag, colorname)];
         labelCMD = [labelCMD sprintf(':label=label/%s%s:label_color=%s', labelName,labelOutlineFlag, colorname)];
    end

    freeviewCMD = [freeviewCMD labelCMD];
end
freeviewCMD = [freeviewCMD sprintf(' --viewport 3D %s %s', settingsView, screenshotCmd)];
unix(freeviewCMD)

%% finally rename screenshot

movefile('screenshot.png', fname);

