#!/bin/bash

#############################################################################################################################
## Single Cell Multi (CellRanger)
## evercheh@nasertic.es
#############################################################################################################################

## Initial SBATCH commands (In these lines we define the parameters to run the job in the cluster)
#SBATCH --job-name=CellRanger_multi_bamtofastq
#SBATCH --mail-type=END
#SBATCH --mail-user=evercheh@nasertic.es
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32GB
#SBATCH -p gpu_a100


# Cargar el módulo de Singularity
module load singularity/3.4.1

# Ejecutar cellranger bamtofastq usando el contenedor de Singularity
singularity exec --nv --bind /data:/data /data/scratch/LAB/enric/TFM_enric/Contenedores/cellranger.sif \
cellranger bamtofastq --reads-per-fastq=261805134 /data/scratch/LAB/enric/TFM_enric/000_Cellranger_8/demultiplexed_samples_cellranger_8/outs/per_sample_outs/mouse_52/count/sample_alignments.bam /data/scratch/LAB/enric/TFM_enric/0_bamtofastq/mouse_52_fastq

singularity exec --nv --bind /data:/data /data/scratch/LAB/enric/TFM_enric/Contenedores/cellranger.sif \
cellranger bamtofastq --reads-per-fastq=343134271 /data/scratch/LAB/enric/TFM_enric/000_Cellranger_8/demultiplexed_samples_cellranger_8/outs/per_sample_outs/mouse_50/count/sample_alignments.bam /data/scratch/LAB/enric/TFM_enric/0_bamtofastq/mouse_50_fastq

singularity exec --nv --bind /data:/data /data/scratch/LAB/enric/TFM_enric/Contenedores/cellranger.sif \
cellranger bamtofastq --reads-per-fastq=261805134 /data/scratch/LAB/enric/TFM_enric/000_Cellranger_8/demultiplexed_samples_cellranger_8/outs/per_sample_outs/mouse_49/count/sample_alignments.bam /data/scratch/LAB/enric/TFM_enric/0_bamtofastq/mouse_49_fastq

singularity exec --nv --bind /data:/data /data/scratch/LAB/enric/TFM_enric/Contenedores/cellranger.sif \
cellranger bamtofastq --reads-per-fastq=261805134 /data/scratch/LAB/enric/TFM_enric/000_Cellranger_8/demultiplexed_samples_cellranger_8/outs/per_sample_outs/mouse_48/count/sample_alignments.bam /data/scratch/LAB/enric/TFM_enric/0_bamtofastq/mouse_48_fastq

singularity exec --nv --bind /data:/data /data/scratch/LAB/enric/TFM_enric/Contenedores/cellranger.sif \
cellranger bamtofastq --reads-per-fastq=343134271 /data/scratch/LAB/enric/TFM_enric/000_Cellranger_8/demultiplexed_samples_cellranger_8/outs/per_sample_outs/mouse_45/count/sample_alignments.bam /data/scratch/LAB/enric/TFM_enric/0_bamtofastq/mouse_45_fastq

singularity exec --nv --bind /data:/data /data/scratch/LAB/enric/TFM_enric/Contenedores/cellranger.sif \
cellranger bamtofastq --reads-per-fastq=343134271 /data/scratch/LAB/enric/TFM_enric/000_Cellranger_8/demultiplexed_samples_cellranger_8/outs/per_sample_outs/mouse_44/count/sample_alignments.bam /data/scratch/LAB/enric/TFM_enric/0_bamtofastq/mouse_44_fastq