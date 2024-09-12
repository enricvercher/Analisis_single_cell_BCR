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

#########################################################
### INFER IG GENOTYPE AND ESTIMATE SEQ DIST THRESHOLD ###
#########################################################
# Run R-script to infer sequence genotype and estimate VDJ seq hamming distance threshold
# Results are exported as "IGHV-genotyped_M#.tab", where "M#" is "M1", "M2", etc. for each mouse,
# and a fasta file of the V-segment germline sequences: "IGHV_genotype_M#.fasta".
# A .csv file of estimated threshold values will also be written to the output directory.

# The metadata.csv file should contain metadata about each of the BCR sequencing sample files;
# for an example of how the metadata file should be formatted, see the example metadata.csv
# file in the data/ subdirectory of the repository.

singularity exec -B $DATADIR:/data $SINGULARITY bash -c "\
Rscript /data/scripts_VDJ_enric/VDJ_analysis/01_VDJ_genotype_and_threshold.R \
--VDJ_data_path /data/VDJ_OTUs \
--metadata_file /data/data/metadata.csv \
--germline_path /data/data/immcantation/germlines \
--density_method 'density' \
--default_threshold '0.1' \
--output_path /data/results/analysis/immcantation "


############################################
### DEFINE CLONES AND GERMLINE SEQUENCES ###
############################################
# extract mouse numbers and threshold values (columns 1 and 2, respectively) from predicted_thresholds.csv
# mouse_nums=(`awk -F "\"*,\"*" 'FNR > 1 {print $1}' $main/'analysis/immcantation/threshold_estimation/predicted_thresholds.csv'`)
# thresholds=(`awk -F "\"*,\"*" 'FNR > 1 {print $2}' $main/'analysis/immcantation/threshold_estimation/predicted_thresholds.csv'`)

# # create sequence 0 to #mice
# indx=($(seq 0 $(( ${#mouse_nums[@]} - 1 )) ))

# # for mouse in ${mouse_nums[@]}
# for i in ${indx[@]}
# do
#     # Define clones (dist = distance threshold)
#     # Output file is named "IGHV-genotyped_M#_clone-pass.tab"
#     DefineClones.py -d $main'/analysis/immcantation/genotyping/IGHV-genotyped_'${mouse_nums[$i]}'.tab' \
#     --act set \
#     --model ham \
#     --norm len \
#     --dist ${thresholds[$i]} \
#     --format changeo \
#     --outname 'IGHV-genotyped_'${mouse_nums[$i]} \
#     --log $main'/analysis/immcantation/genotyping/IGHV-genotyped_'${mouse_nums[$i]}'_DefineClones.log'

#     # Create germline sequences using genotyped sequences from TIgGER
#     # Output file is named "IGHV-genotyped_M#_germ-pass.tab"
#     CreateGermlines.py -d $main'/analysis/immcantation/genotyping/IGHV-genotyped_'${mouse_nums[$i]}'_clone-pass.tab' \
#     -g dmask \
#     --cloned \
#     -r $main'/analysis/immcantation/genotyping/IGHV_genotype_'${mouse_nums[$i]}'.fasta' \
#     $main/data/immcantation/germlines/imgt/mouse/vdj/imgt_mouse_IGHD.fasta \
#     $main/data/immcantation/germlines/imgt/mouse/vdj/imgt_mouse_IGHJ.fasta \
#     --vf V_CALL_GENOTYPED \
#     --format changeo \
#     --outname 'IGHV-genotyped_'${mouse_nums[$i]} \
#     --log $main'/analysis/immcantation/genotyping/IGHV-genotyped_'${mouse_nums[$i]}'_CreateGermlines.log'
# done

# ####################################
# ### QUANTIFY VDJ MUTATION BURDEN ###
# ####################################
# # exports results as ChangeO database file "VDJseq_mutation_quant.tab"
# Rscript $main/scripts/VDJ_analysis/02_VDJ_mutation_quant.R \
# --genotyped_path $main'/analysis/immcantation/genotyping' \
# --output_path $main'/analysis/immcantation/mutation'

# exit