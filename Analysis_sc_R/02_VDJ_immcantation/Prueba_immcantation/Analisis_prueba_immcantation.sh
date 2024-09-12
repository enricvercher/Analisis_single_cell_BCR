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

# assign V, D, and J genes using IgBLAST

DATADIR=/data/scratch/LAB/enric/TFM_enric/VDJ_immcantation/Prueba_immcantation
SINGULARITY=/data/scratch/LAB/enric/TFM_enric/immcantation_suite-4.4.0.sif

module load singularity

# you should use the path to the FASTA file relative to the bound directory in the container.
singularity exec -B $DATADIR:/data $SINGULARITY \
AssignGenes.py igblast -s /data/data/10x_data_2subj/filtered_contig.fasta -b /usr/local/share/igblast \
   --organism human --loci ig --format blast --outdir /data/results

# convert IgBLAST output to AIRR format

singularity exec -B $DATADIR:/data $SINGULARITY bash -c "\
MakeDb.py igblast -i /data/results/filtered_contig_igblast.fmt7 \
-s /data/data/10x_data_2subj/filtered_contig.fasta \
-r /usr/local/share/germlines/imgt/human/vdj/imgt_human_*.fasta \
--10x /data/data/10x_data_2subj/filtered_contig_annotations.csv --extended"

# subset the data to include productive heavy chain sequences
singularity exec -B $DATADIR:/data $SINGULARITY \
ParseDb.py select -d /data/results/filtered_contig_igblast_db-pass.tsv \
-f productive -u T --outname data_p

# filter to include only heavy chain sequences
singularity exec -B $DATADIR:/data $SINGULARITY \
ParseDb.py select -d /data/results/data_p_parse-select.tsv \
-f v_call -u IGHV --regex --outname data_ph