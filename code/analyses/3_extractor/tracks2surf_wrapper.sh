fsDir=/oak/stanford/groups/kalanit/biac2/kgs/anatomy/freesurferRecon/babybrains
indir=/oak/stanford/groups/kalanit/biac2/kgs/projects/emily/smooth_tiling/extractor_outputs
runname=IFOD2_5mil

export SUBJECTS_DIR=$fsDir 

hems=(lh rh)

 
sub=$1
age=$2
fsid=${sub}_${age}_mask
sessid=${sub}/${age}
track_dir=$indir/$fsid/tracks_smooth_tiling
mri_dir=$fsDir/$fsid/mri
surf_dir=$fsDir/$fsid/surf
endpoint_dir=$surf_dir/smooth_tiling_endpoints
mkdir $endpoint_dir
rois=(mOTS mFus pFus pOTS OTS PPA)


for hemi in "${hems[@]}";
do
	for i in "${rois[@]}";
	do 
 		map_name=${hemi}_MPM_${i}_wholebrain_extracted_track
        trkName=${hemi}_MPM_${i}_wholebrain_extracted.tck
        fg=$indir/$fsid/dwi/$trkName
        if [ -f "$fg" ];
		then
			map_path=$track_dir/${map_name}_resliced.nii.gz
            cd $track_dir
            mri_convert -ns 1 -odt float -rt interpolate -rl ${mri_dir}/orig.mgz ${track_dir}/${map_name}.nii.gz ${track_dir}/${map_name}_resliced.nii.gz --conform
            for p in $(seq -.5 0.1 0.5);
            do
                cd $surf_dir
                mri_vol2surf --mov $map_path --reg register.dat --hemi $hemi --interp trilin --o ${endpoint_dir}/${map_name}_${hemi}_proj_${p}.mgh --projfrac $p 
            done
            cd $endpoint_dir
            #remove map if it already exists 
            max_map=${map_name}_${hemi}_proj_max.mgh
            if [ -f "$max_map" ];
            then
                rm $max_map
            fi
            mri_concat --i ${map_name}_${hemi}_proj_* --o $max_map --max
		fi	
	done 
done