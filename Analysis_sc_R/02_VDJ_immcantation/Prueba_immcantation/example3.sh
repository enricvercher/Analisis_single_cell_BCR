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


DATADIR=/data/scratch/LAB/enric/TFM_enric/VDJ_immcantation/Prueba_immcantation
SINGULARITY=/data/scratch/LAB/enric/TFM_enric/immcantation_suite-4.4.0.sif

module load singularity

singularity exec -B $DATADIR:/data $SINGULARITY \
ParseDb.py select -d /data/results/data_p_parse-select.tsv \
-f v_call -u IGHV --regex --outname data_ph
