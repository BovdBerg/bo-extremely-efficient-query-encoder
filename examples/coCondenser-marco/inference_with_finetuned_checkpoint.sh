### Encode
mkdir -p encoding/corpus
mkdir -p encoding/query
echo "Encode corpus"
for i in $(seq -f "%02g" 0 9)
do
echo "...Encoding split ${i}"
python -m tevatron.driver.encode \
  --output_dir ./retriever_model \
  --model_name_or_path Luyu/co-condenser-marco-retriever \
  --fp16 \
  --per_device_eval_batch_size 128 \
  --encode_in_path marco/bert/corpus/split${i}.json \
  --encoded_save_path encoding/corpus/split${i}.pt
done

echo "Encode queries"
python -m tevatron.driver.encode \
  --output_dir ./retriever_model \
  --model_name_or_path Luyu/co-condenser-marco-retriever \
  --fp16 \
  --q_max_len 32 \
  --encode_is_qry \
  --per_device_eval_batch_size 128 \
  --encode_in_path marco/bert/query/dev.query.json \
  --encoded_save_path encoding/query/qry.pt

### Index Search
echo "Indexing"
python -m tevatron.faiss_retriever \
    --query_reps encoding/query/qry.pt \
    --passage_reps encoding/corpus/'*.pt' \
    --depth 10 \
    --batch_size -1 \
    --save_text \
    --save_ranking_to rank.tsv

# Format the retrieval result
echo "Formatting"
python score_to_marco.py rank.tsv
