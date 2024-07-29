
subs=(`cat /scratch/users/ekubota/smooth_tiling/SUBJECTS.txt`)
ages=(`cat /scratch/users/ekubota/smooth_tiling/AGES.txt`)

echo $1
echo ${subs[@]}
echo ${ages[@]}
sub=${subs[$1]}
age=${ages[$1]}
echo $sub
echo $age

source /scratch/users/ekubota/extractor_mpm_babies/extractor_wrapper.sh $sub $age
source /scratch/users/ekubota/extractor_mpm_babies/tckmaps_wrapper.sh $sub $age
source /scratch/users/ekubota/extractor_mpm_babies/tracks2surf_wrapper.sh $sub $age