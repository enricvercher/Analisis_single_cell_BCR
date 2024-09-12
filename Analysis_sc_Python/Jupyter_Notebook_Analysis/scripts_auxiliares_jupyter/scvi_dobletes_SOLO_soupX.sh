#!/bin/bash
#SBATCH --job-name=training_solo_combined_array
#SBATCH --partition=gpu_a100
#SBATCH --cpus-per-task=6
#SBATCH --gpus=a100:1
#SBATCH --mem=20G
#SBATCH --time=3-00:00:00
#SBATCH --array=0-5
#SBATCH --output=/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/predicciones_dobletes/combined_array_%A_%a.log        

# Cargar el módulo de Singularity
module load singularity/3.4.1

# Definir las rutas a los archivos preprocesados
INPUT_FILES=(
    "/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/predicciones_dobletes/process_for_doublets/Mouse_44_preprocessed_SoupX.h5ad"
    "/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/predicciones_dobletes/process_for_doublets/Mouse_45_preprocessed_SoupX.h5ad"
    "/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/predicciones_dobletes/process_for_doublets/Mouse_48_preprocessed_SoupX.h5ad"
    "/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/predicciones_dobletes/process_for_doublets/Mouse_49_preprocessed_SoupX.h5ad"
    "/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/predicciones_dobletes/process_for_doublets/Mouse_50_preprocessed_SoupX.h5ad"
    "/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/predicciones_dobletes/process_for_doublets/Mouse_52_preprocessed_SoupX.h5ad"
)

MOUSE_NAMES=("Mouse_44" "Mouse_45" "Mouse_48" "Mouse_49" "Mouse_50" "Mouse_52")

INPUT_FILE=${INPUT_FILES[$SLURM_ARRAY_TASK_ID]}
MOUSE_NAME=${MOUSE_NAMES[$SLURM_ARRAY_TASK_ID]}

OUTPUT_MODEL_DIR="/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/modelos/modelos_solo/${MOUSE_NAME}"
OUTPUT_PREDICTION_DIR="/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/predicciones_dobletes/${MOUSE_NAME}"

# Crear los directorios de salida si no existen
mkdir -p $OUTPUT_MODEL_DIR
mkdir -p $OUTPUT_PREDICTION_DIR

# Ejecutar el código dentro del contenedor de Singularity
singularity exec --nv --bind /data:/data /data/scratch/LAB/enric/TFM_enric/Contenedores/scvi-tools.sif \
python -c "
import scvi
import pandas as pd

# Cargar los datos preprocesados del ratón
adata = scvi.data.read_h5ad('${INPUT_FILE}')

# Configurar SCVI y entrenar el modelo
scvi.model.SCVI.setup_anndata(adata)
vae = scvi.model.SCVI(adata)
vae.train()

# Guardar el modelo entrenado
vae.save('${OUTPUT_MODEL_DIR}/vae_model/', save_anndata=True, overwrite=True)

# Cargar el modelo entrenado para usar SOLO
vae = scvi.model.SCVI.load('${OUTPUT_MODEL_DIR}/vae_model/')

# Crear y entrenar el modelo SOLO
solo = scvi.external.SOLO.from_scvi_model(vae)
solo.train()

# Realizar predicciones
df = solo.predict()
df['prediction'] = solo.predict(soft=False)

# Guardar las predicciones en un archivo CSV
df.to_csv('${OUTPUT_PREDICTION_DIR}/solo_predictions_soupX.csv', index=True)
"

# Comprobar si SOLO se ejecutó correctamente
if [ ! -f "${OUTPUT_PREDICTION_DIR}/solo_predictions_soupX.csv" ]; then
    echo "Error: El archivo de predicciones SOLO no se encontró en ${OUTPUT_PREDICTION_DIR}/solo_predictions_soupX.csv"
    exit 1
fi
