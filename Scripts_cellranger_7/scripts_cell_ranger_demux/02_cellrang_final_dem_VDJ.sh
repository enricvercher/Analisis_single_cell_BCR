#!/bin/bash

#############################################################################################################################
## Single Cell Multi (CellRanger)
## evercheh@nasertic.es
#############################################################################################################################

## Initial SBATCH commands (In these lines we define the parameters to run the job in the cluster)
#SBATCH --job-name=CellRanger_multi_final_VDJ
#SBATCH --mail-type=END
#SBATCH --mail-user=evercheh@nasertic.es
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32GB
#SBATCH -p gpu_a100


## Lines to demultiplex the samples

cellranger multi --id=Mouse_44-final --csv=mouse_44_final_Multiplex_config.csv
cellranger multi --id=Mouse_45-final --csv=mouse_45_final_Multiplex_config.csv
cellranger multi --id=Mouse_48-final --csv=mouse_48_final_Multiplex_config.csv
cellranger multi --id=Mouse_49-final --csv=mouse_49_final_Multiplex_config.csv
cellranger multi --id=Mouse_50-final --csv=mouse_50_final_Multiplex_config.csv
cellranger multi --id=Mouse_52-final --csv=mouse_52_final_Multiplex_config.csv
