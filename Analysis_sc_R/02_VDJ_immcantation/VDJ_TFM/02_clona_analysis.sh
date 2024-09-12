#!/bin/bash

# Immcantation VDJ analysis workflow
#############################################################################################################################
## VDJ from cellranger 10X outputs (CellRanger)
## evercheh@nasertic.es
#############################################################################################################################

## Initial SBATCH commands (In these lines we define the parameters to run the job in the cluster)
#SBATCH --job-name=immcantation
#SBATCH --mail-type=END
#SBATCH --mail-user=evercheh@nasertic.es
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32GB
#SBATCH -p gpu_a100

########################
########################

module load singularity

DATADIR=/data/scratch/LAB/enric/TFM_enric/VDJ_immcantation/VDJ_TFM/
SINGULARITY=/data/scratch/LAB/enric/TFM_enric/immcantation_suite-4.4.0.sif

# extract mouse numbers and threshold values (columns 1 and 2, respectively) from predicted_thresholds.csv
mouse_nums=(`awk -F, 'NR>1 {print $1}' $DATADIR/results/01_Data_genotyped/predicted_thresholds.csv`)
thresholds=(`awk -F, 'NR>1 {print $2}' $DATADIR/results/01_Data_genotyped/predicted_thresholds.csv`)

# create sequence 0 to #mice
indx=($(seq 0 $(( ${#mouse_nums[@]} - 1 )) ))

# print mouse_nums and thresholds to verify
echo ${mouse_nums[@]}
echo ${thresholds[@]}


# for each mouse
# assign clonal groups

for i in ${indx[@]}
do
    # Define clones (dist = distance threshold)
    # Output file is named "IGHV-genotyped_M#_clone-pass.tab"
    # we need to pass the cells with the dist_nearest
    singularity exec -B $DATADIR:/data $SINGULARITY bash -c "\
    DefineClones.py -d /data/results/01_Data_genotyped/${mouse_nums[$i]}.genotyped.dist.tsv --vf v_call_genotyped \
    --model ham --norm len --dist ${thresholds[$i]} --format airr --nproc 8 \
    --outname ${mouse_nums[$i]}_clonal_assigment --outdir /data/results/clonal_assigment/"

    singularity exec -B $DATADIR:/data $SINGULARITY bash -c "\
    CreateGermlines.py -d /data/results/clonal_assigment/${mouse_nums[$i]}_clonal_assigment_clone-pass.tsv \
    -r /usr/local/share/germlines/imgt/mouse/vdj/*IGH[DJ].fasta /data/results/01_Data_genotyped/${mouse_nums[$i]}.genotype.fasta \
    -g dmask --cloned --vf v_call_genotyped \
    --format airr --outname ${mouse_nums[$i]}_final_germlines"
done

