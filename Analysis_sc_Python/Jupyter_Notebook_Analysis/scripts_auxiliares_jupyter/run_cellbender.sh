#!/bin/bash
#SBATCH --job-name=cellbender_job          
#SBATCH --partition=gpu_a100  # Usar nodos de cómputo INTEL con GPU A100
#SBATCH --cpus-per-task=12  # Asignar 12 núcleos para la tarea
#SBATCH --cores-per-socket=12  # Asegurar que los núcleos se asignen en el mismo socket
#SBATCH --gpus=a100:1  # Usar una GPU A100 de NVIDIA        
#SBATCH --mem=64G  # Asignar 64 GB de memoria RAM                        
#SBATCH --time=3-00:00:00  # Tiempo máximo de ejecución (3 días)                  
#SBATCH --output=cellbender_%j.log  # Guardar el output en un archivo de log

# Inicializar Conda
eval "$(~/miniforge3/bin/conda shell.bash hook)"
conda activate cb

# Crear el directorio de salida si no existe
output_dir="/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/matrices_corregidas_cellbender/"
mkdir -p "$output_dir"

# Rutas de los archivos sin filtrar proporcionados por CellRanger
raw_files=(
    "/data/scratch/LAB/enric/TFM_enric/000_Cellranger_8/Mouse_44-final/outs/multi/count/raw_feature_bc_matrix.h5"
    "/data/scratch/LAB/enric/TFM_enric/000_Cellranger_8/Mouse_45-final/outs/multi/count/raw_feature_bc_matrix.h5"
    "/data/scratch/LAB/enric/TFM_enric/000_Cellranger_8/Mouse_48-final/outs/multi/count/raw_feature_bc_matrix.h5"
    "/data/scratch/LAB/enric/TFM_enric/000_Cellranger_8/Mouse_49-final/outs/multi/count/raw_feature_bc_matrix.h5"
    "/data/scratch/LAB/enric/TFM_enric/000_Cellranger_8/Mouse_50-final/outs/multi/count/raw_feature_bc_matrix.h5"
    "/data/scratch/LAB/enric/TFM_enric/000_Cellranger_8/Mouse_52-final/outs/multi/count/raw_feature_bc_matrix.h5"
)

# Nombres base para los ratones
mouse_names=(
    "Mouse_44"
    "Mouse_45"
    "Mouse_48"
    "Mouse_49"
    "Mouse_50"
    "Mouse_52"
)

# Procesar cada archivo sin filtrar
for i in "${!raw_files[@]}"; do
    file="${raw_files[$i]}"
    mouse_name="${mouse_names[$i]}"

    cellbender remove-background \
    --input "$file" \
    --output "$output_dir/${mouse_name}_denoised.h5" \
    --cuda
done

# Desactivar el entorno Conda
conda deactivate

