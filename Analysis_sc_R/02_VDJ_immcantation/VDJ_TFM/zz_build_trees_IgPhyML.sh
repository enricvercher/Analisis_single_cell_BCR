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

module load singularity

DATADIR=/data/scratch/LAB/enric/TFM_enric/VDJ_immcantation/VDJ_TFM/
SINGULARITY=/data/scratch/LAB/enric/TFM_enric/immcantation_suite-4.4.0.sif


# Run the R script inside the Singularity container
singularity exec -B $DATADIR:/data $SINGULARITY bash -c "\
Rscript -e 'library(alakazam);\
trees <- getTrees(clones.rsd, build = \"igphyml\" , exec=\"/usr/local/share/igphyml/src/igphyml\", nproc = 1); \
saveRDS(trees, \"/data/trees.rds\")'"


