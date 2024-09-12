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

DATADIR=/data/scratch/LAB/enric/TFM_enric/02_VDJ_immcantation/VDJ_TFM/
SINGULARITY=/data/scratch/LAB/enric/TFM_enric/immcantation_suite-4.4.0.sif

singularity exec -B $DATADIR:/data $SINGULARITY bash -c "\
    DefineClones.py -d /data/results/01_Data_genotyped/all_mice_genotyped.tsv --vf v_call_genotyped \
    --model ham --norm len --dist 0.053 --format airr --nproc 8 \
    --outname all_mice_clonal_assigment --outdir /data/results/clonal_assigment/"

singularity exec -B $DATADIR:/data $SINGULARITY bash -c "\
    CreateGermlines.py -d /data/results/clonal_assigment/all_mice_clonal_assigment_clone-pass.tsv \
    -r /usr/local/share/germlines/imgt/mouse/vdj/*IGH[DJ].fasta  /data/results/01_Data_genotyped/vALL_genotype.fasta \
    -g dmask --cloned --vf v_call_genotyped \
    --format airr --outname all_mice_final_VDJ_germlines"
   # si escribimos en -r solamente /usr/local/share/germlines/imgt/mouse/vdj/ nos da el mismo resultado porque luego añadimos el vALL_genotype.fasta (IGHV)


