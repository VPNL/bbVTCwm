%% Reads in slope data and takes screenshots with slopes on the cortical surface
%% 
% Dependencies: Freesurfer (version 7) and SUBJECTS_DIR defined 
% Glasser Atlas (Glasser et al., 2016) downloaded and stored in
% fsaverage/label/glasserAtlas
% AFQ vals2colormap function
% rgb2hex from matlab file exchange

colormap = [0.2857917366747387, 0.5169848269105909, 0.30613859860653175;
 0.3516333717675879, 0.5612113556809977, 0.3700140618183703;
 0.4174750068604372, 0.6054378844514047, 0.4338895250302089;
 0.4883813831142748, 0.6530664538964581, 0.5026784854121888;
 0.554223018207124, 0.697292982666865, 0.5665539486240274;
 0.6276518729688759, 0.7466159278385492, 0.6377900609169176;
 0.6934935080617252, 0.7908424566089561, 0.7016655241287562;
 0.7643998843155628, 0.8384710260540096, 0.7704544845107363;
 0.8302415194084121, 0.8826975548244165, 0.834329947722575;
 0.9011478956622497, 0.93032612426947, 0.9031189081045549;
 0.9390062533305844, 0.9147174733980914, 0.9299706278481004;
 0.9143732314626323, 0.8460101986724518, 0.8905412846181462;
 0.8914997111566767, 0.7822105864272146, 0.8539283230474743;
 0.8668666892887245, 0.7135033117015749, 0.8144989798175202;
 0.8439931689827689, 0.6497036994563379, 0.7778860182468483;
 0.8184838328603067, 0.5785521787687787, 0.7370539849326813;
 0.7956103125543512, 0.5147525665235417, 0.7004410233620094;
 0.770977290686399, 0.446045291797902, 0.6610116801320552;
 0.7481037703804434, 0.38224567955266503, 0.6243987185613834;
 0.7252302500744878, 0.3184460673074281, 0.5877857569907117];

frois = {'mFus','mOTS','pOTS','pFus','OTS','PPA'};
crange=[-.00045, .00045];

views={'lateral','medial'};

working_dir = '/path/to/bbVTCwm/code/figures';

for v = 1:length(views)
    for r = 1:length(frois)
        cd(working_dir)
        labelList = [];
        colorList = [];
        T = readtable(fullfile('../../data/fig4_slopes/',['lh_',frois{r},'.csv']));
        for i=1:height(T)
            rgb=vals2colormap(T.slope(i),colormap,crange); % AFQ function
            hex = rgb2hex(rgb); % matlab file exchange 
            colorList = [colorList;{hex}];
            labelList = [labelList;strcat('glasserAtlas/',T.glasser(i))];
        end
        fname=fullfile(working_dir,'fig4',['lh_',frois{r},'_',views{v},'.png']);
        freesurfer_takescreenshots('fsaverage_cyto','lh', labelList, colorList, views{v}, fname)
        cd(working_dir)
    end
end