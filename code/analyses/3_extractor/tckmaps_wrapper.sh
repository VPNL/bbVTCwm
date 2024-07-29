dmriDir=/oak/stanford/groups/kalanit/biac2/kgs/projects/babybrains/mri
fsDir=/oak/stanford/groups/kalanit/biac2/kgs/anatomy/freesurferRecon/babybrains
indir=/oak/stanford/groups/kalanit/biac2/kgs/projects/emily/smooth_tiling/extractor_outputs
runname=IFOD2_5mil

export SUBJECTS_DIR=$fsDir 
hems=(lh rh)
 
sub=$1
age=$2 
fsid=${sub}_${age}_mask
sessid=${sub}/${age}
t1=$dmriDir/$sessid/dwi/$runname/t1/t2_biascorr_acpc.nii.gz
rois=(mOTS mFus pFus pOTS OTS PPA)

for hemi in "${hems[@]}";
do
	for i in "${rois[@]}";
	do 
		tck=$indir/$fsid/dwi/${hemi}_MPM_${i}_wholebrain_extracted.tck
		if [ -f "$tck" ];
		then
			outname=${hemi}_MPM_${i}_wholebrain_extracted_track.nii.gz
            outdir=$indir/$fsid/tracks_smooth_tiling
            mkdir $outdir
            output=$outdir/$outname
            tckmap -template $t1 -ends_only -info -contrast tdi -force $tck $output
		fi	
	done 
done
