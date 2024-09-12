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

###########################
### PREPARE ENVIRONMENT ###
###########################

#These will not be used as we will use Singularity container
#mamba env create -f immcant-environment.yml -n immcant-env
#mamba env create -f sauron_environment.yml -n Sauron.v1
#source activate immcant-env

# !IMPORTANT!
# The Immcantation pipeline requires some accessory scripts that are not
# included in a nicely packaged conda or python package, but instead must be
# retrieved from their Bitbucket repository.
# All files in "https://bitbucket.org/kleinstein/immcantation/src/master/scripts/"
# should be downloaded to your local "$main/scripts/immcantation" directory.


############################################
### RETRIEVE IG BLAST REFERENCE DATABASES ###
#############################################
# They are included in the container

#######################################
### RUN IG BLAST ON VDJ FASTA FILES ###
#######################################

# module load singularity

# DATADIR=/data/scratch/LAB/enric/TFM_enric/VDJ_immcantation/VDJ_TFM/
# SINGULARITY=/data/scratch/LAB/enric/TFM_enric/immcantation_suite-4.4.0.sif

# singularity exec -B $DATADIR:/data $SINGULARITY bash -c "\
# AssignGenes.py igblast \
# -s /data/VDJ_OTUs/*/filtered_contig_*.fasta \
# -b /usr/local/share/igblast \
# --organism mouse \
# --loci ig \
# --format blast \
# --outdir /data/results"

##############################################
### PARSE VDJ FILES INTO CHANGEO DB FORMAT ###
##############################################

module load singularity

DATADIR=/data/scratch/LAB/enric/TFM_enric/VDJ_immcantation/VDJ_TFM/
SINGULARITY=/data/scratch/LAB/enric/TFM_enric/immcantation_suite-4.4.0.sif

# Get list of all samples available
sample_list=(`ls -d $DATADIR/VDJ_OTUs/*/ | xargs -n 1 basename`)

# Create filtered VDJ seq database files for each sample
for sample in ${sample_list[@]}
do
    #Create tab-delimited database file to store seq alignment info
    singularity exec -B $DATADIR:/data $SINGULARITY bash -c "\
    MakeDb.py igblast \
    -i /data/results/results_make.db/filtered_contig_"$sample"_igblast.fmt7 \
    -s /data/VDJ_OTUs/"$sample"/filtered_contig_"$sample".fasta \
    -r /usr/local/share/germlines/imgt/mouse/vdj/imgt_mouse_*.fasta \
    -o /data/VDJ_OTUs/"$sample"/filtered_contig_"$sample"_igblast_db-pass-airr.tsv \
    --10x /data/VDJ_OTUs/"$sample"/filtered_contig_annotations_"$sample".csv \
    --format airr \
    --extended"

    # Filter database to only keep functional (productive) sequences (removing non-productive sequences)

    singularity exec -B $DATADIR:/data $SINGULARITY bash -c "\
    ParseDb.py select -d /data/VDJ_OTUs/"$sample"/filtered_contig_"$sample"_igblast_db-pass-airr.tsv \
        -f productive \
        -u T \
        --outname "$sample"_productive"

    # we filter the data to include **only heavy chain** sequences. 

    singularity exec -B $DATADIR:/data $SINGULARITY bash -c "\
    ParseDb.py select -d /data/VDJ_OTUs/"$sample"/"$sample"_productive_parse-select.tsv \
        -f "v_call" \
        -u "IGHV" \
        --logic all \
        --regex \
        --outname "$sample"_filtered_heavy_airr"
done
    
