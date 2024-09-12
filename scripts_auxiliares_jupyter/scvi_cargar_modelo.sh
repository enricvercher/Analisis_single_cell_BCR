#!/bin/bash
#SBATCH --job-name=load_scvi_model
#SBATCH --partition=gpu_a100
#SBATCH --cpus-per-task=1
#SBATCH --gpus=a100:1
#SBATCH --mem=4G
#SBATCH --time=3-00:00:00
#SBATCH --output=/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/modelos/carga_modelo_general.log

# Cargar el módulo de Singularity
module load singularity/3.4.1

# Definir las rutas
MODEL_PATH="/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/modelos/modelo_general_scvi/vae_model/"
CONTAINER_PATH="/data/scratch/LAB/enric/TFM_enric/Contenedores/scvi-tools.sif"
INPUT_PATH="/data/scratch/LAB/enric/TFM_enric/03_Analisis_scRNAseq_python/processed_data/adata_mixto_processed.h5ad"

# Ejecutar el código dentro del contenedor de Singularity
singularity exec --nv --bind /data:/data $CONTAINER_PATH \
python -c "
import anndata as ad
import torch
import scvi

# Comprobar si CUDA está disponible
print('CUDA disponible:', torch.cuda.is_available())
if torch.cuda.is_available():
    print('Dispositivo:', torch.cuda.get_device_name(0))

# Cargar el objeto AnnData preprocesado
adata = ad.read_h5ad('${INPUT_PATH}')

# Cargar el modelo SCVI ya entrenado
model = scvi.model.SCVI.load('${MODEL_PATH}', adata=adata)

# El modelo queda cargado en memoria y listo para su uso
print('Modelo SCVI cargado correctamente.')
"
