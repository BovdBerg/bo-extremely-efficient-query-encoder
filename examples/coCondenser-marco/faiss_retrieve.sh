#!/bin/bash

# RUN THIS FILE WITH PARAMS: `bash faiss_retrieve.sh <NUM_CHUNKS> <CHUNK_ID>`
NUM_CHUNKS=$1
CHUNK_ID=$2

sbatch <<EOT
#!/bin/bash
#
#SBATCH --job-name=$CHUNK_ID"_faiss"
#SBATCH --time=20:00:00
#SBATCH --partition=compute
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=128G
#SBATCH --account=education-eemcs-msc-cs

module purge
module load slurm/current DefaultModules
module load 2023r1 miniconda3

conda activate extremely-efficient

cd /scratch/bovandenberg/extremely-efficient-query-encoder/examples/coCondenser-marco

srun python -m tevatron.faiss_retriever \
  --query_reps encoding/query/train.pt \
  --passage_reps encoding/corpus/'*.pt' \
  --batch_size 5000 \
  --depth 200 \
  --save_text \
  --save_ranking_to train_${CHUNK_ID}.rank.tsv \
  --num_chunks $NUM_CHUNKS \
  --chunk_id $CHUNK_ID
EOT
