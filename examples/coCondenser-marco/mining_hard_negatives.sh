#!/bin/bash

### Encode
mkdir -p encoding/corpus
mkdir -p encoding/query
echo "Encode corpus"
for i in $(seq -f "%02g" 0 9)
do
echo "...Encoding split ${i}"
python -m tevatron.driver.encode \
  --output_dir ./retriever_model \
  --model_name_or_path Luyu/co-condenser-marco \
  --fp16 \
  --per_device_eval_batch_size 128 \
  --encode_in_path marco/bert/corpus/split${i}.json \
  --encoded_save_path encoding/corpus/split${i}.pt
done

echo "Encode queries"
python -m tevatron.driver.encode \
  --output_dir ./retriever_model \
  --model_name_or_path Luyu/co-condenser-marco \
  --fp16 \
  --q_max_len 32 \
  --encode_is_qry \
  --per_device_eval_batch_size 128 \
  --encode_in_path marco/bert/query/train.query.json \
  --encoded_save_path encoding/query/train.pt


################ 
# CHUNK APPROACH
# E.g. for msm-psg
################
### Index Search
# echo "Index Search on chunk using Faiss"
# NUM_CHUNKS=$1
# CHUNK_ID=$2
# python -m tevatron.faiss_retriever \
#   --query_reps encoding/query/train.pt \
#   --passage_reps encoding/corpus/'*.pt' \
#   --batch_size 5000 \
#   --depth 200 \
#   --save_text \
#   --save_ranking_to train_${CHUNK_ID}.rank.tsv \
#   --num_chunks $NUM_CHUNKS \
#   --chunk_id $CHUNK_ID \

# # Merge chunks
# echo "Merge chunks"
# python -m tevatron.faiss_retriever \
#   --query_reps encoding/query/train.pt \
#   --passage_reps encoding/corpus/'*.pt' \
#   --batch_size 5000 \
#   --depth 200 \
#   --save_text \
#   --save_ranking_to train_${CHUNK_ID}.rank.tsv \
#   --num_chunks $NUM_CHUNKS \
#   --chunk_id $CHUNK_ID \
#   --merge_chunks


################
# NORMAL APPROACH
################
python -m tevatron.faiss_retriever \
  --query_reps encoding/query/train.pt \
  --passage_reps encoding/corpus/'*.pt' \
  --batch_size 5000 \
  --depth 200 \
  --save_text \
  --save_ranking_to train.rank.tsv


############################
# CONTINUE FROM HERE
############################

# Build HN train file
echo "Build HN train file"
# Copied from create_hn.sh:
SCRIPT_DIR=$PWD
TOKENIZER=bert-base-uncased
TOKENIZER_ID=bert
HN_DIR=$TOKENIZER_ID/train-hn

cd marco
mkdir -p $HN_DIR
python $SCRIPT_DIR/build_train_hn.py \
  --tokenizer_name $TOKENIZER \
  --hn_file ../train.rank.tsv \
  --qrels qrels.train.tsv \
  --queries train.query.txt \
  --collection corpus.tsv \
  --save_to $HN_DIR
  # parser.add_argument('--tokenizer_name', required=True)
  # parser.add_argument('--hn_file', required=True)
  # parser.add_argument('--qrels', required=True)
  # parser.add_argument('--queries', required=True)
  # parser.add_argument('--collection', required=True)
  # parser.add_argument('--save_to', required=True)
  # parser.add_argument('--truncate', type=int, default=128)
  # parser.add_argument('--n_sample', type=int, default=30)
  # parser.add_argument('--depth', type=int, default=200)
  # parser.add_argument('--mp_chunk_size', type=int, default=500)
  # parser.add_argument('--shard_size', type=int, default=45000)

ln -s $TOKENIZER_ID/train/* $HN_DIR
cd -
