### Encode
mkdir -p encoding/corpus-s2
mkdir -p encoding/query-s2
echo "Encode corpus"
for i in $(seq -f "%02g" 0 9)
do
python -m tevatron.driver.encode \
  --output_dir ./retriever_model_s2 \
  --model_name_or_path ./retriever_model_s2 \
  --fp16 \
  --per_device_eval_batch_size 128 \
  --encode_in_path marco/bert/corpus/split${i}.json \
  --encoded_save_path encoding/corpus-s2/split${i}.pt
done

echo "Encode queries"
python -m tevatron.driver.encode \
  --output_dir  ./retriever_model_s2 \
  --model_name_or_path  ./retriever_model_s2 \
  --fp16 \
  --q_max_len 32 \
  --encode_is_qry \
  --per_device_eval_batch_size 128 \
  --encode_in_path marco/bert/query/dev.query.json \
  --encoded_save_path encoding/query-s2/qry.pt

# Run the retriever
echo "Indexing"
python -m tevatron.faiss_retriever \
    --query_reps encoding/query-s2/qry.pt \
    --passage_reps encoding/corpus-s2/'*.pt' \
    --depth 10 \
    --batch_size -1 \
    --save_text \
    --save_ranking_to dev.rank.tsv

# Format the retrieval result
echo "Format the retrieval result"
python score_to_marco.py dev.rank.tsv
