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

cellranger bamtofastq --reads-per-fastq=261805134 /data/scratch/LAB/enric/TFM_enric/demultiplexed_samples/outs/per_sample_outs/mouse_52/count/sample_alignments.bam /data/scratch/LAB/enric/TFM_enric/bamtofastq/mouse_52_fastq
cellranger bamtofastq --reads-per-fastq=343134271 /data/scratch/LAB/enric/TFM_enric/demultiplexed_samples/outs/per_sample_outs/mouse_50/count/sample_alignments.bam /data/scratch/LAB/enric/TFM_enric/bamtofastq/mouse_50_fastq
cellranger bamtofastq --reads-per-fastq=261805134 /data/scratch/LAB/enric/TFM_enric/demultiplexed_samples/outs/per_sample_outs/mouse_49/count/sample_alignments.bam /data/scratch/LAB/enric/TFM_enric/bamtofastq/mouse_49_fastq
cellranger bamtofastq --reads-per-fastq=261805134 /data/scratch/LAB/enric/TFM_enric/demultiplexed_samples/outs/per_sample_outs/mouse_48/count/sample_alignments.bam /data/scratch/LAB/enric/TFM_enric/bamtofastq/mouse_48_fastq
cellranger bamtofastq --reads-per-fastq=343134271 /data/scratch/LAB/enric/TFM_enric/demultiplexed_samples/outs/per_sample_outs/mouse_45/count/sample_alignments.bam /data/scratch/LAB/enric/TFM_enric/bamtofastq/mouse_45_fastq
cellranger bamtofastq --reads-per-fastq=343134271 /data/scratch/LAB/enric/TFM_enric/demultiplexed_samples/outs/per_sample_outs/mouse_44/count/sample_alignments.bam /data/scratch/LAB/enric/TFM_enric/bamtofastq/mouse_44_fastq

