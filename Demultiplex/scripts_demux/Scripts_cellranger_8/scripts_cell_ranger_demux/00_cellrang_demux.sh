#!/bin/bash

#############################################################################################################################
## Single Cell Multi (CellRanger)
## evercheh@nasertic.es
#############################################################################################################################

## Initial SBATCH commands (In these lines we define the parameters to run the job in the cluster)
#SBATCH --job-name=CellRanger_multi
#SBATCH --mail-type=END
#SBATCH --mail-user=evercheh@nasertic.es
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32GB
#SBATCH -p gpu_a100

## Lines to demultiplex the samples
module load singularity/3.4.1

# Ejecutar cellranger multi usando el contenedor de Singularity
singularity exec --nv --bind /data:/data /data/scratch/LAB/enric/TFM_enric/Contenedores/cellranger.sif \
cellranger multi --id=demultiplexed_samples_cellranger_8  --csv=/data/scratch/LAB/enric/TFM_enric/multi_config_CSV/0_hashing_demux_config.csv    
    #-id parameter specifies the name of the output directory where the analysis results will be saved
    #-csv parameter specifies the path to the CSV file that contains the sample sheet