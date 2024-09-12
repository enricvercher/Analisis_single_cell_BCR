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

singularity exec -B $DATADIR:/data $SINGULARITY  bash -c "\
Rscript -e 'library(dplyr); \
library(alakazam); \
library(igraph); \
results_isotype_germ_cluster <- airr::read_rearrangement("/data/results/lineage_alakazam_m44/results_germline_subset.tab"); \
largest_clone <- dplyr::countClones(results_isotype_germ_cluster) %>% dplyr::slice(2) %>% dplyr::select(clone_id) %>% as.character(); \
db_clone <- subset(results_isotype_germ_cluster, clone_id == largest_clone); \
x <- makeChangeoClone(db_clone, v_call = "v_call", text_fields = "c_call"); \
g <- buildPhylipLineage(x, phylip_exec = "/usr/local/bin/dnapars"); \
pdf("/data/clone_tree.pdf"); \'"