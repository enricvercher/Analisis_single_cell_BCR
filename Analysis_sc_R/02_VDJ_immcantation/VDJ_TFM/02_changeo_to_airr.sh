#!/bin/bash

# Immcantation VDJ analysis workflow
#############################################################################################################################
## changeo to airr format
## evercheh@nasertic.es
#############################################################################################################################

## Initial SBATCH commands (In these lines we define the parameters to run the job in the cluster)
#SBATCH --job-name=changeo to airr
#SBATCH --mail-type=END
#SBATCH --mail-user=evercheh@nasertic.es
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32GB
#SBATCH -p gpu_a100

module load singularity

DATADIR=/data/scratch/LAB/enric/TFM_enric/VDJ_immcantation/VDJ_TFM/
SINGULARITY=/data/scratch/LAB/enric/TFM_enric/immcantation_suite-4.4.0.sif

sample_list=(`ls -d $DATADIR/VDJ_OTUs/*/ | xargs -n 1 basename`)

# Create filtered VDJ seq database files for each sample
for sample in ${sample_list[@]}
do
    singularity exec -B $DATADIR:/data $SINGULARITY bash -c "\
    ConvertDb.py airr \
    -d /data/VDJ_OTUs/${sample}/filtered_contig_${sample}_igblast_db-pass.tab \
    -o /data/VDJ_OTUs/${sample}/filtered_contig_${sample}_igblast_db-pass_airr_script.tsv"
done