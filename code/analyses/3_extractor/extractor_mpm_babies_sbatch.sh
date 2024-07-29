#!/bin/bash
#SBATCH --job-name=mpm
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ekubota@stanford.edu
#SBATCH -o slurm.%N.%j.out
#SBATCH -e slurm.%N.%j.err
#SBATCH -p normal,owners
#SBATCH --array=2,3

module load biology contribs poldrack freesurfer/6.0.1 fsl/6.0.1
module load biology mrtrix/3.0.3
ml python/3.9.0

cd /oak/stanford/groups/kalanit/biac2/kgs/projects/emily/

echo ${SLURM_ARRAY_TASK_ID}
source /scratch/users/ekubota/extractor_mpm_babies/extractor2surf_wrapper.sh ${SLURM_ARRAY_TASK_ID}

exit
