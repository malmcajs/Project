#!/bin/bash
#SBATCH --time=36:00:00
#SBATCH --partition=medium
#SBATCH --ntasks-per-node=128
#SBATCH --nodes=4
##SBATCH --ntasks=128
##SBATCH --cpus-per-task=1
#SBATCH --array=0-9
#SBATCH --account=project_2003809	
#SBATCH --output=job_output_%A_%a.log
#SBATCH --error=job_error_%A_%a.log

#export GMX_MAXBACKUP=0

module load snakemake
module load gromacs-env

PROT_NAME="P19837_3reps_3mer_noIons"
cd ../..

BASE_DIR=${PWD}
SCRIPTS=${BASE_DIR}/simulation_scripts/MD_scripts
SNAKEFILE=${SCRIPTS}/Snakefile


your_projects=$(csc-projects | grep -o "project_.*" | awk '{print $1}')
echo "Select the number of the project you want to use:"

num=1
list=()

for i in $your_projects; do
        list+=($i)
        echo "("$num")" ${i} 
        ((num++))
done

read choice
project=${list[choice-1]}


#FORCEFIELD=(AMBER03WS AMBER99SB-DISP AMBER99SBWS CHARMM36M DESAMBER)
FORCEFIELD=(DESAMBER)

for pdb_file in $BASE_DIR/$PROT_NAME/rep*.pdb; do
	directory_path="${pdb_file%/*}"
	replicas=$(basename ${pdb_file%.pdb})
	for i in "${FORCEFIELD[@]}"; do
        	mkdir -p $directory_path/$replicas/${i}
        	cp -R -u -p $pdb_file $directory_path/$replicas/${i}
	done
done


PROT_FOLDERS=($(ls -d ${BASE_DIR}/${PROT_NAME}/*/*/))


cd ${PROT_FOLDERS[${SLURM_ARRAY_TASK_ID}]} || {
    echo "Failed to cd into ${PROT_FOLDERS[${SLURM_ARRAY_TASK_ID}]}"
    exit 1
}

echo "=== Job ${SLURM_ARRAY_TASK_ID} running in $(pwd) ==="


snakemake -s ${SNAKEFILE} --cores $SLURM_NTASKS --keep-going --rerun-incomplete 
