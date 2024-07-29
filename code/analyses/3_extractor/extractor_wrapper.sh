dmriDir=/oak/stanford/groups/kalanit/biac2/kgs/projects/babybrains/mri
fsDir=/oak/stanford/groups/kalanit/biac2/kgs/anatomy/freesurferRecon/babybrains
outdir=/oak/stanford/groups/kalanit/biac2/kgs/projects/emily/smooth_tiling/extractor_outputs
runname=IFOD2_5mil

sub=$1
age=$2
hems=(lh rh)

fsid=${sub}_${age}_mask
sessid=${sub}/${age}
gmwmi_file=${outdir}/${fsid}/anat/gmwmi.nii.gz
rois=(mOTS mFus pFus pOTS OTS PPA)

for hemi in "${hems[@]}";
do
	for i in "${rois[@]}";
	do 
		t1=$dmriDir/$sessid/dwi/$runname/t1/t2_biascorr_acpc.nii.gz
		diskdir=$fsDir/$fsid/label/kubota_mpm_labels
		wholebraintck=$dmriDir/$sessid/dwi/$runname/dti94trilin/fibers/WholeBrainFG.tck
		if [ -f "$gmwmi_file" ];
		then
			extractor --subject $fsid --tract $wholebraintck --roi1 ${diskdir}/MPM_${hemi}_${i}_adult_20thresh_contour.label --fs-dir $fsDir --hemi $hemi --trk-ref $t1 --out-dir $outdir --search_dist 3 --search_type radial --out-prefix ${hemi}_MPM_${i}_wholebrain --projfrac-params=-1,0,0.1 --skip-viz  --gmwmi $gmwmi_file
		else 
			extractor --subject $fsid --tract $wholebraintck --roi1 ${diskdir}/MPM_${hemi}_${i}_adult_20thresh_contour.label --fs-dir $fsDir --hemi $hemi --trk-ref $t1 --out-dir $outdir --search_dist 3 --search_type radial --out-prefix ${hemi}_MPM_${i}_wholebrain --projfrac-params=-1,0,0.1 --skip-viz
		fi	
	done 
done
