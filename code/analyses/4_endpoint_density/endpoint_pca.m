
data_dir = '/oak/stanford/groups/kalanit/biac2/kgs/projects/emily/smooth_tiling/r/data/mpm_analysis_no_normalization';
files = dir(data_dir);
hems = {'lh','rh'};
vtc_rois = {'PHA2','PHA3','TE2p','PH','PIT','FFC',...
                'V8','VVC','VMV2','VMV3','TF'};
pca_matrix =[];
hem_holder = [];
froi_holder = [];
age_holder =[];
sub_holder = [];
cyto_holder=[];
category_holder = [];
            
for h = 1:2
    hem_vtc_rois = strcat(hems{h},'.',vtc_rois,'_ROI.label');
    if h == 1
        rois = {'mOTS','pOTS','mFus','pFus','OTS','PPA'};
        cyto = {'FG4','FG2','FG4','FG2','FG4','FG3'};
        category = {'word','word','face','face','body','place'};
    else
        rois = {'mFus','pFus','OTS','PPA'};
        cyto = {'FG4','FG2','FG4','FG3'};
        category = {'face','face','body','place'};
    end
    
    for r = 1:length(rois)
        
        for s = 1:length(files)
            fname = files(s).name;
            [tok,rem] = strtok(fname,'.');
            if strcmp(rem,'.csv')
                H = readtable(fullfile(data_dir,fname));
                % remove the vtc rois
                H(ismember(H.glasser_roi,hem_vtc_rois),:) = [];
                pca_matrix = [pca_matrix;H(strcmp(H.hem,hems{h}) & strcmp(H.froi,rois{r}),:).endpoint_density'];
                hem_holder = [hem_holder;hems(h)];
                froi_holder = [froi_holder;rois(r)];
                cyto_holder = [cyto_holder;cyto(r)];
                sub_holder = [sub_holder;H.sub(1)];
                age_holder = [age_holder;H.age(1)];
                category_holder = [category_holder;category(r)];
            end
        end
    end
end

%% pca 
% pca_matrix_transposed = pca_matrix';
% 
 [coeff,score,latent,tsquared,explained,mu] = pca(pca_matrix);
 
% write out loadings 
pc = coeff(:,1:10);
J = array2table(pc);
glasser_rois = H(strcmp(H.hem,hems{h}) & strcmp(H.froi,rois{r}),:).glasser_roi;
glasser_rois = strrep(glasser_rois,'rh','lh') ;
J.glasser_roi = glasser_rois;
writetable(J,'loadings.csv')

% 
 biplot(coeff(:,1:2),'scores',score(:,1:2))
 
 plot(explained)
 xlabel('Component')
 ylabel('Variance Explained')
 
 % write out pcs as to table;
 
 H = table;
 H.pc1 = score(:,1);
 H.pc2 = score(:,2);
 H.pc3 = score(:,3);
 H.pc4 = score(:,4);
 H.pc5 = score(:,5);
 H.pc6 = score(:,6);
 H.pc7 = score(:,7);
 H.pc8 = score(:,8);
 H.pc9 = score(:,9);
 H.pc10 = score(:,10);
 H.pc11 = score(:,11);
 H.pc12 = score(:,12);
 H.pc13 = score(:,13);
 H.pc14 = score(:,14);
 H.pc15 = score(:,15);
 H.pc16 = score(:,16);
 H.pc17 = score(:,17);
 H.pc18 = score(:,18);
 H.pc19 = score(:,19);
 H.pc20 = score(:,20);
 H.age = age_holder;
 H.cyto = cyto_holder;
 H.hem = hem_holder;
 H.sub = sub_holder;
 H.froi = froi_holder;
 H.category = category_holder;
 
 writetable(H,'/oak/stanford/groups/kalanit/biac2/kgs/projects/emily/smooth_tiling/r/data/pca/pca.csv')
 
 %%
 J=table;
 J.component = [1:169]';
 J.variance_explained = explained;
 writetable(J,'/oak/stanford/groups/kalanit/biac2/kgs/projects/emily/smooth_tiling/r/data/pca/component_vs_explained.csv')

