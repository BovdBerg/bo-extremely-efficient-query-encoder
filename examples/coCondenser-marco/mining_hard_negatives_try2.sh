### Encode
# mkdir -p encoding/corpus
# mkdir -p encoding/query
# echo "Encode corpus"
# for i in $(seq -f "%02g" 0 9)
# do
# echo "...Encoding split ${i}"
# python -m tevatron.driver.encode \
#   --output_dir ./retriever_model \
#   --model_name_or_path ./retriever_model_s1 \
#   --fp16 \
#   --per_device_eval_batch_size 128 \
#   --encode_in_path marco/bert/corpus/split${i}.json \
#   --encoded_save_path encoding/corpus/split${i}.pt
# done

# echo "Encode queries"
# python -m tevatron.driver.encode \
#   --output_dir ./retriever_model \
#   --model_name_or_path ./retriever_model_s1 \
#   --fp16 \
#   --q_max_len 32 \
#   --encode_is_qry \
#   --per_device_eval_batch_size 128 \
#   --encode_in_path marco/bert/query/train.query.json \
#   --encoded_save_path encoding/query/train.pt


### Index Search
echo "Indexing"
python -m tevatron.faiss_retriever \
  --query_reps encoding/query/train.pt \
  --passage_reps encoding/corpus/'*.pt' \
  --batch_size 5000 \
  --save_text \
  --save_ranking_to train.rank.tsv

# Build HN train file
echo "Build HN train file"
bash create_hn.sh
