#!/bin/bash
#SBATCH --job-name=process_scvi_leiden_0.8
#SBATCH --partition=gpu_a100
#SBATCH --cpus-per-task=4
#SBATCH --gpus=a100:1
#SBATCH --mem=16G
#SBATCH --time=1-00:00:00
#SBATCH --output=/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/modelos/scvi_process_leiden_0.8.log

# Cargar el módulo de Singularity
module load singularity/3.4.1

# Definir las rutas
INPUT_FILE="/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/data_integrated/integrated_with_leiden_and_markers.h5ad"
MODEL_PATH="/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/modelos/modelo_general_scvi/vae_model/"
OUTPUT_FILE="/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/Analisis_expresion_differencial/markers_leiden.pkl"
CONTAINER_PATH="/data/scratch/LAB/enric/TFM_enric/Contenedores/scvi-tools.sif"

# Crear el directorio de salida si no existe
mkdir -p $(dirname "${OUTPUT_FILE}")

# Ejecutar el código dentro del contenedor de Singularity
singularity exec --nv --bind /data:/data $CONTAINER_PATH \
python -c "
import anndata as ad
import scvi
import torch
import pickle

# Verificar el uso de la GPU
print('CUDA disponible:', torch.cuda.is_available())
if torch.cuda.is_available():
    print('Usando GPU:', torch.cuda.get_device_name(0))
else:
    print('Usando CPU')

# Cargar el objeto AnnData
adata = ad.read_h5ad('${INPUT_FILE}')

# Verificar que 'leiden_0.8' existe en los datos cargados
print('Columnas disponibles en adata.obs:', adata.obs.columns)
if 'leiden_0.8' not in adata.obs.columns:
    raise KeyError('leiden_0.8 no está presente en adata.obs')

# Cargar el modelo entrenado desde el contenedor
model = scvi.model.SCVI.load('${MODEL_PATH}')

# Asociar el objeto AnnData al modelo cargado
model.adata = adata

# Configurar SCVI con la clave de agrupamiento 'leiden_0.8'
scvi.model.SCVI.setup_anndata(adata, labels_key='leiden_0.8')

# Realizar la expresión diferencial
markers_scvi = model.differential_expression(groupby='leiden_0.8')

# Guardar los resultados de la expresión diferencial
with open('${OUTPUT_FILE}', 'wb') as f:
    pickle.dump(markers_scvi, f)
"

# Comprobar si el archivo de salida se generó correctamente
if [ ! -f "${OUTPUT_FILE}" ]; then
    echo "Error: Los resultados de la expresión diferencial no se encontraron en ${OUTPUT_FILE}"
    exit 1
fi
